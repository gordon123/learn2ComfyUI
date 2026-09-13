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
