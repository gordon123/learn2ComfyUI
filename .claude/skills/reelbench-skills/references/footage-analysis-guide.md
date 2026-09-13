# Footage Analysis Guide

Requires `ffmpeg`/`ffprobe` on PATH. No API keys, no npm packages. If neither binary is
found, tell the user and fall back to the inferred (non-measured) style brief instead
of guessing numbers.

## 1. Detect shot boundaries (scene cuts)

```bash
ffprobe -show_frames -of compact=p=0 -f lavfi \
  "movie='INPUT.mp4',select=gt(scene\,0.35)" 2>/dev/null | grep pkt_pts_time
```

`0.35` is the scene-change sensitivity threshold — lower it (e.g. `0.25`) for footage
with slow, subtle cuts or dissolves; raise it (e.g. `0.45`) if it over-detects on fast
motion/noise. The output timestamps are shot boundaries; consecutive boundaries minus
each other give per-shot duration.

## 2. Per-shot duration stats

Once you have the boundary list, compute for the whole clip:
- total shot count
- average shot length (ASL)
- shortest / longest shot
- whether ASL trends shorter or longer across the runtime (pacing acceleration)

## 3. Shot size / framing (approximate)

ffmpeg can't classify "close-up vs wide" directly. Pull one representative frame per
shot and describe it visually (framing, subject size in frame, camera height) rather
than inventing a numeric classifier:

```bash
ffmpeg -ss <midpoint_timestamp> -i INPUT.mp4 -frames:v 1 shot_<n>.jpg
```

Extract a handful of representative frames (don't dump one per shot on a long clip —
sample every few shots or use the shot list to pick the ones worth reviewing) and
describe each one directly: shot size, camera angle/height, and any visible camera
movement (compare with the adjacent frame if movement isn't obvious from one frame).

## 4. Color / lighting read

From the same sampled frames, note per shot: dominant color palette, contrast/mood
(high-key vs low-key), and light source direction/quality if visible. Look for a
throughline across the sequence rather than scoring each frame independently.

## 5. Assemble the Continuity & Style Brief

Combine 2–4 into a short brief:
- Average shot length + pacing trend
- Shot-size distribution (e.g. "mostly medium/close, one wide establishing per scene")
- Camera-movement vocabulary actually observed
- Color/lighting throughline
- Anything notably absent (e.g. no handheld shake, no whip pans) — worth stating since
  it constrains what the downstream skill should NOT introduce

Keep this brief factual and short — it's meant to be handed to another skill as
grounding context, not read as a film-school essay.

## 6. Per-shot data table (for a report, one row per shot)

When the analysis is going into an HTML report (per SKILL.md's artifact-first default),
give every shot — including a single continuous take, as one row — a structured field
table rather than a caption paragraph, adapted from the field conventions this project
found in a public shot-breakdown tool (`video-shots`). Split fields into what's
code-measured versus what's an interpreted judgment call, and never blur the two:

**Code-measured fields** (from ffprobe/ffmpeg directly, no interpretation):
- `shot id` — sequential, `S01`, `S02`, ...
- `start` / `end` / `seconds` — from the scene-cut boundary list (§1), two decimals
- `motion` — the median of the per-frame `lavfi.scene_score` values *within* that shot's
  own frame range (not the cut-detection score at its boundary) — this is a real motion-
  intensity number, distinct from the cut score, and worth reporting even for a shot
  with zero internal cuts, since it separates "static" from "handheld-but-uncut"

**Interpreted fields** (a judgment call — state the evidence, don't just assert):
- `size` — shot scale (extreme close-up → extreme wide), from the sampled frame
- `category` — what kind of shot this is (dialogue / reaction / insert / establishing /
  atmosphere-mood / empty-frame, etc.) — **always name the evidence**: a "dialogue"
  category needs audible lines, a "text card" category needs visible on-screen text: an
  unsupported category label is a guess, not a finding
- `camera` — movement type in plain terms (fixed / pan / dolly-push / dolly-pull / track
  / handheld-follow / float-drift) — cross-reference `camera-emotion.md` for the
  emotional read, this field is just the mechanical description
- `frame` — one concrete visual description of the shot (framing, subject, background,
  light) — a real description, not a placeholder ("a shot of a person" fails this)

**Content fields**:
- `subjects` — who's in frame (name if known/established, otherwise a plain description)
- `on-screen text` — exact text if any (distinguish a diegetic sign/graphic from a
  non-diegetic watermark or stock-preview artifact)
- `audio` — what's audible, or state plainly that audio wasn't evaluated in this pass

**Metadata fields**:
- `rhythm` / `rhythm note` — the tag from `narrative-rhythm.md` plus a one-line reason
  (a bare tag with no reason is the same failure mode as an unsupported category)
- `note` — anything else worth flagging (e.g. zero cuts detected, a possible false-
  positive cut, a shot whose category was hard to call)

**Frame pair convention**: for each shot's thumbnails, pull two frames — one at 15%
into the shot's duration, one at 85% — labeled `S01a.jpg` / `S01b.jpg` and so on, rather
than an arbitrary start/mid pair. This captures the shot's actual visual arc (its early
framing vs. where it settles) more reliably than a first-frame/midpoint pair, especially
for a shot with camera movement across its own duration.

This table format applies whether the clip has one shot or fifty — a single continuous
take still gets one full row (with `motion` as the median across the whole take, and
`note` stating plainly that zero cuts were detected) rather than being described in
prose alone.
