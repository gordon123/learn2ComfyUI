---
name: story-wizard
description: Reasoning guide that runs BEFORE any technical shot/prompt work when the user hands over a reference video (or character reference images) and wants a new or adapted AI-video prompt built from it. Reads what the reference clip actually shows (who's in it, what they're doing, the implied mood/setting), then runs a Socratic elicitation with the user — what should the character do this time, how should it be presented/introduced, what's the story arc, what's the hook, how does it end — before any footage-analysis or prompt-writing step starts. Trigger whenever a reference video is supplied alongside a request to "adapt", "create new based on this", "ปรับ", "สร้างใหม่โดยอิงจาก", or "ทำแบบนี้แต่..." — not for a bare technique lookup or a prompt request with no story/character stakes (a single locked-off product shot, a technique demo). Generalizes mv-storytelling-framework's character-elicitation and hook/open-loop/payoff mechanism from song-driven music videos to reference-video-driven character content.
---

# Story Wizard

A **story reasoning layer**, not a prompt writer and not a shot-technical analyzer. Its only
job is the step that was missing before this skill existed: when a reference clip and a request
to build something new from it show up together, decide *what the new content is actually
about* — with the user, not by guessing — before `reelbench-skills` measures the footage or
`melies-cinematic-library` picks a camera technique or any downstream skill writes a single
field of the actual prompt.

**Why this exists:** handed a reference clip and told to "make something like this," the
unforced path jumps straight to copying (or, once `personal-video-library` is in the loop,
straight to swapping in different camera techniques) — but neither step ever asks what the
*character does*, why, or how the new piece opens and closes. A prompt can nail camera language
and still be a non-sequitur with no reason to watch it, because nobody decided the story.

## When to invoke

- A reference video (or a character reference image set) is supplied alongside a request to
  adapt, remix, or build something new from it — not just reproduce it shot-for-shot.
- The user's request names a character/subject but leaves the action, narrative purpose, hook,
  or ending unstated — the most common shape of an underspecified request.
- Before handing off into `personal-video-library` (which then runs `reelbench-skills`'
  technical footage analysis and `melies-cinematic-library`'s technique injection) — this skill
  is Phase 0, upstream of both.

Do NOT invoke when there's no story/character stakes at all: a single locked-off product shot,
a pure technique/style demo, a one-off camera-angle question with no narrative content, or when
the user has already fully specified action + hook + ending themselves (confirm your read back
to them in one line and move on rather than re-running the elicitation).

## Workflow

### Step 1 — Read what the reference actually shows

Before asking the user anything, look at the reference clip (and any character reference
images) and state plainly, in 2-3 sentences: who/what is in it, what they're doing, the
setting/mood, and anything visually distinctive (costume, props, a recurring gesture). This is
a plain descriptive read, not a technical shot-grammar analysis — that measurement work belongs
to `reelbench-skills` Phase 1 and happens later, once the story itself is decided. If character
reference images are supplied separately from the video (e.g. a multi-angle character sheet),
note that they fix *identity/costume*, not action — the video is what supplies the movement/mood
read.

State this read back to the user before proceeding, since a wrong read here (misreading the
character's implied role or mood) poisons everything asked in Step 2, the same failure mode
`mv-storytelling-framework` guards against for song meaning.

### Step 2 — Socratic elicitation (run this even if the user seems to have already decided)

Ask the user directly — don't guess and proceed, and don't ask everything in one giant wall if
the conversation is casual; a few short direct questions beat a form:

1. **Action / goal** — "ในคลิปนี้ อยากให้ character ทำอะไร?" What is the character doing in the
   *new* piece — not what they did in the reference. If the user already named an action in
   their request, confirm it in one line instead of re-asking.
2. **Presentation** — "นำเสนอยังไง?" POV or observer? Solo performance or interacting with
   something/someone? Does it open on the character already mid-action (matches the reference's
   own energy) or build up to them?
3. **Story arc** — "มี story telling ยังไง?" A one-to-two-sentence beginning → middle → end, even
   for a single 10-15s clip. A clip with no arc at all is a valid answer for a pure mood/vibe
   piece — confirm that's the intent rather than assuming it.
4. **Hook** — "Hook อะไร?" What makes the first 1-3 seconds worth stopping for — a visual
   pattern-interrupt, an action already in motion, a striking detail. If the user doesn't have
   one, propose 1-2 concrete options grounded in what Step 1 found in the reference (a gesture,
   a prop, the setting) rather than a generic suggestion.
5. **Ending** — "ตอนจบ จบแบบไหน?" Does it resolve, loop back to the hook, land on a punchline/
   reveal, or cut on an unresolved beat on purpose? Match this to what the platform/format
   rewards (a loop-friendly ending for a short vertical clip is often stronger than a hard stop).

Keep the questions short and let the user answer in phrases, same as
`mv-storytelling-framework`'s character elicitation — your job is turning short answers into a
structured brief, not extracting an essay.

If the user has clearly already answered some of these in their original request, don't
re-ask them — state your read of what's already decided and only ask what's genuinely open.

### Step 3 — Build the Story Brief

Assemble what Steps 1-2 produced into a short brief:

```
reference_read:  <what the clip/images actually show — Step 1>
character:       <who, locked identity/costume from reference images if supplied>
action:          <what they do in the NEW piece>
presentation:    <POV/observer, solo/interacting, opens mid-action or builds up>
story_arc:       <beginning -> middle -> end, or explicitly "mood piece, no arc">
hook:            <the concrete opening 1-3s idea>
ending:          <how it resolves>
```

Present this brief to the user for a quick confirm/edit before moving on — same hard-gate
principle as `mv-storytelling-framework`'s Character Elicitation Protocol: a brief built on an
unconfirmed read is the exact failure this skill exists to prevent.

### Step 4 — Hand off

Once confirmed, hand the Story Brief to `personal-video-library` (or straight to
`reelbench-skills` if no personal video-library entry is involved) as the narrative context for
its own Phase 1 footage analysis and Phase 2 routing — the Story Brief's `action`/`hook`/
`story_arc`/`ending` fields become the per-shot narrative content, while `reelbench-skills`
still separately supplies the *rhythm tags* (hook/setup/escalation/beat/pivot/payoff/breath/
closure) and camera-emotion pairing on top of it. The two are complementary, not duplicates:
this skill decides *what happens and why*; `reelbench-skills` decides *what job each shot does
and how the camera should carry it*.

## Relationship to other skills

| Skill | Answers |
|---|---|
| `story-wizard` (this one) | "What is the new piece actually about — what does the character do, why, and how does it open/close?" |
| `reelbench-skills` | "What does the reference footage's shot grammar measure out to, and what job does each shot do in the sequence?" |
| `melies-cinematic-library` | "What's the correct name for this camera/lighting/effect technique?" |
| `personal-video-library` | "What have I personally collected, and how do I make sure a new prompt adds to a reference instead of copying it?" |
| `mv-storytelling-framework` | The same elicitation mechanism as this skill, but locked to song/lyrics input for full music-video briefs — use that one instead when the source material is a song, not a reference clip. |

## Boundaries

- Never skip Step 2 because the request "seems simple" — an unstated action/hook/ending is the
  most common way a technically correct prompt still has no reason to exist.
- Never invent an ending or arc the user didn't confirm and present it as decided — propose,
  then confirm, exactly as Step 3 requires.
- Never do the technical footage measurement (shot-boundary detection, ffprobe stats) here —
  that's `reelbench-skills` Phase 1's job, and it runs after this skill's brief is confirmed.
- Never pick camera techniques or write prompt fields here — that's `melies-cinematic-library`
  and the downstream prompt-writing skill's job respectively.
- If the user has already fully specified action, hook, and ending in their own message, don't
  force the full Socratic pass — restate your read in one line and confirm, then move on.
