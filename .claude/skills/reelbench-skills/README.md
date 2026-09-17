# reelbench-skills

*[ภาษาไทย](README-th.md)*

A cinematic-continuity coach and router for this project's AI-video prompt-writing
skills. It doesn't write MiniMax H3 or Seedance prompts itself — it briefs those
skills with real shot grammar learned from reference footage, then QAs their output
before you spend render credits on it.

## When to use it

- You have reference footage (a clip, a film scene, a mood reel) and want its shot
  language ("cut like this") applied to a new prompt.
- You're about to write a multi-shot prompt and want continuity enforced (recurring
  characters, consistent lighting, matched pacing) instead of each shot written in
  isolation.
- You're not sure whether to route a scene to the MiniMax H3 family or the Seedance
  family.
- You already have a shotlist/prompt and want it audited before generating.
- You have both the reference clip and what a downstream skill actually generated
  from it, and want a fidelity check.
- You have a generated clip and just want it analyzed shot-by-shot — this always
  produces a clickable HTML report (see `references/comparison-report-guide.md`),
  not a chat-only text answer, unless you explicitly ask for a quick verbal read.

Skip it for a single one-off prompt with no continuity or reference-footage need —
go straight to the relevant downstream skill.

## Workflow (see `SKILL.md` for the full detail)

1. **Learn** — if reference footage is supplied, measure it with ffprobe/ffmpeg
   (`references/footage-analysis-guide.md`) and turn it into a Continuity & Style
   Brief, a narrative-rhythm map, a camera-emotion read, and — for action/fight
   scenes — a pacing/damage-continuity read.
2. **Route** — settle duration and aspect ratio explicitly, then hand off to the
   right downstream skill (`references/routing-matrix.md`) carrying the brief, the
   rhythm map, and the camera-emotion pairing as concrete per-shot instructions. Before
   presenting the draft to the user — every time, not just on request — run
   `scripts/validate_shotlist.py` for the 6 deterministic gates (pacing duplicates,
   total duration vs. platform, dialogue-vs-shot-duration fit, language purity,
   max-subjects-in-frame, beat coverage — see `references/shot-manifest-convention.md`)
   and fix anything it flags. This is a pre-send gate, not post-generation QA — a real
   prompt in this project carried two structural bugs (a shot-duration tie, a dialogue
   line scripted too long) across six full revision rounds before the script actually
   ran.
3. **QA** — once a generated clip exists, walk the 15 qualitative gates
   (`references/quality-gates.md`), plus rhythm-fidelity, camera-emotion-
   fidelity, and (for action scenes) pacing/damage checks.
4. **Report** — once a real generated clip exists, build a before/after (or
   single-clip) HTML report as an Artifact: playable clip(s), a per-frame
   scene-change chart, a shot-by-shot table, and a prompt-fidelity verdict.

## Reference files

| File | What it's for |
|---|---|
| `footage-analysis-guide.md` | The actual ffprobe/ffmpeg commands for shot-boundary detection, per-shot stats, frame sampling, and the structured per-shot data-table format used in reports |
| `quality-gates.md` | The 15-point continuity checklist a downstream skill's output gets walked against |
| `routing-matrix.md` | Which downstream skill (MiniMax H3 family vs. Seedance family) fits which task |
| `narrative-rhythm.md` | The 8-tag rhythm system (hook/setup/escalation/beat/pivot/payoff/breath/closure) for what job each shot does in a sequence |
| `camera-emotion.md` | Precise angle/movement/lens vocabulary tied to the emotion a shot needs to carry — never a vague label like "side-angle" |
| `action-sequence-craft.md` | Pacing-irregularity and cumulative-environmental-damage-continuity rules specific to fight/destruction scenes |
| `micro-expression-physics.md` | Describing an emotional or evasive beat as a physical, asymmetric reflex chain instead of a mood label or a bare negative constraint — the fix for a beat that keeps rendering as a static held pose |
| `comparison-report-guide.md` | Full structure for the before/after or single-clip HTML report (player, scene-change chart, shot table, fidelity verdicts) |
| `shot-manifest-convention.md` | The `SCRIPTED_DURATION:` marker and beats-manifest conventions the deterministic validator needs, and what each of its 6 gates checks and why |
| `h3-official-spec-corrections.md` | Three structural-syntax bugs confirmed directly against MiniMax H3's own official spec — no separate "Negative constraints" field, `retention_analysis` as a comma-list not a dash-range, Ref2VA's global style sentence before `[Shot 1]` |
| `path-annotated-reference-images.md` | The confirmed fix (after three generations) for a reference photo with a camera-path/arrow/waypoint diagram drawn on the subject — never name the diagram in `subject_definitions`/`retention_analysis` at all, and give a bodiless POV its own separate "no creature body visible" constraint |
| `action-beat-defaults.md` | Three related failures from one generation, and their regeneration results: a late "turn around, keep the camera on your own face" beat that rendered as a third-person shot — **confirmed fixed** by restating the shot-type lock at that beat; "a bicycle" that rendered as a helmeted moped — **confirmed fixed** by stating what it explicitly lacks; a style-label mandate ("nostalgic camcorder look") with zero visible effect — **partially fixed**, tying individual texture cues to a specific beat/object worked, a general style sentence alone still didn't |
| `multi-pose-fashion-sequence.md` | Three failure modes from a 4-part, 20-pose fashion film: an uncapped hold beat that deleted a later pose entirely rather than just delaying it; an attribute absent from the reference image (footwear) invented differently in three separate shots; a prose-only "seamless transition" between two separately-generated clips that worked on one boundary and not the other, confirming true continuity needs a real last-frame `<Picture N>` anchor |
| `character-reveal-montage.md` | A character intro/reveal shot pattern (imported, not project-derived): withholding the face as an open loop until one payoff shot, writing one continuous motion sliced by body-region cuts to prevent body-state resets, match cuts through shape/motion vector, and a deliberately uneven locked-vs-dynamic camera rhythm |

`scripts/validate_shotlist.py` is the deterministic validator itself — run it
directly (`python3 scripts/validate_shotlist.py --platform h3|seedance PROMPT.md`)
before the qualitative gate walk.

## Examples

`examples/` keeps real prompt/report pairs from actual generations, kept as
reference snapshots rather than documentation to follow blindly — see
`examples/README.md` for what's there and why.

## Maintenance note

This file and `README-th.md` are kept in sync — any update to one gets carried
into the other in the same change, not left to catch up later.

## Credits

The per-shot data-table format in `footage-analysis-guide.md` §6 (code-measured
fields kept separate from interpreted ones, evidence-required category labels, the
15%/85% frame-pair convention) and the narrative-rhythm tag set in
`narrative-rhythm.md` were adapted from the field conventions and rhythm vocabulary
documented in [eternityspring/reelbench-skills](https://github.com/eternityspring/reelbench-skills)
(specifically its `skills/video-shots` tool) — credit to that project for the
original methodology this reference builds on.

The 6 deterministic gates in `shot-manifest-convention.md` and
`scripts/validate_shotlist.py` (pacing duplicates, total-duration-vs-platform,
dialogue-fits-shot, language purity, max-subjects-in-frame, and the "cuts claim
beats" convention for beat coverage) are adapted from the code-enforced validation
gates in [eternityspring/shuohao-skills](https://github.com/eternityspring/shuohao-skills)
(specifically `novel-storyboard`'s 17-gate `validate` command) — generalized here
from that project's structured `storyboard.json` to the freeform MiniMax H3 /
Seedance prose prompts this project's downstream skills actually write.
