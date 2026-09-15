# Corrections verified against MiniMax H3's own official spec

This project got access to MiniMax's own Chinese-language developer guide ("MiniMax H3 -
视频扩写 Prompt 写作全能指南") for the full-reference/Ref2VA mode. It confirms most of
what this stack already assumed, but also surfaced concrete bugs that had been shipping
in prompts (v5 through v8) undetected — none of them guessable from a prior prompt's
surface shape, exactly the failure mode `SKILL.md`'s "always read the reference file
first" rule exists to prevent. Recorded here so they don't recur.

## 1. There is no "Negative constraints" field — it is not a seventh section

The official structure (§1 整体结构) is exactly six paragraphs, in this fixed order, and
nothing else:

`subject_definitions → summary → retention_analysis → detailed_description → overall_soundscape → non_diegetic_music`

There is no seventh field anywhere in the spec. `minimax-h3-prompt-writing`'s own
SKILL.md says the same thing from the other direction: constraint language goes
**"at the end of `detailed_description` or as a clearly separated closing note"** — inside
that field, not after it — and separately states **"Field names, section order, and
blank-line spacing must match the guide precisely."**

v8 (and v5–v7 before it) wrote `Negative constraints: ...` as its own standalone
paragraph between `detailed_description` and `overall_soundscape` — an invented 7th
section in a slot the model was never trained to expect. This is a plausible root cause
for why negative constraints (identity/costume locks, causal-order locks, no-symmetrical-
motion rules) haven't reliably held across this project's own generation history: a
model reading a fixed six-section format may not weight an unrecognized 7th block the
same way it weights the field it actually expects constraint-adjacent language to live
in.

**Fix**: append every constraint sentence to the end of the `detailed_description` text
itself — same field, same paragraph, no new top-level label — rather than opening a new
`Negative constraints:` line.

## 2. `retention_analysis` shot references are a comma-separated list, not a dash-range

Official example:
> `<Subject 1> (appears in [Shot 1], [Shot 2], [Shot 3]): fully_preserved - ...`

v8 wrote:
> `<Subject 1> (appears in [Shot 1]-[Shot 10]): fully_preserved - ...`

The dash-range syntax appears nowhere in the spec. List every shot the subject actually
appears in, comma-separated, even when it's every shot in the sequence.

Also confirmed from the spec while here — the fixed vocabulary for this field:
- Subject/Picture/Video entries: `fully_preserved`, `partially_preserved`,
  `attribute_transfer`, `weak_reference`
- Audio entries: `fully_copy`, `partially_copy`, `reference`, `weak_reference`
- `retention_analysis` never carries a speaker ID `(Sx)` — that only ever appears in
  `detailed_description` (and, when binding a stable speaker to an `<Audio N>` reference,
  in `subject_definitions`).

## 3. Ref2VA's global style sentence goes *before* `[Shot 1]`, not merged into it

§5.2 draws this distinction explicitly (T2VA vs. full-reference/Ref2VA):

| | T2VA | Ref2VA (full-reference) |
|---|---|---|
| Style opening | written *after* the `[Shot 1]` tag | 1–2 English sentences establishing global visual style, written *before* `[Shot 1]` appears at all |

Ref2VA worked example: `"The target video uses a realistic multi-camera sitcom style
with warm indoor lighting.\n[Shot 1] A medium shot establishes..."` — the style sentence
is its own lead-in, then `[Shot 1]` starts the actual shot content.

v8 wrote `[Shot 1] Live-action, cinematic, warm early-morning market light, dust and
steam drifting between stalls. A wide tracking shot follows...` — fusing the style
words into the `[Shot 1]` tag itself, which is the T2VA convention, not Ref2VA's.

**Fix**: for any Ref2VA/full-reference prompt, write the 1–2 style sentences as their
own lead-in immediately before `detailed_description`'s first `[Shot 1]` marker.

## 4. Confirmed correct, worth citing rather than re-deriving

- `detailed_description` (not `integrated_multimodal_description`) is the correct field
  name for Ref2VA; the latter is T2VA/base-mode only.
- `<d>[Language] verbatim text</d>` with a stable `(S1)`/`(S2)` speaker ID established in
  prose *outside* the tag is the correct dialogue syntax.
- Dialogue/lyrics must never be duplicated into `overall_soundscape` or
  `non_diegetic_music` — those two fields cover ambience/impact sound and
  audience-only score respectively; full spoken/sung content lives only in
  `detailed_description`'s `<d>` tags.
- `aspect_ratio` and `duration` are not prompt-body fields at all in the six-section
  schema — they're generation-time UI/API settings, confirmed absent from every example
  in the official guide.
- `summary:` opens with a bracketed task-type tag, e.g. `[reference generation]` or
  `[reference generation + audio reference]` (see the guide's task-type table for the
  full set: keyframe completion / reference generation / video editing / video
  continuation / audio reuse / audio reference, combinable with ` + `).
- Shot timing syntax `[Shot N] At MM:SS.mmm, ...` (Shot 1 always implicit at 0.00s, no
  stated timestamp) is correct as this project has been writing it.
- Complete declarative/interrogative/exclamatory dialogue lines end with `.`, `?`, or
  `!` immediately before `</d>` — v5–v8's dialogue lines have already been doing this
  correctly.

## 5. Using this in Phase 2 / Phase 3

- Before writing or revising any Ref2VA prompt, check a drafted `Negative constraints:`
  line against §1 above — it must be folded into `detailed_description`, never its own
  field.
- In Phase 3 QA, treat a standalone `Negative constraints:` paragraph, a dash-range in
  `retention_analysis`, or a style sentence fused into `[Shot 1]` as a structural-syntax
  fail — same severity tier as the field-name and dialogue-tag bugs this project already
  tracks, not a style nitpick.
