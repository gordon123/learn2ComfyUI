---
name: reelbench-skills
description: Cinematic-continuity coach and router for the prompt-writing skill family (minimax-h3-shotlist-director, minimax-h3-prompt-writing, seedance-shotlist-director, seedance-director, seedance-clean, seedance-footage-vfx). Learns real shot grammar from reference footage the user supplies (via ffprobe/ffmpeg scene analysis), turns it into a Continuity & Style Brief, a per-shot narrative-rhythm map (hook/setup/escalation/beat/pivot/payoff/breath/closure), a camera-emotion read (precise angle, movement quality, lens/DOF — not vague labels like "side-angle"), and a micro-expression-physics pass for any emotionally-loaded or evasive beat (physical, asymmetric reflex chains instead of mood labels or bare prohibitions — the fix for a beat that keeps rendering as a static held pose no matter how many negative constraints it gets); for action/fight/destruction scenes specifically, also applies pacing-irregularity and cumulative-environmental-damage-continuity craft rules, asks for (or recommends from the measured clip) a target generation duration, routes the actual prompt-writing task to the right downstream skill with the rhythm map and camera-emotion pairing as explicit per-shot instructions, then reviews that skill's output against a 15-point cinematic quality-gate checklist (plus rhythm-fidelity and camera-emotion-fidelity checks) before it goes to generation. Once the user has an actual generated clip back, can also build a before/after HTML comparison report (original vs. generated — side-by-side players, sampled frames, scene-change chart, prompt-fidelity table) as an Artifact. Use when the user wants a sequence of AI-video prompts (MV, ad, scene, short film) to hold together as one continuous cinematic production instead of a pile of disconnected clips, when they hand over reference footage/films and want its shot language applied to new prompts, or when they want to check a generated clip against the reference it was built from. Does not replace or edit the downstream skills — it is a separate supporting layer that briefs them, QAs their output, and reports on the result.
---

# reelbench-skills

A support layer, not a prompt writer. It never writes the final MiniMax H3 / Seedance
prompt itself — that stays the job of the skill named in the brief below. Its job is
the two things nothing else in the stack does: (1) turn real footage into a concrete,
reusable cinematic vocabulary, and (2) hold every downstream skill's output to that
vocabulary and to basic continuity so a shotlist reads as one production, not N
disconnected generations.

## When to invoke

- User hands over reference footage (a film clip, a competitor MV, a mood reel) and
  wants its shot language ("cut like this") applied to a new prompt set.
- User is about to run a multi-shot sequence across `minimax-h3-*` or `seedance-*`
  skills and wants continuity enforced (recurring characters, consistent lighting/color,
  180-degree rule, matched pacing) rather than each shot prompt written in isolation.
- User asks "which skill should I use for this" between the MiniMax H3 family and the
  Seedance family.
- User already has a shotlist/prompt set from one of those skills and wants it audited
  before spending render credits.
- User has both the reference clip and the clip a downstream skill's prompt actually
  generated, and wants a before/after comparison.

Do not invoke for a single one-off prompt with no continuity or reference-footage need —
send that straight to the relevant skill (see routing table).

## Workflow

### Phase 1 — Learn (only if reference footage is supplied)

Run shot-level analysis on the reference footage with ffprobe/ffmpeg (see
`references/footage-analysis-guide.md` for the exact commands) to extract, per shot:
duration, shot size (wide/medium/close/etc.), camera movement, cut type, and dominant
color/lighting. Aggregate into a **Continuity & Style Brief**: average shot length,
shot-size distribution, camera-movement vocabulary actually used, pacing rhythm (are
cuts accelerating/decelerating), and color/lighting throughline. When this is going
into a report, give every shot a structured field table per
`references/footage-analysis-guide.md` §6 (code-measured fields kept separate from
interpreted ones, every category label backed by stated evidence, frame pairs pulled at
15%/85% into each shot) rather than a caption paragraph — this applies even to a single
continuous take, which still gets one full row.

Then, for a multi-shot clip, assign each detected shot one **narrative-rhythm tag**
(hook/setup/escalation/beat/pivot/payoff/breath/closure) with a one-sentence reason —
see `references/narrative-rhythm.md` for the full tag definitions and how to apply
them. This is a separate layer from the Continuity & Style Brief: that brief describes
how a shot looks, the rhythm map describes what job it does in the sequence. For a
single continuous take, give the whole shot one overall tag instead of forcing
per-shot boundaries onto footage that has none.

Then read the camera language for its **emotional register**, not just its mechanics —
see `references/camera-emotion.md`. For each shot (or the whole take, single-shot),
name the precise angle (eye-level / three-quarter / pure profile / low / high / dutch
/ overhead / worm's-eye / OTS — never a vague catch-all like "side-angle," which has
already caused a real generation to diverge from its reference here), the movement
quality in emotional terms (steady handheld breathing vs jittery vs locked-static, not
just "handheld" or "static"), and the lens/DOF read if inferable. Flag explicitly if
the camera language doesn't match the apparent emotional content of the shot — that
mismatch is itself a finding.

If the footage is an action, fight, or destruction sequence, also read it against
`references/action-sequence-craft.md`: note whether shot durations vary deliberately
(no two consecutive shots the same length) and, for any recurring location across
shots, whether damage to it is accumulating and persisting rather than resetting.

If any shot carries an emotionally-loaded or evasive beat (concealment, a fast
reaction, a secret action), also read it against
`references/micro-expression-physics.md`: describe what's observed as a physical
reflex chain (trigger → involuntary reflex → secondary reaction → visible action), not
a mood label — this is what the brief needs to be specific enough to write from later.

Present the brief, the rhythm map, and the camera-emotion read to the user before
moving on — they're what the downstream skill's prompts get checked against in
Phase 3.

If no footage is supplied, skip straight to Phase 2 using the user's stated genre/tone
as the style brief instead of measured data — say explicitly that the brief is
inferred, not measured.

### Phase 2 — Route

Before handing off, settle the target duration — never leave it implicit. Every
downstream skill's format either requires a stated duration (MiniMax H3: 4-15 whole
seconds) or defaults to one if you don't give it one (Seedance: defaults to 10s, hard
cap 15s), so an unstated duration isn't a neutral omission — it's a silent guess that can come
back wrong (a real generation once came back at 18.6s, past H3's own 15s cap, from a
prompt that never named a duration). Separately, this project's own pipeline has shown
a **confirmed fixed-output pattern** — see `references/action-sequence-craft.md` §4:
four generations, four different prompts (three scripted to 15.0s, one to 13.5s), all
four came back at exactly 16.5s. Don't script shorter expecting a shorter file — that
doesn't work here — design shot count/pacing around the ~16.5s this pipeline actually
produces at its current duration setting, and say so to the user rather than treating
each new mismatch as a fresh surprise. Ask the user what duration they want; if a reference clip
was analyzed in Phase 1, offer its own measured length as the starting suggestion
(rounded to a valid value for the target platform — nearest whole second for H3,
clamped to 4-15s for either), since matching the reference's own pacing is usually the
safest default when the user hasn't said otherwise. If the user's scene needs
noticeably more beats than the reference had shots for, say so and suggest a longer
duration instead of forcing it into the reference's runtime.

Then match the task to the right skill using `references/routing-matrix.md`. Tell the
user which skill you're handing off to and why, then invoke it (via Skill tool)
carrying the Continuity & Style Brief, the confirmed duration, the rhythm map, and the
camera-emotion pairing as context for it to write against.

**Before writing a single line of the actual MiniMax H3 or Seedance prompt — including a
revision of an existing one — always invoke and read the matching downstream skill's own
reference files first, never write from memory of a previous prompt's shape.** A real
prompt in this project was written entirely from memory of an earlier generation's
format and got three things wrong that only surfaced on a direct check: a made-up
`aspect_ratio:`/`duration:` field that doesn't exist in H3's actual six-section schema
(both are generation-time settings picked in the UI/API, not prompt text), the wrong
section name (`integrated_multimodal_description` instead of `detailed_description` for
Ref2VA), and spoken dialogue written as plain quoted text instead of H3's actual
`<d>[Language] ...</d>` syntax with a stable `(S1)`/`(S2)` speaker ID. None of these are
guessable from a prior prompt's surface pattern — they only came from actually reading
`minimax-h3-prompt-writing`'s `references/base-en.md`/`ref-en.md` (or the matching
`seedance-*` skill's own reference material). Treat this as non-negotiable: invoke the
downstream skill (or open its reference file directly) before every prompt-writing or
prompt-revision pass, not just the first time in a session.

Before writing any Ref2VA prompt specifically, also check the draft against
`references/h3-official-spec-corrections.md` — verified directly against MiniMax's own
official spec, it catches three structural-syntax bugs that shipped undetected through
v5–v8: (1) "Negative constraints" is not a real seventh field — it must be folded into
the end of `detailed_description` itself; (2) `retention_analysis` shot references are a
comma-separated list (`[Shot 1], [Shot 2], [Shot 3]`), never a dash-range; (3) Ref2VA's
1–2 sentence global style opening goes *before* the `[Shot 1]` tag, not merged inside it
(that fusion is the T2VA convention, not Ref2VA's).

Also check, before handing off, whether any other loaded cinema/video-craft Claude skill
bears on this specific brief beyond the one named in the routing table — a scene with
sung/spoken lyrics may need `mv-storytelling-framework`'s brief-first reasoning even if
the user didn't ask for it by name, an ad-shaped brief benefits from `ad-clip-director`'s
hook/caption/SFX craft, a full-script job may call for `screenwriter` or
`storyboard-board` first. Read the actual skill, not just its one-line description in
the skill list — the craft rules that matter live in the file, not the summary.

For a multi-shot downstream
skill, pass the rhythm map as an explicit per-shot instruction (see
`references/narrative-rhythm.md`'s "Using it in Phase 2" section) — not just a style
note, but which shot should function as the hook, which as the payoff, and so on. Pair
every shot's rhythm tag with its camera-emotion instruction per
`references/camera-emotion.md` §7 — state the precise angle and movement quality tied
to that shot's emotion, in full sentences, never a bare technical label. For a
single-shot downstream skill, pass the one overall tag and its matching camera-emotion
instruction. Do not silently pick a skill the user didn't ask for if their ask already
names one — routing only resolves ambiguity.

For an action/fight/destruction scene, also apply `references/action-sequence-craft.md`
before handing off: state an explicit, deliberately uneven duration for each shot in
the sequence (never default every shot to the same length), and — for any location
that recurs across shots — state the damage-persistence chain explicitly (what broke,
that it stays broken, how the debris continues to settle) rather than leaving it to be
assumed.

For any shot carrying an emotionally-loaded or evasive beat, apply
`references/micro-expression-physics.md` before handing off — especially for a beat
that has already failed the same way in a prior generation. State, in the shot text
itself: the external trigger, the asymmetric physical reflex chain (§2–3 of that file),
and the specific point the eyes/attention are actually fixed on. Do not rely on a
negative constraint alone ("no held eye contact," "no posing") to fix a beat like
this — a prohibition with nothing positive to replace it just sends the model back to
its default pose; the physical chain is what actually changes the output.

### Phase 3 — QA the output

Once the downstream skill produces a shotlist or prompt set, **first run
`scripts/validate_shotlist.py`** (see `references/shot-manifest-convention.md`) against
it — pacing duplicates, total duration vs. the platform's accepted range, dialogue-vs-
shot-duration fit, language purity, max-subjects-in-frame, and (with a beats manifest)
beat coverage are all exact computations, not judgment calls, so check them by running
the script rather than reading for them. Fix everything it flags first.

Then check for the three structural-syntax bugs in
`references/h3-official-spec-corrections.md` (a standalone `Negative constraints:`
field, a dash-range in `retention_analysis`, a style sentence fused into `[Shot 1]`) —
treat any of these as a fail at the same severity as a field-name or dialogue-tag error,
not a style nitpick.

Then walk the remaining 15 qualitative gates in `references/quality-gates.md`. Report
gate-by-gate pass/fail, and for every fail give a concrete rewritten line the user can
hand back to the same skill for a targeted fix — never patch the other skill's output
yourself. Flag gates you could not check (e.g. no reference footage was given, so
color-continuity has nothing to compare against) as "not applicable" rather than
guessing.

If a rhythm map was handed off in Phase 2, also check it landed: did the shot tagged
as the beat actually read as a held pause, does the payoff shot deliver more than the
escalation before it, are six consecutive shots doing the same narrative job (the flat-
rhythm failure mode)? Report this alongside the 15 gates, not folded silently into one
of them — it's a real but separate check.

Also check camera-emotion fidelity per `references/camera-emotion.md` §8: did the
generated shot's actual angle and movement match the emotion it was instructed to
carry — not just the Continuity & Style Brief's raw vocabulary? A camera that matches
the reference's movement type but lands the wrong angle (profile instead of
three-quarter, eye-level instead of a power-beat's low angle) is a real, distinct
finding — name the emotion the shot needed, the camera language that would have
carried it, and what the generation produced instead.

For any emotionally-loaded or evasive beat, also check it against
`references/micro-expression-physics.md` §7: did the generation actually read as fast/
incidental/concealed, or did it revert to a static, symmetrical, face-to-face pose? If
it's a repeat failure on a beat that only ever got a mood label or a negative
constraint (never a physical reflex chain), report that plainly as the root cause —
this is a real, distinct finding from the 15 gates, rhythm-fidelity, and camera-emotion
checks, and it is the single most common way this project has seen a beat fail
across multiple regenerations.

For an action/fight/destruction sequence, also check the two `action-sequence-craft.md`
principles: did shot duration actually vary (or did the output land on a metronome of
equal-length shots), and — for any location reused across shots — did environmental
damage persist and scale up, or did it visibly reset between shots? These are the two
failure modes this project has actually run into that the 15 gates don't otherwise
catch.

For any long, multi-beat sequence, also check `references/action-sequence-craft.md`
§3: did several consecutive shots' actual content each land later than its own
scripted window, with the delay compounding rather than resetting shot to shot — even
if the cuts themselves (per the scene-change data) landed cleanly? Report this as its
own distinct finding (cumulative drift), not as N unrelated per-shot misses.

For any pair of shots where one is a stated cause for the next shot's effect (a
trigger touch before a reaction, an impact before a flinch), also check
`references/action-sequence-craft.md` §5: did the effect actually render *after* the
cause on screen, not just "both eventually appear somewhere"? A cause rendering after
its own effect is a distinct failure from drift and worth its own line in the report.

And before reporting a line delivered to camera instead of to another character as a
generation miss, check the shot text itself against `references/camera-emotion.md`
§12 first — if the prompt literally said "toward camera," that's a one-line prompt fix,
not a generation failure.

### Phase 4 — Before/after comparison report (once a generated clip exists)

When the user comes back with the actual clip a downstream prompt generated, and wants
it checked against the reference it was built from, build the comparison as an HTML
Artifact rather than a text summary — see `references/comparison-report-guide.md` for
the full structure (measured scene-change data for both clips, side-by-side players,
matched sampled frames, an overlaid chart, and a fidelity table scored against what the
prompt actually asked for, not against the Continuity & Style Brief in the abstract).
Score fidelity item-by-item against the specific prompt fields (identity, wardrobe,
camera move, camera angle, color grade, duration, etc.) and call out misses plainly,
including any gap in the prompt itself (like an unstated duration, an unspecified
aspect ratio, a vague angle label, or an environmental detail dropped when the prompt
was revised for something else) that plausibly caused one — this report is a QA
record, not a highlight reel.

This same artifact-first default applies even without a separate reference clip —
when the user hands over just the generated clip and the prompt that produced it and
asks to "analyze" or "วิเคราะห์" it, build the same kind of clickable HTML report
(playable clip, per-frame scene-change chart, a shot-by-shot table with thumbnails and
a pass/warn/fail verdict per shot, a summary stats table) rather than a chat-only text
answer. A plain conversational answer is fine only when the user explicitly signals
they want a quick verbal read (e.g. "บอกสั้น ๆ", "เล่าคร่าว ๆ พอ") — otherwise "analyze
this clip" defaults to the report artifact, matching what a "拉片" shot-breakdown tool
produces, since that's the format this project has settled on for anything the user
will want to reread, click through, or come back to.

## Boundaries

- Never edit files belonging to another skill.
- Never fabricate footage-analysis numbers — if ffprobe/ffmpeg isn't available or the
  file can't be read, say so and fall back to the inferred-brief path.
- The quality gates are advisory, not a hard gate that blocks generation — the user
  decides whether to act on a flagged issue.
- Never leave generation duration unstated when handing off to a downstream skill —
  ask, or propose the measured reference length, but always confirm one explicitly.
- Never leave aspect ratio unstated for a T2VA/Ref2VA-style handoff — measure it from
  the reference clip (width÷height) and state it explicitly, the same way duration
  gets stated; an unstated ratio is the same silent-guess failure mode as an unstated
  duration.
- In a comparison report, never grade fidelity against a vaguer brief than what the
  prompt actually said — a "partial" or "diverged" verdict must trace to a specific
  line in the prompt, not a general vibe.
- Never force per-shot rhythm tags onto a single continuous take that has no shot
  boundaries — give it one overall tag instead of inventing cuts that don't exist.
- Never describe a camera angle with a vague catch-all ("side-angle," "close shot")
  when a precise term exists — name eye-level / three-quarter / pure profile / low /
  high / dutch / overhead / worm's-eye / OTS explicitly, since the vague version has
  already caused a real generation to render the wrong angle.
- When revising a prompt for one specific change (a new camera treatment, a new
  identity reference, a style swap), re-carry every unrelated environmental detail
  from the original brief explicitly — don't let it silently drop just because the
  edit's focus was elsewhere.
- In an action/destruction sequence, never let every shot default to the same
  duration, and never let a broken location silently repair itself between shots —
  state both the pacing variance and the damage-persistence chain explicitly.
- Default a generated-clip analysis request to the clickable HTML report format (per
  Phase 4), not a chat-only text answer — a user re-asking for "the report" after
  getting a text answer is this rule being missed, not a new request.
- Never try to fix a repeat-failing emotional or evasive beat with another negative
  constraint alone — a beat that has already failed the same way once needs a physical
  reflex chain from `references/micro-expression-physics.md`, not a longer list of
  prohibitions layered onto the same unspecific positive description.
- Never write or revise a MiniMax H3 or Seedance prompt from memory of a previous
  prompt's format — always invoke and read the matching downstream skill's own
  reference files first (`minimax-h3-prompt-writing`'s `base-en.md`/`ref-en.md`, or the
  relevant `seedance-*` skill's reference material), and check whether any other loaded
  cinema-craft skill applies to this specific brief. A prompt written from memory in
  this project invented a non-existent `aspect_ratio:`/`duration:` field, used the wrong
  section name for Ref2VA, and wrote dialogue as plain quotes instead of H3's actual
  `<d>[Language] ...</d>` + speaker-ID syntax — none of that was catchable without
  actually reading the reference file.
