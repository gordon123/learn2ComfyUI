# personal-video-library

*[ภาษาไทย](README-th.md)*

A thin coordination layer that keeps prompt-writing grounded in the user's own growing
collection of reference clips at `video-library/` (project root), and actively breaks the
"literal copy" default: handed a reference clip and asked for a creative prompt, the unforced
default is to reproduce its camera angles and effects exactly, even when told to be creative.
This skill makes the creative-addition step structural instead of optional.

## When to use it

- The user hands over a reference clip (or points to a `video-library/<slug>/` entry) and wants
  a new generation prompt built from it.
- The user asks to check `video-library/` for something relevant before starting a new
  prompt-writing task ("มีคลิปแบบนี้เก็บไว้ไหม", "เคยเก็บ reference อะไรแบบนี้บ้าง").
- The user wants to add a new clip to the library.

Not for a bare technique lookup with no reference clip involved (`melies-cinematic-library`
alone covers that), and not for QA of an already-generated clip against its own prompt
(`reelbench-skills` Phase 3/4 covers that).

## Workflow (see `SKILL.md` for the full detail)

1. **Check the library** — read `video-library/INDEX.md` for anything already relevant.
2. **Analyze the new clip** — hand it to `reelbench-skills` Phase 1 for a measured footage
   analysis, not an eyeballed one.
3. **Force the creative addition** — pull 2-3 named techniques from `melies-cinematic-library`
   that fit the mood and are confirmed *absent* from the reference clip, present them to the
   user explicitly, then route the actual prompt-writing with both the measured brief and the
   chosen additions as explicit instructions.
4. **Log the entry** — write/update `video-library/<slug>/notes.md` and its row in
   `video-library/INDEX.md`, whether or not the raw clip file itself can be stored in-repo.

## Relationship to the other two skills

| Skill | Answers |
|---|---|
| `reelbench-skills` | "What does this reference footage's shot grammar actually look like, measured?" |
| `melies-cinematic-library` | "What's the correct name for this camera/lighting/effect technique?" |
| `personal-video-library` (this one) | "What have I personally collected, and how do I make sure a new prompt adds to a reference instead of just copying it?" |

## Maintenance note

This file and `README-th.md` are kept in sync — an update to one gets carried into the other in
the same change.
