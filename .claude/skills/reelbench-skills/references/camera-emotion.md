# Camera–Emotion Vocabulary

**The camera is the emotional double of the focal character.** Movement, angle, lens,
and duration get chosen by what the character (or the moment) is feeling — never by
"what looks cinematic." This is adapted from the `CAMERA_EMOTION.md` and
`CAMERA_MAP.md` reference files built for `shotlist-builder` / `storyboard-board`,
generalized here so it applies to both analyzing reference footage (Phase 1) and
steering new prompts (Phase 2) across every downstream skill — Seedance and
MiniMax H3 alike.

This is a companion to `narrative-rhythm.md`, not a replacement: the rhythm tag says
*what job* a shot does in the sequence (hook, beat, payoff...); this file says *what
camera language embodies that job's emotion*. Use both together when handing off.

## 1. Movement → emotion

| Emotion | Camera behavior | Written as |
|---|---|---|
| Anger / tension / on edge | Handheld, **jittery, unstable** — broken breath rhythm, visible small vertical/horizontal twitches, irregular timing | "the camera holds unsteady, tense handheld — a visible, irregular breathing drift, small vertical and horizontal twitches, no stabilizer" |
| Calm / control / confidence | Handheld, **smooth breathing** — steady, regular micro-amplitude, no twitch | "the camera holds a calm, controlled handheld breathing — only the faintest, regular micro-drift, no stabilizer but no unsteadiness either" |
| Sadness / vulnerability | Handheld, **slow and low** — reduced breath frequency, slight downward drift | "the camera holds low and slow, a faint downward drift settling into the frame, breathing at a reduced, heavy rhythm" |
| Shock / revelation | **Static, then a very slow push-in or pull-out** — sharp freeze at the start, movement only after a beat | "the camera holds perfectly still for the first half-second, then begins an almost imperceptibly slow push-in, moving only a few centimeters over the whole shot" |
| Action / physical intensity | Clear motion with motion blur strictly inside the actual movement, no drag outside it | "fluid, fast camera motion with motion blur confined to the moving subject, no smeared drag beyond the actual motion" |
| Finality / verdict / a beat time stops on | A brief top-down or dead-static freeze | "a strict overhead static hold, a half-second freeze — everyone's position locked, time stopped" |

### Emotional arcs within one continuous shot

If the emotion **changes** mid-shot (e.g. rage cooling into control), the camera
changes with it — describe it in phases tied to the action, not as a single static
descriptor for the whole shot:

```
Opens on [character] mid-anger: the camera holds visibly unsteady, tense handheld —
clear breathing drift, small twitches. As [character]'s anger cools through
[the described action], the unsteadiness fades — the drift narrows, the twitching
settles. By the shot's end, [character] has steadied: the camera now holds a calm,
controlled breathing, only the faintest regular micro-drift remaining.
```

Tie each camera phase to a concrete beat in the action so the downstream skill knows
*when* in the shot the transition happens — never leave the transition point implicit.

## 2. Angle → emotion (the part easy to get wrong)

Naming a camera angle vaguely ("side-angle," "close shot") is exactly the kind of gap
that causes a generation to diverge from a reference's actual emotional register — a
real test in this project's own history got "side-angle" rendered as a full 90° profile
when the reference was actually a 45° three-quarter angle, and the two read completely
differently. Always name the precise angle:

| Angle | What it reads as | Notes |
|---|---|---|
| **Eye-level** | Neutral, connective — the baseline everything else deviates from for a reason | Default only when nothing more specific is called for |
| **Three-quarter (~45°)** | Intimate, legible — the far eye/cheek stays faintly visible, so expression reads even in profile-leaning shots | This is usually what a "side view that still shows feeling" actually means — don't call it "side-angle" |
| **Pure profile (~90°)** | Graphic, detached, silhouette-like — the far eye is fully hidden, expression is reduced to outline | Use deliberately for distance/alienation, not by accident when a 3/4 angle was meant |
| **Low angle** (camera below, looking up) | Power, dominance, threat, triumph — makes the subject loom | |
| **High angle** (camera above, looking down) | Vulnerability, smallness, helplessness — makes the subject diminished | Also used for a gentle, watchful framing over an intimate task (writing, holding something) |
| **Dutch/canted** | Instability, wrongness — most effective as a deviation from level shots around it | Never hold as a constant state |
| **Overhead/bird's-eye** | Detachment, a "higher" vantage, or lays out geography clearly | Also the finality/verdict freeze from §1 |
| **Worm's-eye** | Exaggerates scale/looming presence beyond a standard low angle | |
| **Over-the-shoulder (OTS)** | Intimacy and connection in an exchange, while keeping spatial relationship clear | |
| **Direct-to-lens / POV** | Confrontation, direct address, or subjective immersion | |

When a scene has a power imbalance, pairing a low angle on one party with a high angle
on the other (alternating across a shot/reverse-shot) makes the imbalance legible
without a line of dialogue.

## 3. Position and distance → emotion

Beyond the angle itself, *where the camera physically sits relative to the subject and
the space* carries meaning — this is the floor-plan thinking from `CAMERA_MAP.md`,
generalized:

- **Establishing position**: usually placed to see the full space — an edge of the
  room, wide, taking in geography before narrowing in.
- **Tracking position**: moves along the subject's own path through the space —
  alongside, not just watching from a fixed point; keeps momentum attached to them.
- **Hero/final position**: usually a clean, closer, static position near wherever the
  subject ends up — the position that gets to just *hold*, once the scene has earned it.
- **Near vs far**: closer readings intensify whatever the angle already says (a close
  low angle is more dominant than a distant one); distance softens it.

Shot size itself (extreme close-up → close-up → medium close-up → medium → medium-long
→ wide → extreme wide) scales intimacy the same way: tighter reads as more emotionally
urgent, wider reads as more contextual/isolated. Choose the ladder position for the
beat's actual weight, not by defaulting to "medium shot" throughout.

## 4. Lens & depth of field → emotion

| Use | Lens | Aperture | Read |
|---|---|---|---|
| Extreme emotional close-up (forehead-to-chin fills frame) | 85mm–100mm | f/1.4 | Maximum intimacy, isolates the face from everything else |
| Dialogue / two-shot | 50mm | f/2.0–f/2.8 | Natural, connective, the neutral default |
| Wide / establishing | 35mm | f/4–f/5.6 | Contextual, grounded, less emotionally loaded |
| Insert / object detail | 50mm–85mm, focus-locked on the object | f/1.4 | Draws total attention to one thing, blurs everything else into irrelevance |
| Macro (pores, droplets, fabric) | 45mm macro | f/2.8 | Heightens texture into near-abstraction |

State explicitly when a shot needs the focal plane **locked** on a subject or object
(no rack focus, no autofocus hunt) — drifting focus reads as an error, not a choice,
unless a deliberate rack-focus reveal was actually asked for.

Avoid optical distortion by default on wide/fast lenses unless the scene specifically
wants that look (a fisheye POV, a deliberately warped comedic angle) — state "no
barrel or pincushion distortion, no fisheye, straight lines stay straight" when using
a wide or fast lens for anything that should read as normal.

## 5. Duration → emotional function

Cross-reference this with the rhythm tag from `narrative-rhythm.md` — each tag has a
duration range that tends to serve it:

| Shot function | Duration |
|---|---|
| Hard-cut flash / establishing glimpse | 0.3–0.5s |
| One line's worth of dialogue or a single beat | 3–7s |
| Wordless reaction with an emotional arc | 5–10s |
| Insert / wide / freeze | 0.3–2s |
| Full emotional close-up arc (several numbered micro-beats) | 8–15s |

A `hook` or `pivot` tends toward the shorter end; a `beat` or `breath` can afford to
sit longer; a `payoff` needs enough length for the release to actually register, not
just flash past.

## 6. Using this in Phase 1 (analyzing reference footage)

When describing camera vocabulary in the Continuity & Style Brief, don't stop at a
generic movement label — name, per shot (or per the whole take for a single-shot
clip):

1. The **precise angle** (eye-level / 3-quarter / pure profile / low / high / dutch /
   overhead / worm's-eye / OTS), not a vague catch-all.
2. The **movement quality** in emotional terms (steady handheld breathing vs jittery vs
   locked-static), not just "handheld" or "static."
3. The **lens/DOF read** if inferable (shallow and isolating vs deep and contextual).
4. Whether that camera language **actually matches** the apparent emotional content of
   the shot — note it explicitly if it doesn't (a flat, static camera on a supposedly
   tense moment is itself a finding worth reporting, not just a style observation).

## 7. Using this in Phase 2 (steering a new shot)

When hand off to a downstream skill, state the camera instruction as an
emotion-to-camera pairing, not a bare technical label:

```
This shot needs to read as [rhythm tag]'s beat: [emotion]. Camera: [precise angle],
[movement quality written in full], [lens/DOF if relevant]. Not "a side-angle shot" —
state whether it's three-quarter or pure profile, and why that angle serves this
moment's emotion specifically.
```

If the emotion changes within one continuous shot, write the phased transition per
§1's "Emotional arcs" pattern, tied to a concrete point in the action — never leave a
mid-shot emotional shift to an unstated camera default.

## 8. Using this in Phase 3 (QA)

Check the generated shot's actual camera choice against the emotion it was supposed to
carry — not just against the Continuity & Style Brief's raw vocabulary. A camera that
matches the reference's literal movement type but reads the wrong angle (profile
instead of three-quarter, eye-level instead of the low angle a power-beat needed) is a
real finding, distinct from the 15 continuity gates and the rhythm-fidelity check —
report it as its own line: what emotion the shot needed, what camera language actually
carries that emotion, and what the generation produced instead.

## 9. Hard cuts need frame-size/position contrast — the word "HARD CUT" alone is not enough

A real test in this project's own history scripted three separate hard-cut beats
(a glancing contact, an insert on a handkerchief lift, a break-apart) using the literal
label "HARD CUT" between each — and all three rendered as one blended 3.9s continuous
take instead, with no cut at all detectable in a frame-by-frame scene-change scan. The
label describes an editing *intent*, not a rendering *constraint*, and the model has no
reason to actually change anything about the shot unless the prompt forces a concrete
visual discontinuity.

The fix that worked on the next attempt: state an explicit, drastic contrast in frame
size and camera position between the two shots on either side of the cut — never two
adjacent shots at a similar framing scale. "CUT to a drastically tighter, lower framing"
or "HARD CUT to an extreme insert — no faces in frame at all, filled edge-to-edge by
hand and fabric" gives the model something concrete to jump to; "HARD CUT" by itself
does not.

- Every cut in a multi-shot sequence should pair with a stated frame-size and/or
  camera-position swing relative to the shot immediately before it (wide → extreme
  insert, low ground-level → extreme close-up, three-quarter → dead-side-profile).
- Never let two consecutive shots sit at the same point on the shot-size ladder
  (§3) or the same angle (§2) — if they would, that's the actual cause of a scripted
  cut rendering as a continuous take, not a labeling problem.
- This applies on top of, not instead of, whatever rhythm-tag/emotion pairing the shot
  already carries per §7 — state both the emotional camera language and the frame-size
  contrast for every cut.

## 10. Exclusive framing forces a composition change; behavioral prohibitions don't

A related failure from the same project: a scripted insert shot ("close-up on his face
after being stomped") never appeared at all across a generation — the camera stayed on
his feet/legs from the previous shot straight through where the insert should have cut
in. The fix that worked was not a stronger version of "close-up on his face" — it was a
**literal, exclusive framing constraint**: "the frame is filled edge-to-edge by his face
alone — no helmet brim, no shoulder armor, no background, nothing else visible at any
edge of the frame... this shot must not show his feet, his boots, or the ground at any
point." Naming what must be *absent*, as concretely as what must be present, is what
actually forces the composition to change; a bare positive instruction ("close-up on
his face") leaves the model free to keep drifting on the prior shot's framing.

- For any insert, extreme close-up, or composition-critical cut, state the exclusion
  explicitly and concretely — name the specific things that must not be visible (a body
  part, a prop, the background), not just what should be.
- This is the same underlying lesson as `micro-expression-physics.md` §4's rule that a
  negative constraint alone ("no eye contact") doesn't fix a behavior — but here it
  applies to framing/composition rather than a character's physical reflex, and the fix
  is the mirror image: an *exclusive* positive constraint (only X is visible) rather
  than a purely behavioral prohibition.

## 12. Eyeline lock for dialogue directed at another character

A line of dialogue written to be delivered *at* another character can still render as
delivered to camera instead — not because the model ignored the instruction, but
because the instruction itself said so. A real prompt in this project wrote a
reveal-and-confront beat as "she rounds fully toward camera now... and spits [the
line]" — intending a dramatic turn, but literally telling the model to face the lens.
The generation followed that instruction exactly: she turned to camera, not to the
other character. This was a prompt-authoring bug, not a generation miss, and it's
worth naming as its own check because "toward camera" is an easy phrase to reach for
when writing a dramatic turn without meaning it literally.

- When a character turns to confront, address, or deliver a line at another character,
  name the target explicitly as that character (by subject label or description), not
  "toward camera" or "toward the viewer" — state the eyeline as locked on the other
  character's face specifically.
- Reserve actual direct-to-lens delivery (per §2's table) for a scene that genuinely
  wants that confrontational/subjective-address read — a monologue, a POV device, a
  character breaking the fourth wall — and say so only when that's the intent.
- When QA-ing a generation that shows a line delivered to camera instead of to another
  character, check the prompt text itself first per this section before treating it as
  a generation failure — if the shot literally said "toward camera," the model did
  exactly what was asked and the fix is a one-line prompt edit, not a rewrite of the
  whole beat.

## 13. Forbidden by default

- Never substitute `zoom` for physical camera movement (dolly, track, crane, push-in,
  pull-out) — zoom and a physical move read completely differently and are not
  interchangeable.
- Never ask for "no stabilizer" without also specifying the breathing quality wanted
  (steady vs jittery) — an unstabilized camera with no described breathing quality is
  an underspecified instruction, the same way an unstated duration is.
- Never oversell camera motion relative to the scene's own emotional register — an
  intimate, quiet scene gets an intimate, quiet camera; motion for its own sake reads
  as showing off, not storytelling.
