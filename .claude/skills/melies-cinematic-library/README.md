# melies-cinematic-library

*[ภาษาไทย](README-th.md)*

A local mirror of [melies.co/cinematic-techniques](https://melies.co/cinematic-techniques) —
424 named cinematic techniques across 13 categories, each with a definition and a ready-to-adapt
prompt fragment. It exists because the source site is blocked by this environment's network
egress proxy and can't be fetched live.

This is a reference library, not a prompt writer. It hands back a named technique and its
definition/prompt fragment; actually writing the final generation prompt stays the job of the
downstream skill (`reelbench-skills`, `minimax-h3-prompt-writing`, `seedance-*`,
`google-flow-shotlist-director`, or whatever else is in use).

## When to use it

- Before writing or revising any shot/scene description that needs a specific camera angle,
  movement, framing, lighting, color grade, lens choice, atmospheric element, transition, genre
  look, or "viral" aesthetic — reach for a named technique here instead of a vague adjective
  ("some kind of low angle", "moody lighting").
- When asked "what techniques would fit this scene" or "หา technique ที่เหมาะกับซีนนี้".
- When auditing an existing prompt/shotlist and a shot's camera-emotion pairing
  (`reelbench-skills`' `camera-emotion.md`) needs a precise term instead of a catch-all.

## How to use it

1. Read `library/INDEX.md` first — all 13 categories, their counts, and every technique name in
   one place.
2. Identify which category (or 2-3) the brief actually needs.
3. Open the matching `library/cinematic-techniques-<category>.md` file(s) and read the specific
   entries — each has a `### Name`, a `**Definition:**`, and a `**Prompt:**` fragment.
4. Adapt the prompt fragment into the actual shot's sentence structure and the downstream
   platform's field format — never hand back the raw template as a finished prompt.
5. Name the technique explicitly when presenting it, so the choice is traceable.

## Categories (see `library/INDEX.md` for the full technique list in each)

| File | Category | Count |
|---|---|---|
| `cinematic-techniques-camera-angles.md` | Camera angles | 19 |
| `cinematic-techniques-camera-movement.md` | Camera movement | 86 |
| `cinematic-techniques-framing-and-shot-size.md` | Framing / shot size | 25 |
| `cinematic-techniques-composition.md` | Composition | 32 |
| `cinematic-techniques-lighting.md` | Lighting | 41 |
| `cinematic-techniques-color-and-film-look.md` | Color / film look | 19 |
| `cinematic-techniques-lenses-and-optics.md` | Lenses / optics | 17 |
| `cinematic-techniques-atmosphere-and-weather.md` | Atmosphere / weather | 13 |
| `cinematic-techniques-time-and-motion.md` | Time and motion | 21 |
| `cinematic-techniques-editing-and-transitions.md` | Editing / transitions | 23 |
| `cinematic-techniques-in-camera-and-optical-effects.md` | In-camera / optical effects | 57 |
| `cinematic-techniques-genre-looks.md` | Genre looks | 27 |
| `cinematic-techniques-viral-looks.md` | Viral looks | 44 |

## Maintenance note

This file and `README-th.md` are kept in sync — an update to one gets carried into the other in
the same change. Never edit the technique entries in `library/*.md` themselves — they're a
verbatim export of the source site.
