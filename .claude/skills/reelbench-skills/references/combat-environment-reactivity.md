# Combat Environment Reactivity

How a fight scene's own effects (magic glow, impacts, explosions) should visibly touch the
environment around them — light, shadow, smoke, and debris reacting to the action rather than
sitting inert behind it. Distinct from `action-sequence-craft.md` §2 (which covers destruction
*persisting* once it happens — cracks don't heal, debris doesn't vanish) and from
`minimax-h3-prompt-writing`'s "Fire, light, and particle VFX" section (which covers a single
effect's own internal structure — layered color, decay, trajectory). This file is the missing
third piece: how the effect and the environment *light each other*, moment to moment, not just
whether the damage sticks around afterward.

Named techniques below come from `melies-cinematic-library`'s lighting, atmosphere, and
in-camera-effects catalogs — use the real term in the prompt (it gives the model something
concrete to resolve toward) rather than a vague adjective like "dramatic lighting" or "cool VFX."

## What it's for

Any shot where a magical/energy effect, an explosion, or a heavy impact happens in a real
environment — a courtyard, a room, a street — and the brief wants that environment to read as
physically present during the action, not just a backdrop the fight happens in front of.

## The techniques

### 1. The VFX is a light source — treat it as motivated/practical lighting
A glowing hand, an energy blast, a fireball is not just a shape on screen — it is the brightest
light in the shot for as long as it's lit, and everything near it should show that. This is
`melies-cinematic-library`'s **Motivated Lighting** / **Practical Lighting** applied to a VFX
source instead of a lamp or window: name the effect as the light's origin explicitly ("the red
glow is the shot's key light for this beat"), state its color temperature bleeding onto nearby
skin, fabric, and stone, and let it dim or brighten the shot as the effect itself pulses or
fades. A courtyard lit only by daylight should visibly gain a red cast on the nearest surfaces
the instant the glow brightens, and lose it as the glow dies down.

### 2. Smoke and dust are the medium the light travels through, not a texture layer on top
Per `melies-cinematic-library`'s **Volumetric Light** and **Smoke** entries: smoke and dust
aren't just visual clutter, they're what makes light beams and glow visible as shafts and
swirls in the air. Name the backlight or glow source, the direction it's coming from, and let it
carve visible shafts through the drifting dust from a footfall or a blast — this is what makes an
effect feel like it's in the same physical air as the characters rather than composited flat on
top of the footage. Per `minimax-h3-prompt-writing`'s VFX-decay guidance, keep the smoke thinning
and dispersing across subsequent shots rather than holding a constant density.

### 3. Debris and sparks are discrete, countable particles — not a blanket
`melies-cinematic-library`'s **Particles** and **Sparks and Embers** entries both stress this:
real debris/spark effects read as individual bits with their own trajectory and light response
(a fleck of stone catching the glow as it tumbles, an ember arcing and dimming as it falls), not
as a uniform haze or a generic "dust cloud" note. When a shot has a destruction beat, describe at
least one or two specific particles this way rather than only the aggregate cloud.

### 4. Cast shadows and flicker respond to the effect in real time
A bright, fast-pulsing VFX source should throw a moving, flickering shadow off nearby debris,
architecture, or the characters themselves — the live-action equivalent of
`melies-cinematic-library`'s **Gobo Lighting** (an object in the beam throwing graphic shadow
shapes), except here the "gobo" is the drifting smoke or thrown debris itself passing in front of
the glow. State this explicitly when the environment has anything for the light to catch on
(a pillar, a lantern, a stone railing) — an unshadowed, evenly-lit background during a bright
magic effect is the tell that the effect isn't really interacting with its surroundings.

### 5. The moment of impact can justify a Light Flash
For the single peak instant of a major collision or explosion, `melies-cinematic-library`'s
**Light Flash** (a brief blowout of the frame to white or near-white, then a return) is a real,
named technique for exactly this beat — distinct from the freeze-frame/speed-ramp pairing this
project already uses for the same instant (see the Part 2 clash shot in this project's own
history). The two combine naturally: freeze the motion, flash the frame toward white or the
effect's own color at the peak, then snap back to hyper-speed motion as the flash clears — state
both explicitly rather than assuming a freeze-frame alone implies a light response.

### 6. Bounce light carries the VFX's color onto surfaces it never directly touches
Per `melies-cinematic-library`'s **Bounce Light**: a bright enough glow or explosion should
reflect off the nearest large flat surface (a stone wall, wet ground, a pillar) and pick up that
surface's own color and softness on its way back — this is what sells an effect as physically
present in a specific location instead of a generic overlay that would look the same anywhere.
Name the reflecting surface and its color when the environment has an obvious candidate nearby.

## Structural checklist

Before finalizing an action/VFX shot, check:
- Does the effect's light visibly touch nearby skin, fabric, and architecture, brightening and
  dimming with the effect itself (technique 1)?
- Is smoke/dust named as the medium the light shafts travel through, not a static backdrop
  texture (technique 2)?
- Does at least one debris/spark beat get individual, countable treatment rather than a generic
  cloud (technique 3)?
- Does anything in the environment throw a flickering or moving shadow in response to the effect
  (technique 4), where the scene actually has something for it to catch on?
- For a single peak-impact beat, is a Light Flash considered alongside any freeze-frame/speed-ramp
  already scripted for that instant (technique 5)?
- Does a nearby large surface pick up bounce color from a bright enough effect (technique 6)?
- Does the damage this reactivity lights up actually persist afterward, per
  `action-sequence-craft.md` §2 — a beautifully lit crack that heals itself next shot is still a
  continuity failure this file doesn't fix on its own?

## Boundaries

- This file governs light/shadow/smoke *reacting* to combat VFX and destruction. For whether
  destruction itself persists and escalates shot to shot, use `action-sequence-craft.md` §2. For
  a single effect's own internal color/decay/trajectory structure, use
  `minimax-h3-prompt-writing`'s "Fire, light, and particle VFX" section. Apply all three together
  on a real destruction-heavy action sequence — they cover different, non-overlapping layers of
  the same beat.
- Don't reach for every technique in every shot — a quiet dialogue beat doesn't need bounce light
  analysis. This applies specifically to shots with a real VFX/impact/explosion source bright or
  forceful enough to plausibly affect its surroundings.
- Name the real technique term (Motivated Lighting, Volumetric Light, Bounce Light, Light Flash,
  Particles, Gobo Lighting) in the actual shot text where it applies — a vague "dramatic lighting"
  or "cool effects" note gives the model nothing concrete to resolve toward, the same lesson
  `camera-emotion.md` already applies to camera angle vocabulary.
