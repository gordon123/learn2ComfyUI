# Micro-Expression Physics

Adapted from this account's own `promptography` skill (its Micro-Expression Vocabulary
and natural-asymmetry rule) and `seedance-director`'s "described as physics, not
labels" rule, generalized here so any emotionally-loaded shot handed to a downstream
skill gets the same rigor — not just still-image prompts. This file exists because a
real prompt in this project kept failing the same beat (a fast, secretive handkerchief
lift that kept rendering as a static face-to-face pose) across four generations, and
adding more *forbidding* language ("no held eye contact") never fixed it — the fix was
adding *physical* specificity instead.

## 1. The core rule: physics, not labels

Never name an emotion abstractly and stop there — "looks angry," "seems nervous,"
"secretive expression." Name the physical, semi-involuntary mechanism that actually
produces the visible effect: which muscle, which asymmetry, which breath, which
micro-timing. A label gives the model nothing concrete to render and it falls back on
its most generic default (which is usually a static, symmetrical, face-forward pose —
exactly the failure mode this file exists to prevent).

| Emotion / state | Physical vocabulary (write this, not the label) |
|---|---|
| Anger / tension | Jaw clenches, nostrils flare, brows draw down and in, a held breath through the nose |
| Concealment / secrecy | Eyes stay fixed on a named decoy point, never on the target; one shoulder rotates a beat ahead of the hips; breath held then released short and quiet |
| Focus / fast calculation | One eyelid narrows fractionally; a half-second stillness in the eyes right before the hand moves; brows draw down, not up |
| Fear / adrenaline spike | Nostrils flare on a sharp exhale; pupils widen; an asymmetric full-body flinch (one shoulder pulls back faster than the other) |
| Relief / release | A shaky exhale through slightly parted lips; shoulders drop unevenly, not both at once; one corner of the mouth lifts before the full smile forms |
| Determination | Jaw sets a beat before the body moves; a single slow blink; the exhale is longer than the inhale |

## 2. Natural-asymmetry rule

Real faces and bodies are never symmetrical in action — state the asymmetry
explicitly: "one brow lifts fractionally more than the other," "the shoulder leads,
the hips lag half a beat," "her exhale is longer on one side of a crooked, uneven
smile." This is a large part of why a "held pose" failure mode happens at all: perfect
bilateral symmetry and simultaneous motion reads as staged/AI, and naming the
asymmetry directly is what breaks that read.

## 3. Sequence the reflex as a chain, not a static descriptor

An emotional or evasive beat is a chain of tiny physical events in a fixed order, not
one static adjective applied to a held frame. Write the chain in the prompt text
itself, tied to the actual beat, in this order:

**external trigger → fastest involuntary reflex (smallest, first) → secondary
muscular reaction → the visible action itself**

Example, for a fast/secretive contact beat:
> "the instant her sash brushes his fingers (trigger), her breath catches for a
> fraction of a second (reflex) before her shoulder is already rotating away
> (secondary reaction) — by the time her eyes could register the contact, her hand
> is already moving past his (visible action)"

Writing it as a chain, in order, gives the model a sequence to render instead of a
single ambiguous pose to default to.

## 4. Using this to fix a "held pose" failure specifically

When a beat is meant to read as fast, secretive, or incidental, and keeps rendering as
a static face-off pose across regenerations, the fix is **not** more forbidding
language ("no eye contact," "no posing," "not looking at each other"). Negative
constraints alone leave the model with no positive replacement to fall back on, and it
reverts to its most common default — which is exactly the static pose being forbidden.
The fix is adding more physical specificity:

1. Name a **specific external point** the eyes are fixed on (the crowd, the gap
   between stalls, the escape route) — never leave "not looking at X" without also
   stating what they're looking at instead.
2. Name the **asymmetric physical chain** per §2–3 — a real, sequenced, uneven
   reflex, not a symmetrical held pose.
3. Anchor the beat to an **external trigger** (a sound, an obstacle, a physical
   contact point) rather than to the other character's presence — this keeps the
   beat's causality pointed outward at the world, not inward at a face-off.

## 5. Using it in Phase 1 (reading reference footage)

When describing an emotional beat observed in reference footage for the Continuity &
Style Brief, describe it as a physical chain (§3), not a mood label — "her jaw sets a
beat before she turns" rather than "she looks determined." This keeps the brief itself
specific enough to write from later.

## 6. Using it in Phase 2 (writing a new shot)

Every emotionally-loaded shot handed to a downstream skill should carry, explicitly:
(a) the external trigger, (b) the asymmetric physical reflex chain per §2–3, (c) the
specific point the eyes/attention are actually fixed on. This is especially non-
optional for any beat with a negative-constraint history — i.e. a moment that has
already failed the same way more than once. Adding a fourth negative constraint to a
beat that has failed three times the same way is not a new fix; rewriting it with a
physical chain is.

## 7. Using it in Phase 3 (QA)

When a generated shot fails an emotional or evasive beat — reads as static/posed when
it should read as fast/incidental, or reads as symmetrical/staged when it should read
as a real involuntary reflex — check whether the prompt that produced it gave a
physical chain (§3) or only a mood label / a negative constraint. A repeat failure on
a beat that only ever got a label or a prohibition is not evidence the model can't do
it — it's evidence this file wasn't applied yet. Report it as its own line, distinct
from the 15 continuity gates, rhythm-fidelity, and camera-emotion-fidelity checks:
name the beat, the label/prohibition it was given, and the physical chain that should
replace it.
