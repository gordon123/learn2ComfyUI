# Rapid-Transformation Scene Introduction

A shot-craft pattern for introducing a rapid succession of distinct looks/worlds/beats — each
one landing as its own small, complete "intro" in under 2 seconds — imported from a K-fashion
transformation MV prompt the user brought in (not derived from this project's own generation
history, like `character-reveal-montage.md`). Distinct from that file: this one is about
introducing many *different* scenes/looks in rapid succession, not one character's identity
through a single withheld-reveal arc.

## What it's for

A short, high-energy sequence (a fashion transformation reel, a multi-world showcase, a
"same character, new world every beat" concept piece) where the point is rapid variety, not a
single escalating story. Each beat needs to read as a complete, self-contained "intro" to its
own world almost instantly — no build-up time, no gradual establishing shot.

## The four mechanics that make it work

### 1. Simultaneous triple-change, not staggered transition
Every beat changes **outfit + location + composition together, in the same cut** — not a
gradual dissolve from one to the next. This is what makes each beat read as a genuinely new
"world" rather than a variation on the last one. Distinct from
`multi-pose-fashion-sequence.md`'s pattern (same location, changing pose/hold) — this pattern
changes the entire environment every beat, not just the figure within it.

### 2. Never repeat the typography style
Each beat's on-screen text uses a **visibly different graphic treatment** from every other beat
in the sequence — oversized sans-serif, thin elegant serif, handwritten sticker type, poster
typography, metallic 3D lettering, magazine-label type, diagonal or vertical layouts. State this
as an explicit rule ("never repeat the same font/treatment") rather than leaving type style to
default, the same way `melies-cinematic-library`'s single generic **Typography** entry needs a
concrete, specific treatment named per use, not left abstract. For the actual on-screen-text
mechanics (material/lighting on the type, beat-synced reveals, a protected zone that never
covers a face), read `minimax-h3-prompt-writing`'s own "Cinematic title cards" /
"Lyric-synced kinetic typography" / "Text depth-layering with a protected zone" sections — this
project doesn't need to re-derive that craft, it already exists in the downstream skill.

### 3. Dual-script (or multi-script) title per beat, tied to that beat's mood
Where the brief calls for more than one language, pair a short phrase in each language per
beat, both reflecting that specific location/mood rather than a single repeated tagline —
e.g. an English fragment plus a matching-register phrase in the second language, not a literal
translation of each other.

### 4. Finale collage callback
Close the sequence by visually recalling every prior beat at once — as flying photo cards,
magazine pages, or floating poster fragments — around the subject in a final held composition,
rather than simply cutting to a last, disconnected shot. This is a distinct technique from a
narrative rhythm map's "closure" tag (`narrative-rhythm.md`): it's a *visual* summary device,
literally bringing back imagery from earlier beats, not just a structural pacing role. Land the
final text reveal beat-by-beat over this collage (word by word or phrase by phrase, each timed
to a specific visual/audio hit) rather than all at once.

## Structural shape (adapt beat count/duration to the actual brief)

| Phase | Content |
|---|---|
| Rapid-fire beats | Each beat: one look, one location, one composition, one uniquely-styled title card — as many beats as the runtime and desired pace support, each landing complete in ~1-2s |
| Finale | Previous beats' imagery recalled as a visual collage around the subject in one held composition; final message text reveals in stages, each stage synced to a concrete visual/audio beat; ends on a brief freeze/hold |

## Boundaries

- This is explicitly a **non-narrative** structure — the beats don't need causal continuity with
  each other (see `minimax-h3-prompt-writing`'s "Macro-structure template and non-narrative
  framing" guidance: state up front that the piece isn't plot-driven, so the downstream skill
  doesn't invent connective tissue between beats that don't need any).
- Identity lock still applies at full strength across every beat even though everything else
  changes — face, proportions, and any stated permanent features stay fixed; only
  outfit/location/composition are meant to vary. State this explicitly and once, not per beat.
- Do not reach for this pattern for a single escalating scene with one emotional throughline —
  that's what `narrative-rhythm.md` and `action-sequence-craft.md` already cover. This file is
  specifically for many self-contained "worlds" in rapid succession.
- The never-repeat-typography-style rule needs to be stated as an explicit constraint — without
  it, the default is to reuse one text treatment across every beat, flattening the variety the
  whole pattern exists to deliver.
