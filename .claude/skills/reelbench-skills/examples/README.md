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
- `part2-prompt-v2.md` — Part 2 regenerated with all three `action-beat-defaults.md` fixes
  applied.
- `report-v2.html` — QA of that regeneration: the backward-walk reframe and the bicycle/moped
  substitution are both confirmed fixed; the camcorder-texture fix is confirmed only partially
  (the two cues tied to a specific beat/object rendered, the two stated only as a general style
  sentence still didn't). Static version — the full interactive report is linked inside it.
- `thumbs/` — sample frames used by `report.html` and `report-v2.html`.

## royal-fashion-film

- `part1-prompt.md` through `part4-prompt.md` — a 4×15s (60s total) MiniMax H3 Ref2VA sequence
  adapted from two separate Seedance 2.5 fashion-film prompts (10 poses each), split into 5
  poses per part per this project's cumulative-drift findings. Part 1-2 are a reflective-studio
  segment; Part 3-4 continue the same character into a palace segment. Each prompt file's own
  "QA findings" section documents what that specific clip's generation actually did.
- `report.html` — QA across all four clips: Part 1 and Part 2 are mostly strong with a couple of
  minor drifts (a shortened dress plus invented footwear in Part 1, a minor wardrobe/timing drift
  and an under-delivered final pull-out in Part 2); Part 3 is the headline failure — one pose
  (a seated marble-staircase reveal) is compressed out of the clip entirely after an earlier pose
  overran its own scripted window; Part 4 is the strongest part, landing every pose on schedule
  with the film's real payoff shot. See `references/multi-pose-fashion-sequence.md` for the full
  three-finding writeup (the cumulative pose-deletion drift, an undefined reference attribute
  invented three different ways, and a prose-only cross-generation "seamless transition" that
  worked on one boundary and not the other). Static version — the full interactive report with
  all four playable clips and the combined 60-second scene-change chart is linked inside it.
- `thumbs/` — sample frames used by `report.html`.

## yasha-kurenai-duel

- `part1-prompt.md` through `part4-prompt.md` — a 4-part original-story MiniMax H3 Ref2VA
  sequence (Yasha, a winged demon-horned girl with violet-white magic, vs Kurenai, a fox-masked
  girl with a red spectral-fox aura): an establishing beat, a first clash, an 11-shot climax duel,
  and a title/credits outro. Each file is the final accepted version after iterative rejection and
  rewrite rounds — see each part's own findings below for what earlier versions got wrong.
- `report.html` — QA summary across all four parts: Part 2's clash needed two rewrites to fix an
  empty shot (v1) and a static, consequence-free hand-clasp (v2), fixed in v3 with the new
  `references/combat-environment-reactivity.md` techniques (low/canted push, Light Flash, dust
  catching the glow, bounce light). Part 3's climax needed a full rewrite (v1→v2) for cinematic
  intensity, then a targeted fix (v2→v3) for two shots that rendered as near-frozen with eyes
  reading toward the camera instead of each other — root-caused to "held/locked/sustained"
  language being read literally as static, fixed by describing continuous incremental motion and
  explicit eye-contact instructions, verified with the new `scripts/timeline_view.py` tool. Part 4
  corrected placeholder names and added power-display pose language. Part 1's thumbnails are
  captioned as illustrative frames from an earlier generation round rather than a verified final
  pass, since no dense frame analysis was run against it in this project. Static version — the
  full interactive reports (one per accepted revision) are linked inside it.
- `thumbs/` — sample frames used by `report.html`.
