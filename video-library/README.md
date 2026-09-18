# Personal Video Library

A growing folder of *your own* reference clips (screen recordings, downloaded examples,
past generations you liked) — separate from `.claude/skills/melies-cinematic-library`
(a curated public catalog of named techniques) and separate from
`.claude/skills/reelbench-skills/examples` (post-generation QA reports of this
project's own past prompts).

This folder answers a different question than either of those: **"what have I
personally collected that's worth remembering the next time I write a prompt?"**
`.claude/skills/reelbench-skills/examples` answers the neighboring question — "what
actually happened the last time I generated from a finished prompt?" — so check there
too when looking for past prompt/report pairs rather than raw reference clips.

## Why this exists

Handing Claude a reference clip and asking it to write a prompt "based on this" tends
to produce a literal copy of what's on screen — same angle, same cut, same effect,
nothing added. That's the expected default: a plain "study this clip" instruction
reads as an instruction to reproduce it, not to reinterpret it. This library plus
`.claude/skills/personal-video-library` exists to break that default deliberately —
every entry gets logged with what was actually used *and* what could have been added
from the wider technique catalog, so each pass through this folder makes the next
prompt more creative, not just accurate.

## Structure

```
video-library/
├── README.md          # this file
├── INDEX.md            # one-line-per-entry index, newest first
└── <slug>/
    ├── clip.mp4         # (or a link/path note if the file lives elsewhere, e.g. Drive)
    └── notes.md          # what this clip is, what techniques it shows, ideas for reuse
```

Keep `<slug>` short and descriptive (`bangkok-neon-walk`, `product-unbox-macro`,
`corgi-pov-chase`) — it's what gets referenced from `INDEX.md` and from prompt-writing
sessions later.

## `notes.md` schema (per entry)

```markdown
# <slug>

- **Source:** <where this came from — downloaded ref, a competitor ad, a generation you liked>
- **Added:** <date>
- **Techniques observed:** <camera angles/movement, lighting, color, effects actually
  visible in the clip — name them precisely, per melies.co naming (see the
  melies-cinematic-library skill), not vague adjectives>
- **Mood/genre:** <one or two words>
- **Reuse ideas:** <techniques from the wider melies library that would fit this clip's
  mood but ISN'T already in it — this is the field that makes the library additive
  instead of a copy source>
```

## How this gets used

See `.claude/skills/personal-video-library/SKILL.md` for the full workflow. Short
version: before writing a prompt from a reference clip, Claude checks this folder for
anything relevant, runs `reelbench-skills`' footage analysis on the new clip, then
pulls 2-3 techniques from `melies-cinematic-library` that fit the mood but aren't
already visible in the reference — and logs the new entry back here so the library
keeps growing.
