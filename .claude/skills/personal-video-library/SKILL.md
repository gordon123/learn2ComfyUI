---
name: personal-video-library
description: Keeps prompt-writing grounded in the user's own growing collection of reference clips at video-library/, and actively breaks the "literal copy" default — when the user hands over a reference clip and asks for a creative video/image-generation prompt, this skill makes sure the output doesn't just reproduce the clip's own camera angles and effects, but deliberately adds 2-3 techniques the reference didn't use. Use whenever the user supplies or references a video clip and wants a prompt "based on it", "in this style", "แบบนี้", "จากคลิปตัวอย่าง", or asks to be creative with camera work/effects on top of a reference. Also use when the user wants to browse, catalog, or add to their personal video-library/ folder, or asks "มีคลิปแบบนี้เก็บไว้ไหม". Not for the curated public melies technique catalog by itself (use melies-cinematic-library) and not for post-generation QA of this project's own past prompts (use reelbench-skills/examples).
---

# Personal Video Library

A thin coordination layer over three things that already exist in this project but
don't talk to each other unless something forces it: the user's own reference-clip
folder (`video-library/`), the footage-analysis workflow in `reelbench-skills`, and
the named-technique catalog in `melies-cinematic-library`. Its only job is to make
sure a reference clip turns into a *creative* prompt, not a transcription, and that
every pass through a new clip leaves the library richer than it found it.

## The problem this fixes

Told "study this clip and write a prompt," the unforced default is literal
reproduction — same angle, same movement, same cut, nothing added, even when the
user separately said "be creative." That instruction is easy to lose in a longer
brief. This skill exists to make creativity a structural step, not a hope.

## When to invoke

- User hands over a reference clip (or a path to one, or a `video-library/<slug>/`
  entry) and wants a new prompt built from it.
- User asks to check `video-library/` for something relevant before starting a new
  prompt-writing task ("มีคลิปแบบนี้เก็บไว้ไหม", "เคยเก็บ reference อะไรแบบนี้บ้าง").
- User wants to add a new clip to the library.
- Do NOT invoke just to look up a named technique with no reference clip involved —
  that's `melies-cinematic-library` alone. Do NOT invoke for QA of an already-generated
  clip against its own prompt — that's `reelbench-skills` Phase 3/4.

## Workflow

### 0. Settle the story first, if there's story/character stakes

Before touching camera technique or the library, check whether the request has narrative
stakes — a character doing something, a hook, an arc, an ending — rather than being a pure
technique/style task. If so, hand off to `story-wizard` first (or confirm its Story Brief has
already been produced this conversation) and carry the resulting brief (action/presentation/
story_arc/hook/ending) into every step below. Skip this only for a request with no
story/character content at all (a locked-off product shot, a pure technique demo).

### 1. Check the library first

Read `video-library/INDEX.md`. If anything already there is relevant to the current
brief (similar mood, similar subject, similar platform), open its `notes.md` and
surface it to the user before starting fresh — a past entry's "Reuse ideas" field may
already have the answer.

### 2. Analyze the new reference clip

If the user supplied a new clip, hand it to `reelbench-skills` Phase 1 (footage
analysis via ffprobe/ffmpeg — see that skill's `references/footage-analysis-guide.md`)
to get the measured Continuity & Style Brief and camera-emotion read. Do not skip this
and eyeball the clip instead — the measured brief is what "techniques observed" in the
library entry needs to be accurate.

### 3. Force the creative addition — never skip this step

This is the step that fixes the literal-copy problem, and it is not optional just
because the analysis in step 2 was thorough:

1. Take the mood/genre read from step 2 to `melies-cinematic-library`.
2. Pick 2-3 named techniques (per `library/INDEX.md`) that fit the mood **and are
   confirmed absent from the reference clip** — a technique already visible in the
   clip doesn't count toward this step, the point is genuine addition.
3. Present these to the user explicitly, named, with a one-line reason each, before
   or alongside the prompt draft — e.g. "the reference is a static eye-level walk;
   adding a slow dolly-in on the payoff beat (per melies) would give it a finish the
   original doesn't have." Let the user accept, swap, or reject before locking the
   prompt.
4. Route the actual prompt-writing to the correct downstream skill (via
   `reelbench-skills`' routing matrix, or directly if it's a single one-off prompt)
   carrying the measured brief, the chosen additions, AND the Story Brief from step 0
   (if one was produced) as explicit per-shot instructions — a technique picked in
   step 3 or a story beat settled in step 0 that never makes it into the actual
   prompt text didn't happen.

### 4. Log the entry back to the library

Whether the clip was newly supplied or pulled from an existing entry that got updated,
write (or update) `video-library/<slug>/notes.md` per the schema in
`video-library/README.md`, and add/update its row in `video-library/INDEX.md`. Use a
short descriptive slug the user would recognize later. If the raw clip file itself
can't be stored in-repo (too large, or lives in Drive/Dropbox), note its location in
`notes.md` instead of skipping the entry — the notes and reuse ideas are the valuable
part, not necessarily the binary.

## Boundaries

- Never write the Story Brief yourself in step 0 instead of running `story-wizard`'s Socratic
  elicitation — deciding action/hook/ending by guessing is the exact failure that skill exists
  to prevent.
- Never present a technique pulled from `melies-cinematic-library` as if it were
  observed in the reference clip — keep "techniques observed" (from the clip) and
  "reuse ideas" (added on top) visibly separate, both in the library entry and when
  talking to the user.
- Never skip step 3 because the user's request only said "study this clip" without
  repeating "be creative" — the whole point of this skill existing is that the
  creative step doesn't depend on the user re-stating it every time.
- Never edit `melies-cinematic-library/library/*.md` or `reelbench-skills` reference
  files from here — this skill only reads them and writes to `video-library/`.
- If `video-library/` has nothing relevant yet (it's new), say so plainly and proceed
  with steps 2-4 anyway — an empty library is not a reason to skip logging the first
  entries that build it up.
