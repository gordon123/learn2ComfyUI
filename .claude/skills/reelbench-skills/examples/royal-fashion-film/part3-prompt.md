# Royal Fashion Film — Part 3/4 (Palace, poses 1-5) — MiniMax H3 Ref2VA, 15s, 9:16

Adapted from a second Seedance 2.5 prompt (a royal-palace fashion film, 10 more poses) continuing
the same character from Parts 1-2. See `references/multi-pose-fashion-sequence.md` — this part
is the drift case: Pose 4 was compressed out of the clip entirely.

SCRIPTED_DURATION: 15s

subject_definitions:
<Subject 1> is the woman in <Picture 1>, identified from her front full-body, side-profile, and close-up face views: dark hair swept into a low bun, fair skin, soft glam makeup, small diamond stud earrings, wearing a sleeveless floor-length olive-green column dress with a geometric sweetheart cutout at the collarbone and a long draped sash of the same fabric trailing from one shoulder down her back to the floor. No footwear is visible in the reference.
<Subject 2> is the monumental palace environment: a grand marble hall with towering columns, a wide marble staircase, tall arched palace windows admitting directional golden light, a stone balcony, and physically accurate marble floor reflections.

summary:
[reference generation] The target video is a 15-second ultra-photorealistic royal fashion film starring <Subject 1> inside <Subject 2>, opening on the same hero stillness and flash-lit reflection that closed the preceding sequence, then continuing through five connected poses — palace arrival, a column reveal, a golden profile portrait, a staircase descent, and a marble-floor turn — each pose's camera or body movement directly motivating the next.

retention_analysis:
<Subject 1> (appears in [Shot 1], [Shot 2], [Shot 3], [Shot 4], [Shot 5]): fully_preserved - face, hair color and bun, skin tone, the olive-green dress, its cutout neckline, the trailing sash, and the layered-jewelry styling stay identical to <Picture 1> throughout; no outfit change, no footwear invented.
<Subject 2> (appears in [Shot 1], [Shot 2], [Shot 3], [Shot 4], [Shot 5]): fully_preserved - the marble hall, columns, staircase, palace windows, and floor reflections stay consistent across all five shots, with a single constant light direction and time of day.

detailed_description: The target video is ultra-photorealistic luxury cinema — full-frame cinema camera, anamorphic characteristics, subtle film grain, realistic lens breathing, natural motion blur, authentic depth of field, realistic skin pores, individual hair strands, and physically accurate marble reflections; no anime, no cartoon, no CGI, no plastic skin.
[Shot 1] The shot opens on a held, motionless instant that graphically matches the reflection-and-flash ending of the preceding sequence — <Subject 1> standing perfectly still, her floor reflection beneath her — before the light settles and widens into a Wide Shot, Low Angle view of the grand hall of <Subject 2>. She walks into frame and stops in a powerful standing stance. As she stops, the camera Pedestals Up slightly and begins arcing toward her right side.
[Shot 2] At 00:03.500, the camera cuts to a drastically tighter framing as her shoulder passes close to the lens, briefly filling the frame edge-to-edge and creating a natural body occlusion — nothing else visible during the occlusion. The camera emerges from behind her shoulder in a Three-Quarter Angle as she places one hand against a monumental column and turns her face toward camera. The camera Pushes In as she turns her head toward the window light, using her own head-turn to motivate the push.
[Shot 3] At 00:06.000, her head completes the turn into a true Profile portrait beside a tall palace window; the camera holds the silhouette briefly. A controlled Rack Focus shifts the sharp plane from the architectural background to her eye while the camera performs a partial Arc rotation around her profile, carrying the rotation's momentum directly into the next cut.
[Shot 4] At 00:09.000, the camera completes the rotation and reveals her now seated elegantly on a wide marble step, one knee raised, the opposite leg naturally extended. The camera Pedestals Up on a diagonal path as she subtly adjusts her posture; her extended leg crosses through the foreground, briefly filling the frame edge-to-edge in a natural foreground wipe.
[Shot 5] At 00:11.500, as the foreground clears, reveal her standing again at the base of the staircase in a different asymmetrical pose — torso turned away, head looking back directly toward the lens. The camera performs a 360-Degree Orbit circling in the opposite direction from her own body turn; as she turns with the camera's motion, loose hair strands briefly cross the lens, carrying a natural motion occlusion into the shot's end at 00:15.000.
Maintain <Subject 1>'s exact face, hair color, skin tone, dress, cutout neckline, and sash identity in every shot — no redesign, no outfit change, no footwear appearing at any point, no added accessories. Maintain one constant lighting direction and time of day across all five shots. No rubbery limbs, no melting face, no inconsistent hands, no warped anatomy, no identity drift between shots. Every camera movement is motivated by <Subject 1>'s own movement — no floating-camera behavior, no teleportation, no discontinuous geography. Shot durations are deliberately uneven (3.5s, 2.5s, 2.5s, 2.5s, 4.0s) — no two consecutive shots share the same length.

overall_soundscape: Realistic footsteps on marble continue under soft ambient palace room tone; fabric and sash movement produce continuous natural sound, with a subtle camera-shutter click on the Shot 1-to-2 occlusion cut.

non_diegetic_music: Deep orchestral percussion at approximately 140 BPM with subtle sustained strings, continuing the momentum from the preceding sequence and building steadily through all five shots.

## QA findings from the actual generation — the drift case

- **Shot 1 did not graphically echo Part 2's reflection-and-flash ending** as instructed —
  it rendered as a fresh, unrelated establishing shot. Confirms prose-only cross-generation
  bridging is unreliable; see `references/multi-pose-fashion-sequence.md` §3.
- **Shot 3 (Golden Profile) held roughly 4-5 seconds past its own scripted end** (through at
  least 00:09.0, confirmed by frame inspection), well past its 00:06.0-00:09.0 window.
- **Shot 4 (Staircase Descent, the seated marble-step pose) never clearly appears in any
  sampled frame** — the time it should have used was consumed by Shot 3's overrun. This is
  the headline finding: a beat compressed entirely out of existence, not merely delayed.
- **Shot 5 (Marble Turn) does eventually land the correct pose and eyeline**, but compressed
  into roughly the final second of the clip instead of its scripted 3.5s window.
- Scene-change scores at the Shot 3→4 and Shot 4→5 cut points were near zero (0.02, 0.01)
  against 0.4+ at every other cut in the same clip — a real content failure, not the
  intentional continuous camera move the shot text describes.
- See `references/multi-pose-fashion-sequence.md` §1 for the fix: an explicit duration
  ceiling stated on the overrunning shot itself, paired with an explicit
  "cuts immediately, no lingering" instruction on the shot after it.
