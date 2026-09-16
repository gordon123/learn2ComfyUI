# Examples

Real prompt/report pairs kept as reference, not documentation to follow blindly —
each one is a snapshot of what actually worked (or didn't) at the time it was
generated. Cross-check against the current reference files before assuming an old
example's syntax is still correct.

## v10-market-chase

- `prompt.md` — the 9-shot MiniMax H3 Ref2VA prompt (Thai historical market-chase
  scene) after fixing 3 structural-syntax bugs against MiniMax's own official spec
  (see `references/h3-official-spec-corrections.md`) and cutting a shot that kept
  misrendering as combat across 5 prior generations (see
  `references/action-sequence-craft.md` §6).
- `report.html` — the QA report built from the actual v10 generation: the first
  generation in this project's history with zero causal-order inversions or
  shot-order swaps. Still flags a held-pose miss and cumulative drift. Static
  version (no embedded video, ~6MB clip not stored in-repo) — the full interactive
  report with the playable clip is linked inside it.
- `thumbs/` — one frame per shot, used by `report.html`.

## v3-corgi-pov-insect

- `prompt.md` — the winning H3 Ref2VA prompt after two failed generations from the same
  path-annotated reference photo (a camera-path diagram drawn directly on a sleeping woman and her
  pet). See `references/path-annotated-reference-images.md` for the full three-generation arc and
  the confirmed fix this prompt applies.
- `report.html` — frame-by-frame QA of the actual v3 generation: zero path-line leakage, zero
  visible creature body, zero hard cuts across the entire clip. Static version — the full
  interactive report with the playable clip is linked inside it.
- `thumbs/` — sample frames used by `report.html`.

## bangkok-soi-walk

- `part1-prompt.md`, `part2-prompt.md` — the 2×15s MiniMax H3 Ref2VA prompts for a nostalgic
  camcorder-style selfie-vlog walk through a Bangkok soi, adapted from a Korean-neighborhood
  reference prompt.
- `report.html` — frame-by-frame QA of the actual generations: Part 1 held its selfie framing and
  beats cleanly; Part 2's final beat (turn around, walk backward, camera stays on her own face)
  rendered instead as a fast, unscripted reframe to a third-person shot. See
  `references/action-beat-defaults.md` for the full three-finding writeup (the reframe, a
  style-label mandate with zero visible effect, and a "bicycle" that rendered as a moped) this
  example is drawn from. Static version — the full interactive report with both playable clips
  and the scene-change chart is linked inside it.
- `thumbs/` — sample frames used by `report.html`.
