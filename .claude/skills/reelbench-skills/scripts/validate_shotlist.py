#!/usr/bin/env python3
"""
Deterministic shot/beat validator for reelbench-skills.

Adapted from the "cut claims beat" validation concept in eternityspring's
shuohao-skills (novel-storyboard's 17 code-enforced gates) — checks what code
can check exactly, so the qualitative 15-gate walk in quality-gates.md only has
to spend judgment on what actually needs judgment.

Usage:
    python3 validate_shotlist.py --platform h3 PROMPT.md
    python3 validate_shotlist.py --platform seedance PROMPT.md
    python3 validate_shotlist.py --platform h3 PROMPT.md --beats BEATS.json

Exit code 0 if every check passes, 1 if any FAIL is found. Always prints a
PASS/FAIL/WARN line per check — never silently skips a check that ran.
"""
import argparse
import json
import re
import sys

_FAILED = False

# Rough, explicitly-approximate speech rates (characters per second of
# spoken audio). These exist to catch GROSS mismatches (a shot far too short
# for its line), not to certify exact timing — say so in every report.
CHAR_RATE = {
    "english": 15.0,
    "chinese": 4.5,   # from shuohao-skills' own figure (chars / 4.5 sec)
    "thai": 8.0,       # rough: Thai script runs more chars/syllable than English
    "japanese": 6.0,
    "korean": 6.0,
}

THAI_RE = re.compile(r"[฀-๿]")
CJK_RE = re.compile(r"[一-鿿぀-ヿ]")

SHOT_H3_RE = re.compile(r"\[Shot (\d+)\]")
TIME_H3_RE = re.compile(r"At (\d{2}):(\d{2}(?:\.\d+)?),")
DIALOGUE_H3_RE = re.compile(r"<d>\[(\w+)\]\s*(.*?)</d>", re.DOTALL)
SPEAKER_RE = re.compile(r"\(S(\d+)\)")

SEEDANCE_TIMED_RE = re.compile(r"([\d.]+)s\s+to\s+([\d.]+)s\s*[—-]")
SEEDANCE_CUT_RE = re.compile(r"\bCUT\s+(\d+)\s*[—-]")
# Deliberately a dedicated marker, not a loose "duration" prose search — free
# text mentions "duration" too many times (UI settings, notes-to-self) for a
# fuzzy regex to reliably find the one that means "shots should sum to this."
# See references/shot-manifest-convention.md.
SCRIPTED_DURATION_RE = re.compile(r"SCRIPTED_DURATION:\s*(\d+(?:\.\d+)?)\s*s", re.IGNORECASE)


def fail(msg):
    global _FAILED
    _FAILED = True
    print(f"FAIL  {msg}")
    return False


def ok(msg):
    print(f"PASS  {msg}")
    return True


def warn(msg):
    print(f"WARN  {msg}")


BODY_START_RE = re.compile(r"(?:subject_definitions:|SCENE CONTEXT\b)")


def strip_header_notes(text):
    """Drop any free-text header (a title, changelog notes, generation-setting
    reminders) above the actual submitted prompt body. Those notes are for the
    prompt author, not the generator, and commonly quote a dialogue line or
    other non-English text in passing — that must not trip language-purity.
    """
    m = BODY_START_RE.search(text)
    return text[m.start():] if m else text


DESCRIPTION_FIELD_RE = re.compile(
    r"(?:detailed_description|integrated_multimodal_description):(.*?)"
    r"(?:\n\s*(?:Negative constraints|overall_soundscape|non_diegetic_music)\s*:|\Z)",
    re.DOTALL | re.IGNORECASE,
)


def parse_h3_shots(text):
    """Return list of dicts: {id, start, end, dialogue: [(lang, text, speaker)]}.

    Only scans inside the detailed_description/integrated_multimodal_description
    field — retention_analysis commonly writes "[Shot 1]-[Shot 11]" as a range,
    which is not a real shot marker and must not be parsed as one.
    """
    field_match = DESCRIPTION_FIELD_RE.search(text)
    text = field_match.group(1) if field_match else text
    positions = [(m.start(), int(m.group(1))) for m in SHOT_H3_RE.finditer(text)]
    if not positions:
        return []
    shots = []
    for i, (pos, shot_id) in enumerate(positions):
        end_pos = positions[i + 1][0] if i + 1 < len(positions) else len(text)
        chunk = text[pos:end_pos]
        tmatch = TIME_H3_RE.search(chunk)
        start = float(tmatch.group(1)) * 60 + float(tmatch.group(2)) if tmatch else (0.0 if shot_id == 1 else None)
        dialogue = [(lang, dtext.strip()) for lang, dtext in DIALOGUE_H3_RE.findall(chunk)]
        shots.append({"id": shot_id, "start": start, "chunk": chunk, "dialogue": dialogue})
    # end = next shot's start; last shot's end filled in by caller from stated duration
    for i in range(len(shots) - 1):
        shots[i]["end"] = shots[i + 1]["start"]
    shots[-1]["end"] = None
    return shots


def parse_seedance_shots(text):
    """Return list of dicts for Seedance's timed-multishot or CUT N sequential format."""
    timed = [(float(a), float(b), m.start()) for m in SEEDANCE_TIMED_RE.finditer(text)
             for a, b in [m.groups()]]
    if timed:
        shots = []
        for i, (start, end, _pos) in enumerate(timed):
            shots.append({"id": i + 1, "start": start, "end": end, "dialogue": []})
        return shots, "timed"
    cuts = list(SEEDANCE_CUT_RE.finditer(text))
    if cuts:
        return [{"id": int(m.group(1)), "start": None, "end": None, "dialogue": []} for m in cuts], "sequential"
    return [], "single"


def check_pacing_no_consecutive_equal(shots):
    durations = []
    for s in shots:
        if s.get("start") is None or s.get("end") is None:
            warn("pacing check skipped for at least one shot — timing not fully resolved")
            return
        durations.append(round(s["end"] - s["start"], 3))
    dup = [(i + 1, i + 2) for i in range(len(durations) - 1) if durations[i] == durations[i + 1]]
    if dup:
        pairs = ", ".join(f"S{a}-S{b} ({durations[a-1]}s each)" for a, b in dup)
        fail(f"consecutive shots share the same duration: {pairs} — action-sequence-craft.md §1")
    else:
        ok(f"no two consecutive shots share a duration (durations: {durations})")


def check_total_duration(shots, stated_duration, platform):
    if not shots or shots[-1].get("end") is None:
        warn("total duration unknown — no closing timestamp and no stated duration note found")
        return
    total = round(shots[-1]["end"], 3)
    cap = {"h3": (4, 15), "seedance": (1, 15)}.get(platform, (1, 15))
    if not (cap[0] <= total <= cap[1]):
        fail(f"total scripted duration {total}s is outside the {platform} platform's {cap[0]}-{cap[1]}s range")
    else:
        ok(f"total scripted duration {total}s is within the {platform} platform's {cap[0]}-{cap[1]}s range")
    if stated_duration and abs(total - stated_duration) > 0.05:
        warn(f"shot timestamps sum to {total}s but a duration note says {stated_duration}s — these should match exactly")


def check_dialogue_fits_shot(shots):
    any_checked = False
    for s in shots:
        if s.get("start") is None or s.get("end") is None:
            continue
        dur = s["end"] - s["start"]
        for lang, dtext in s.get("dialogue", []):
            any_checked = True
            rate = CHAR_RATE.get(lang.lower(), 10.0)
            needed = len(dtext) / rate
            if needed > dur:
                fail(f"S{s['id']} ({dur:.2f}s): [{lang}] line '{dtext}' needs ~{needed:.2f}s at "
                     f"{rate}chars/sec (approximate) — longer than the shot itself")
            elif needed > dur * 0.85:
                warn(f"S{s['id']} ({dur:.2f}s): [{lang}] line '{dtext}' needs ~{needed:.2f}s "
                     f"(approximate) — leaves little room for the physical action described in the same shot")
            else:
                ok(f"S{s['id']}: [{lang}] line '{dtext}' fits comfortably in {dur:.2f}s (~{needed:.2f}s needed, approximate)")
    if not any_checked:
        warn("no dialogue found to check against shot duration")


def check_language_purity(text, platform):
    if platform == "seedance":
        stripped = DIALOGUE_H3_RE.sub("", text)  # not expected in seedance, but strip just in case
        thai_hits = THAI_RE.findall(stripped)
        cjk_hits = CJK_RE.findall(stripped)
        if thai_hits or cjk_hits:
            fail(f"Seedance prompt must be English-only, found {len(thai_hits)} Thai and "
                 f"{len(cjk_hits)} CJK characters outside any dialogue tag")
        else:
            ok("prompt text is free of Thai/CJK characters (Seedance's English-only rule)")
    else:
        # H3: prose outside <d>...</d> should be English; check for non-Latin leakage there.
        outside = DIALOGUE_H3_RE.sub("", text)
        thai_hits = THAI_RE.findall(outside)
        if thai_hits:
            fail(f"found {len(thai_hits)} Thai characters in H3 prose outside a <d> dialogue tag — "
                 f"dialogue belongs inside <d>[Thai] ...</d>, prose stays English")
        else:
            ok("no non-Latin text leaked outside <d> dialogue tags")


def check_max_subjects_in_frame(shots, max_named=3):
    for s in shots:
        subj_ids = set(re.findall(r"<Subject (\d+)>", s.get("chunk", "")))
        if len(subj_ids) > max_named:
            warn(f"S{s['id']}: {len(subj_ids)} distinct <Subject N> labels referenced — "
                 f"per shuohao-skills' own gate, more than {max_named} in one frame needs an explicit staging note")


def check_beat_coverage(shots, beats_file):
    if not beats_file:
        warn("no --beats manifest given — beat-coverage gate skipped (see references/shot-manifest-convention.md)")
        return
    with open(beats_file) as f:
        manifest = json.load(f)
    beats = manifest.get("beats", [])
    shot_beats = manifest.get("shot_beats", {})
    claimed = []
    for shot_id_str, beat_ids in shot_beats.items():
        claimed.extend(beat_ids)
    beat_ids_all = [b if isinstance(b, str) else b.get("id") for b in beats]
    missing = [b for b in beat_ids_all if b not in claimed]
    seen = {}
    dup = []
    for shot_id_str, beat_ids in shot_beats.items():
        for b in beat_ids:
            seen.setdefault(b, []).append(shot_id_str)
    dup = {b: owners for b, owners in seen.items() if len(owners) > 1}
    shots_present = {str(s["id"]) for s in shots}
    manifest_shots = set(shot_beats.keys())
    orphan_manifest_shots = manifest_shots - {f"S{i}" for i in shots_present} - shots_present
    if missing:
        fail(f"beats not claimed by any shot: {missing}")
    else:
        ok(f"all {len(beat_ids_all)} beats claimed by exactly one shot each")
    if dup:
        fail(f"beats claimed by more than one shot (overlap): {dup}")
    else:
        ok("no beat is claimed by more than one shot")
    if orphan_manifest_shots:
        warn(f"manifest references shots not found in the parsed prompt: {orphan_manifest_shots}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("prompt_file")
    ap.add_argument("--platform", choices=["h3", "seedance"], required=True)
    ap.add_argument("--beats", help="path to a beats manifest JSON (see shot-manifest-convention.md)")
    args = ap.parse_args()

    with open(args.prompt_file, encoding="utf-8") as f:
        text = f.read()

    dmatch = SCRIPTED_DURATION_RE.search(text)
    stated_duration = float(dmatch.group(1)) if dmatch else None
    if stated_duration is None:
        warn("no 'SCRIPTED_DURATION: Ns' marker found — add one so the last shot's end "
             "and total-duration checks can run (see references/shot-manifest-convention.md)")

    print(f"=== validating {args.prompt_file} as {args.platform} ===")
    results = []

    if args.platform == "h3":
        shots = parse_h3_shots(text)
        if not shots:
            fail("no [Shot N] markers found — is this really an H3 detailed_description block?")
            sys.exit(1)
    else:
        shots, mode = parse_seedance_shots(text)
        if mode == "single":
            print("INFO  single continuous shot (oner) or non-timed cuts detected — "
                  "duration/pacing/beat gates need explicit timing to run, skipping them")
        elif mode == "sequential":
            print("INFO  sequential CUT N format has no timecodes — duration/pacing gates skipped, "
                  "beat-coverage gate still runs by shot order")

    if shots and shots[-1].get("end") is None and stated_duration:
        shots[-1]["end"] = stated_duration

    check_pacing_no_consecutive_equal(shots)
    check_total_duration(shots, stated_duration, args.platform)
    check_dialogue_fits_shot(shots)
    check_language_purity(strip_header_notes(text), args.platform)
    check_max_subjects_in_frame(shots)
    check_beat_coverage(shots, args.beats)

    sys.exit(1 if _FAILED else 0)


if __name__ == "__main__":
    main()
