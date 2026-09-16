---
name: melies-cinematic-library
description: A curated library of 424 cinematic techniques (camera angles, camera movement, framing/shot size, composition, lighting, color/film look, lenses/optics, atmosphere/weather, time and motion, editing/transitions, in-camera/optical effects, genre looks, viral looks), each with a definition and a ready-to-adapt prompt template, mirrored from melies.co/cinematic-techniques since that site can't be fetched live from this environment. Use this BEFORE or WHILE writing any video/image-generation prompt (MiniMax H3, Seedance, Google Flow, or any other tool) whenever the brief needs a specific camera angle, movement, lighting setup, color grade, lens choice, genre look, or transition and you want a real, named technique instead of a vague adjective — not just when the user says "melies" or "cinematic techniques" by name.
---

# Melies Cinematic Technique Library

A reference library, not a prompt writer. Its only job is to help pick the *right, specific*
cinematic technique for a brief and hand back its definition plus a ready-made prompt phrase —
actually writing or revising the final generation prompt stays the job of the downstream skill
(`reelbench-skills`, `minimax-h3-prompt-writing`, `seedance-*`, `google-flow-shotlist-director`,
or whatever the user is using).

## Why this exists

The source, [melies.co/cinematic-techniques](https://melies.co/cinematic-techniques), is blocked
by this environment's network egress proxy and cannot be fetched live. The user exported the full
page content and this skill mirrors it locally under `library/` so its 424 techniques stay usable
for prompt-writing without needing live web access.

## When to invoke

- Before writing or revising any shot/scene description that needs a specific camera angle,
  camera movement, framing/shot size, lighting setup, color grade, lens choice, atmospheric
  element, editing/transition style, genre look, or "viral" aesthetic — reach for a named
  technique from here instead of an invented or vague description ("some kind of low angle",
  "moody lighting").
- When the user asks "what techniques would fit this scene," "หา technique ที่เหมาะกับซีนนี้",
  or names a mood/genre/reference and wants matching camera/lighting/color language.
- When auditing an existing prompt or shotlist and a shot's camera-emotion pairing
  (`reelbench-skills`' `references/camera-emotion.md`) needs a precise, named angle/movement
  instead of a vague catch-all — cross-check the exact term against `camera-angles.md` /
  `camera-movement.md` here.
- Do NOT invoke for questions unrelated to shot/visual-technique selection (e.g. dialogue writing,
  story structure, sound design) — route those to the relevant skill instead
  (`screenwriter`, `mv-storytelling-framework`, `ad-clip-director`).

## How to use it

1. **Read `library/INDEX.md` first** — it lists all 13 categories, their technique counts, and
   every technique name in each category, in one file. This is the fast way to scan for
   candidates without opening all 13 full files.
2. **Identify what the brief actually needs**: is this a camera question (angle/movement/lens/
   framing), a light-and-color question (lighting/color-and-film-look), a texture/effect question
   (in-camera-and-optical-effects/atmosphere-and-weather), a structural question (composition/
   editing-and-transitions/time-and-motion), or an overall look question (genre-looks/
   viral-looks)? Most briefs touch 2-3 categories, not one.
3. **Open the matching category file(s) under `library/`** and grep/read the specific technique
   entries that fit. Each entry has this shape:
   ```
   ### <Technique Name>

   **Definition:** <what it is and the visual/technical mechanism that produces it>

   **Prompt:** <a ready-to-adapt prompt fragment, usually with a [Subject] placeholder>
   ```
4. **Adapt, don't paste verbatim.** Swap `[Subject]` for the actual subject/character/object in
   the brief, and merge the technique's prompt language into the shot's own sentence structure
   and the downstream skill's actual field format (e.g. MiniMax H3's `detailed_description`,
   Seedance's shot blocks) — never hand back the library's raw template as if it were a
   finished prompt for a specific platform.
5. **Name the technique explicitly** when handing suggestions back to the user or to a downstream
   skill ("Dutch Angle, per melies — camera rolled 20-30°...") so the choice is traceable and
   the user can look up the full definition themselves.
6. **When several techniques could fit, offer 2-3 named options** with a one-line reason each,
   rather than silently picking one — the user or the downstream skill's own craft rules (e.g.
   `camera-emotion.md`'s "match the angle to the emotion" rule) should make the final call.
7. **If nothing in the library fits the brief**, say so plainly rather than forcing a technique
   that doesn't match — this library is a curated 424, not exhaustive, and a genuinely novel
   camera idea is fine to describe in plain prose instead.

## Categories (see `library/INDEX.md` for the full technique list in each)

| File | Category | Count |
|---|---|---|
| `camera-angles.md` | Eye level, high/low angle, bird's/worm's-eye, Dutch, POV, etc. | 19 |
| `camera-movement.md` | Dolly, pan, tilt, crane, orbit, handheld, zoom variants, drone, etc. | 86 |
| `framing-and-shot-size.md` | ECU through ELS, two-shot, OTS, insert, cutaway, establishing, etc. | 25 |
| `composition.md` | Rule of thirds, leading lines, frame-in-frame, negative space, symmetry, etc. | 32 |
| `lighting.md` | Three-point, Rembrandt, chiaroscuro, practical, golden/blue hour, gobo, etc. | 41 |
| `color-and-film-look.md` | Teal-and-orange, bleach bypass, sepia, cross-process, day-for-night, etc. | 19 |
| `lenses-and-optics.md` | Focal lengths 14mm-200mm, anamorphic, fisheye, tilt-shift, macro, etc. | 17 |
| `atmosphere-and-weather.md` | Rain, fog, haze, smoke, dust, steam, underwater, etc. | 13 |
| `time-and-motion.md` | Slow/fast motion, speed ramp, freeze frame, bullet time, long take, etc. | 21 |
| `editing-and-transitions.md` | Match cut, jump cut, dissolve, wipe, cross-cutting, montage, etc. | 23 |
| `in-camera-and-optical-effects.md` | Lens flare, film grain, bokeh, rack focus, double exposure, datamosh, etc. | 57 |
| `genre-looks.md` | Film noir, giallo, found footage, cinéma vérité, wuxia, arthouse, etc. | 27 |
| `viral-looks.md` | Named short-form aesthetic presets (Agamemnon, Ink Riot, 3D Render, etc.) | 44 |

All filenames above are prefixed `cinematic-techniques-` in `library/` (e.g.
`library/cinematic-techniques-camera-angles.md`).

## Boundaries

- Never fetch melies.co directly — the network egress proxy blocks it; use the local mirror.
- Never edit the technique entries in `library/*.md` — they're a verbatim export of the source
  site. If the user corrects or extends an entry, ask them whether they want a change to the
  mirrored file (and note it came from them, not the original site) or a note added elsewhere.
- Never invent a technique name that doesn't appear in the library and present it as if it were
  a melies.co term — describe an original idea in plain prose instead and say it's not from the
  library.
- This skill never writes the final generation prompt itself — hand the chosen technique(s) and
  their definitions to the user or to the downstream prompt-writing skill for the actual prompt.
