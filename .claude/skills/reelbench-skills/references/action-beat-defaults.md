# Action beats revert to the model's default shot unless they're locked down explicitly

Three related failure patterns from the same generation (Bangkok soi walk vlog, MiniMax H3
Ref2VA, 2×15s), all sharing one root cause: a beat description that names an *action* without
also locking down the *shot type*, *visual texture*, or *object identity* that action depends on
gets rendered against the model's own default for that action — not against what the rest of the
prompt implies. See `examples/bangkok-soi-walk/` for the full prompts and QA report this file is
drawn from.

## 1. A late "turn around, keep the camera on your own face" beat can silently drop the selfie framing entirely

The prompt scripted a single continuous handheld-selfie take for all 15 seconds, with a final
beat: the subject turns around, walks backward, and keeps holding the camera on her own face
while waving goodbye. What generated instead was a hard reframe — within roughly 6-8 frames
(~0.25-0.3s) the shot jumped from close arm's-length selfie to a static-feeling third-person wide
shot: she walked *forward*, full body in frame, no camera visible in her hand at all. This is a
real, sharp event (the highest ffprobe scene-change score across either generated clip in this
project run — 0.113 vs. a clip-wide max of 0.087 elsewhere) even though it fell under the
conventional hard-cut threshold (~0.3-0.4), because the background changes gradually rather than
jumping location — a fast reframe, not a cut, so don't rely on the cut-threshold check alone to
catch this failure mode.

**Root cause**: "she turns around and walks backward, waving goodbye" is, by itself, a stock
third-person farewell shot in the model's training distribution. Establishing the selfie framing
earlier in the same continuous shot does not carry forward through a beat whose action has a
strong competing default. The instruction that mattered ("the camera stays in her own hand, at
arm's length, pointed at her own face") was implied by the shot's opening, not restated at the
point where it was most likely to be overridden.

**The fix**: for any beat late in a shot whose action has an obvious competing default framing
(walking away/backward, a group entering frame, a vehicle passing), restate the required
shot type as its own explicit sentence *at that beat*, not only once at the top of
`detailed_description`. State it as a positive requirement plus its negation together, the same
two-part pattern that fixed the insect-POV leak in `path-annotated-reference-images.md`: "the
camera remains in her raised hand at arm's length, pointed back at her own face, exactly as
established at the start of this shot — no third-person, wide, or over-the-shoulder framing may
appear at any point in this shot."

**Confirmed fixed** — regenerated with the fix applied (`examples/bangkok-soi-walk/part2-prompt-v2.md`,
QA report `examples/bangkok-soi-walk/report-v2.html`): the selfie framing held continuously
from the 00:09.8 turn beat through the clip's end at 15.08s, with no reframe. The peak
scene-change score inside that beat window dropped from 0.113 (v1's own clip-wide high point) to
0.061 — in line with the clip's other ordinary motion peaks rather than standing out as a
divergence event. The two-part positive-plus-negation sentence, restated at the beat itself, is
what did it — this is now a validated fix, not just a hypothesis.

## 2. A single style-label sentence does not override the model's default clean-photorealistic rendering

The prompt opened `detailed_description` with one style sentence: "nostalgic early-2000s personal-
camcorder aesthetic, photorealistic, handheld selfie framing with slightly soft focus pull, mild
motion blur on fast moves, faint lens flare in bright patches, and a warm, slightly overexposed
color grade." None of these four texture cues (soft focus, motion blur, lens flare, overexposure)
appeared anywhere across either 15-second clip, sampled at roughly 1-second intervals. Everything
else in the same sentence (photorealistic, handheld, selfie framing) rendered correctly — only the
period-specific texture cues were dropped.

**Root cause**: this is the same failure shape `micro-expression-physics.md` already documents for
emotional beats — a single descriptive label stated once has to compete against a strong default
(here, clean modern photorealism) with nothing reinforcing it. A genre label is not self-
enforcing across 15 seconds of generation.

**The fix**: if a specific visual texture must hold for the full duration of a shot, restate at
least one concrete instance of it at more than one point in `detailed_description`, not just in
the opening style sentence — e.g., naming a specific highlight that blooms/overexposes at a
specific beat, or a specific instant of motion blur tied to a specific fast movement, rather than
trusting one adjective-laden opening sentence to hold for the whole shot.

**Partially confirmed** — regenerated with two concrete texture instances restated mid-shot
(`part2-prompt-v2.md`): the two instances that were tied to a specific beat and a specific object
both rendered — a visible overexposure bloom on skin/hair under the tree, and visible motion blur
on the passing bicycle's wheel/handlebar. The two cues that were only restated as a general
sentence at the top (soft focus-pull, lens flare) still did not clearly appear, and the clip's
overall image quality still reads closer to clean modern photorealism than genuine camcorder
grain. Refined takeaway: it's not restating the *style sentence* that works, it's tying each
individual texture cue to a specific beat/object the same way the shot-type fix in finding #1
does — a cue with nothing concrete to attach to still won't hold.

## 3. A generic vehicle/object noun can render as a visually adjacent substitute

The prompt asked for "a bicycle rider passes close behind her." What passed behind her was a
person in a motorcycle-style helmet in a riding posture consistent with a moped/scooter — bicycles
appeared only later, as parked background props uninvolved in the action.

**Root cause**: "bicycle" alone doesn't rule out other two-wheeled vehicles the model considers
visually or contextually adjacent for a busy alley scene, the same way earlier work in this
project found that naming a POV "like a small insect" gave the model license to render a literal
insect body (`path-annotated-reference-images.md`). A bare noun for an object involved in an
action beat is not automatically a strong enough constraint on its own.

**The fix**: when a specific object type must not be swapped for a visually adjacent one, state
what it explicitly lacks the same way identity/wardrobe fields already do — "a pedal bicycle,
no engine, no helmet on the rider" rather than "a bicycle" alone — especially for objects that
share a category with a common substitute (bicycle/moped/scooter, umbrella/parasol, van/truck).

**Confirmed fixed** — regenerated with "a pedal bicycle (no engine, no helmet on the rider)" in
place of "a bicycle" (`part2-prompt-v2.md`): both the passing rider (~00:02.2) and the parked
bike (~00:03.5) rendered as genuine pedal bicycles — visible spoked wheels, no engine housing, no
helmet on either. A parked scooter/moped is still visible as an incidental background prop at the
very opening (~00:00.5), unrelated to the scripted beat — worth its own "no other motorized
two-wheelers in shot" constraint if a fully bicycle-only alley matters for a future pass, but it
doesn't count against this fix.

## Using this in Phase 2 / Phase 3

- When handing off a multi-beat single-continuous-shot prompt, check every beat individually for
  whether its scripted action has an obvious competing default shot type, texture, or object —
  not just the shot's opening sentence. A beat near the end of a long single-shot take is at
  highest risk, since it's furthest from the framing/style instructions stated at the top.
- In Phase 3 QA, sample frames densely (every 0.2-0.3s) around any beat that changes direction,
  reverses motion, or ends the shot — a fast reframe here can fall under the conventional
  scene-change/hard-cut threshold while still being a real, visible divergence from a continuous-
  shot instruction. Cross-check the ffprobe scene-score's peak value against the rest of the clip,
  not just against a fixed threshold, the same way this file's finding #1 was actually caught.
- A style-label mandate ("nostalgic camcorder look", "watercolor style") that produced zero visible
  effect across a whole clip is a distinct, reportable finding from a beat-content miss — don't
  fold it into a generic "style seems off" note; name it as its own row in the fidelity table.
