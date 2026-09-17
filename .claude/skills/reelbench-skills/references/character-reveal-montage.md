# Character Reveal Montage

A distinct shot-craft pattern for introducing a character through body-detail fragments
while withholding the face until one deliberate final beat — imported from a Seedance-style
`@tag`-reference prompt the user brought in (not derived from this project's own generation
history, unlike most other reference files here). Use this when the brief is a character
intro/reveal, not a narrative scene — it's a different genre from the fight/dialogue prompts
`action-sequence-craft.md` and `camera-emotion.md` cover.

## What it's for

A short (10-20s), high-energy montage that builds anticipation for a character's face by
showing everything *except* the face first — hands, joints, fabric, silhouette fragments in
tight, fast-cut detail — then delivers one clean face reveal as the payoff. Works for a
character intro reel, a product-style "hero reveal," or (see Boundaries) as an opening beat
inside a larger narrative sequence when a character's full identity is meant to land as its
own small climax rather than being shown immediately.

## The five mechanics that make it work

### 1. Withhold the face = a real open loop
Every shot before the reveal explicitly excludes the face, eyes, and facial profile —
*including reflections*. This is the same hook/open-loop/payoff structure
`mv-storytelling-framework` uses for a symbolic question, just applied to the face itself as
the withheld answer. The reveal shot is the *only* face shot in the whole sequence — payoff
strength comes from scarcity, not from being especially elaborate.

### 2. One continuous motion, sliced by body region — not separate actions per shot
This is the mechanic that actually prevents the "body resets to neutral between cuts" failure
this project has hit repeatedly in fight sequences (see `action-sequence-craft.md`). Instead of
writing each shot as its own discrete action, write **one unbroken physical motion** in full
(e.g. head turns → arm coils → arm sweeps open → torso twists → one step → pivot → face turns
into camera), then cut to a different body region's close-up *at each phase of that same
motion*. Every shot's action must be a spec-accurate continuation of what the previous shot's
final frame implied, never a fresh start. State this explicitly if the downstream skill's own
continuity rules don't already cover it: "carry body state across cuts without resetting to
neutral."

### 3. Match cuts through shape or motion vector, not just hard cuts
Connect selected cuts by matching the physical shape or motion direction across the cut (e.g.
a bent elbow cutting to a knee bent at a similar angle) rather than relying on hard cuts alone.
This is `melies-cinematic-library`'s **Match Cut** technique, applied systematically across an
entire sequence rather than as a single isolated transition.

### 4. Deliberately uneven camera rhythm
Most shots get one fast, dynamic camera move (whip, crash push, sharp track) — but 1-2 shots
in the sequence are explicitly **locked/static**, with the character's own motion supplying all
the energy instead of the camera. This is the same pacing-irregularity principle
`action-sequence-craft.md` requires for combat (never let every shot default to the same
treatment), applied to camera *stillness* as the deliberate outlier rather than shot duration.

### 5. Generic, anatomy-safe instruction language
Written to be reusable across characters with different builds: name body regions rather than
species-specific anatomy, and state explicitly "adapt body-region cues to actual anatomy,
replacing absent features with existing equivalents; invent no anatomy or accessories." When
adapting this pattern to a specific character, replace every generic region name with that
character's actual signature details (a costume seam, an accessory, a distinctive silhouette
feature) rather than leaving the generic version in — the specificity is where the reveal earns
its payoff.

## Structural shape (adapt duration/shot count, keep the arc)

| Phase | Content |
|---|---|
| Setup burst | A small triggering motion (a head turn, a shift of weight) with the body bracing — first 15-20% of the runtime |
| Main burst | The largest, most energetic single motion (a sweep, a strike wind-up and release, a spin) — the longest phase, 40-50% of the runtime |
| Transition burst | A short connecting motion (one step, a pivot, a half-turn) that visibly sets up the reveal — 20-25% of the runtime |
| Reveal | One shot only: a hard cut or sharp motion completes the turn toward camera, face fully readable, ends on living motion (never a held pose) |

Distribute inserts unevenly within each burst — mix brief 0.3-0.5s "visual punches" with 1-2
longer "moving-detail reads" that a fast cut would otherwise waste (see `action-sequence-craft.md`'s
existing rule against uniform shot length).

## Boundaries

- Do not use this for a straightforward character-already-established scene — it's specifically
  for the moment a character's identity is *earning* its reveal, not routine coverage.
- The face-withholding rule is absolute through every non-reveal shot, including reflections,
  shadows implying a facial profile, or a mask/covering that itself reads as "the face" for that
  character (in which case, redefine what "the face" means for that specific design before
  writing the sequence — e.g. a mask's eye-opening might BE the reveal moment, not the skin
  under it).
- This pattern can open a larger narrative sequence (a character's first appearance mid-scene)
  as well as stand alone as its own short — when nesting it inside a longer piece, the "reveal"
  shot becomes the hinge into the scene's actual action, not necessarily the sequence's final
  shot.
- Still apply this project's own H3/Seedance craft rules on top of this pattern where relevant
  (physical realism, sound-follows-cause, negative constraints for drift-risk effects) — this
  file only covers the reveal-specific shot architecture, not the full prompt-writing discipline.
