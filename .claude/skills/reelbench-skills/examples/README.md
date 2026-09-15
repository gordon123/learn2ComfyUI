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
