# Shot-Manifest Convention & the Deterministic Validator

Adapted from eternityspring's `shuohao-skills` — specifically `novel-storyboard`'s
"镜头认领节拍" (cuts claim beats) convention and its 17 code-enforced gates. That
project validates a structured `storyboard.json` with a real script (`validate`
command); this project's downstream skills write freeform prose prompts, not JSON,
so the deterministic checks that transfer cleanly are pulled out into
`scripts/validate_shotlist.py` and run directly against the prompt text, with an
optional small sidecar manifest for the one check that prose alone can't carry:
beat coverage.

## Why this exists

Phase 3 QA in `SKILL.md` walks the 15 gates in `quality-gates.md` by reading and
judging — appropriate for anything that needs actual cinematic judgment (does this
angle carry the right emotion, does this cut match the brief's rhythm). But several
checks don't need judgment at all: does a shot's own duration actually fit its
dialogue, do two consecutive shots share a duration, does the total add up to a
number the target platform accepts, does every beat get covered exactly once. A
human (or an LLM) re-deriving these by eye is slower and less reliable than a script
that just computes them. Run the script first — it's exact where it applies, and it
tells you plainly what it couldn't check rather than guessing.

## Running it

```bash
python3 references/../scripts/validate_shotlist.py --platform h3 PROMPT.md
python3 references/../scripts/validate_shotlist.py --platform seedance PROMPT.md
python3 .../scripts/validate_shotlist.py --platform h3 PROMPT.md --beats BEATS.json
```

It prints one `PASS` / `FAIL` / `WARN` line per check and exits non-zero if any
check `FAIL`s. `WARN` means a check couldn't fully run (usually missing timing or
a missing manifest) — read those as "this gate needs more information," not as a
pass.

## What it checks, and why each one is safe to compute rather than judge

| Check | What it computes | Maps to |
|---|---|---|
| Pacing | No two consecutive shots share a duration | `action-sequence-craft.md` §1 |
| Total duration | Timestamps sum to a value inside the target platform's range (H3: 4–15s, Seedance: ≤15s) | Platform spec; `action-sequence-craft.md` §4 (the confirmed +1.5s overrun) |
| Dialogue-fits-shot | Line length ÷ an approximate chars/sec rate stays inside the shot's own duration | New — see below |
| Language purity | H3: no non-Latin text leaks outside `<d>...</d>`. Seedance: no non-Latin text anywhere (Seedance prompts are English-only per `seedance-clean`) | Platform spec |
| Max subjects in frame | Flags >3 distinct `<Subject N>` labels in one shot | `shuohao-skills`' own gate (max 3 people per frame without an explicit staging note) |
| Beat coverage | Every beat in the manifest is claimed by exactly one shot — no gaps, no overlaps | `shuohao-skills`' "cuts claim beats" gate |

**The dialogue-fits-shot rates are explicitly approximate**, not calibrated per
voice or delivery speed — they exist to catch a line that's *grossly* too long for
its shot (the kind of mismatch that forces a generation to either rush the line or
run over), not to certify exact timing. Current rates (chars/sec): English 15,
Chinese 4.5 (from `shuohao-skills`' own figure), Thai 8, Japanese/Korean 6. Treat a
`FAIL` here as "rewrite this line shorter or give the shot more time," and a `WARN`
(over 85% of the shot's duration) as "this is tight, watch it in the actual
generation."

## The `SCRIPTED_DURATION:` marker

Add one line near the top of the prompt file (outside the actual fields sent to
the generator — it's for this validator only):

```
SCRIPTED_DURATION: 13.5s
```

The validator deliberately does **not** try to guess the intended total duration
from loose prose — a real prompt in this project mentions "duration" several times
(a UI-setting note, a rationale paragraph) and a fuzzy search picked up the wrong
one. One unambiguous marker line is more reliable than parsing intent out of prose.

## The beats manifest (`--beats BEATS.json`)

Optional, and only needed to run the beat-coverage gate. A small JSON file, kept
alongside the prompt but never sent to the generator:

```json
{
  "beats": [
    {"id": "B1", "text": "she flees the market stall"},
    {"id": "B2", "text": "he shouts for her to stop"},
    {"id": "B3", "text": "the vault over the fruit stall"}
  ],
  "shot_beats": {
    "1": ["B1"],
    "2": ["B2"],
    "3": ["B3"]
  }
}
```

`shot_beats` keys are shot numbers as they appear in the prompt (`[Shot 1]` → `"1"`,
or Seedance's `CUT 1` → `"1"`). Each beat should appear in exactly one shot's list —
the validator flags any beat that's missing (a gap) or claimed twice (an overlap).

Keep the manifest's `beats` list as the actual dramatic beats of the underlying
script/brief, not a restatement of the shots themselves — the point of the check is
confirming the shots actually cover the story, not confirming the shots exist.

## When to use this vs. the qualitative 15-gate walk

Run the validator **first**, before the qualitative walk in `quality-gates.md` —
fix everything it flags, then spend judgment-based QA time on what it can't check
(camera-emotion fidelity, rhythm, whether an exclusive-framing constraint will
actually read as intended). Don't skip the qualitative walk because the validator
passed — it only covers what's listed above, not all 15 gates.
