# story-wizard

*[ภาษาไทย](README-th.md)*

A story-reasoning layer that runs **before** any technical footage analysis or prompt writing,
when the user hands over a reference video (or character reference images) and wants a new or
adapted piece built from it. It fixes a real gap: neither `reelbench-skills` (measures shot
grammar) nor `personal-video-library` (adds camera techniques on top of the reference) ever
asks what the new piece is actually *about* — what the character does, why, how it opens, how
it ends. A prompt can nail camera language and still have no reason to exist if nobody decided
the story.

## When to use it

- A reference video/character images are supplied alongside a request to adapt, remix, or build
  something new from them — not just reproduce it shot-for-shot.
- The request names a character/subject but leaves action, hook, or ending unstated.
- Before `personal-video-library` runs `reelbench-skills`' technical analysis — this is Phase 0,
  upstream of both.

Not for a single locked-off product shot, a pure technique demo, or a request where action/hook/
ending are already fully specified (confirm the read in one line instead and move on).

## Workflow (see `SKILL.md` for the full detail)

1. **Read the reference** — plain descriptive read of who/what's in the clip, what they're
   doing, the setting/mood — not a technical shot-grammar measurement.
2. **Socratic elicitation** — ask the user directly: what should the character do this time,
   how is it presented, what's the story arc, what's the hook, how does it end.
3. **Build the Story Brief** — assemble the answers into a short structured brief and get it
   confirmed before moving on.
4. **Hand off** — carry the brief into `personal-video-library`/`reelbench-skills` as the
   narrative context their own technical/rhythm work builds on top of.

## Relationship to the other skills

| Skill | Answers |
|---|---|
| `story-wizard` (this one) | What is the new piece about — action, hook, arc, ending? |
| `reelbench-skills` | What does the reference footage measure out to, shot by shot? |
| `melies-cinematic-library` | What's the correct name for a camera/lighting/effect technique? |
| `personal-video-library` | What's in my own reference collection, and how do I add to it instead of copying? |
| `mv-storytelling-framework` | Same elicitation mechanism, but for song/lyrics-driven music videos — use that instead when the source is a song, not a clip. |

## Maintenance note

This file and `README-th.md` are kept in sync — an update to one gets carried into the other in
the same change.
