# Royal Fashion Film — Part 2/4 (Studio, poses 6-10) — MiniMax H3 Ref2VA, 15s, 9:16

SCRIPTED_DURATION: 15s

subject_definitions:
<Subject 1> is the woman in <Picture 1>, identified from her front full-body, side-profile, and close-up face views: dark hair swept into a low bun, fair skin, soft glam makeup, small diamond stud earrings, wearing a sleeveless floor-length olive-green column dress with a geometric sweetheart cutout at the collarbone and a long draped sash of the same fabric trailing from one shoulder down her back to the floor. No footwear is visible in the reference.
<Subject 2> is the luxury fashion-studio environment: a glossy black reflective floor, oversized architectural light panels, deep shadow zones, subtle atmospheric haze, geometric set structures, and dramatic isolated pools of light.

summary:
[reference generation] The target video is the second 15-second half of a photoreal luxury fashion-editorial film starring <Subject 1> inside <Subject 2>, covering the sequence's final five hero poses — a macro hand detail, a spiral turn, a lens reach, a vertical sculptural pose, and the iconic final hero frame — ending on a controlled flash to black.

retention_analysis:
<Subject 1> (appears in [Shot 1], [Shot 2], [Shot 3], [Shot 4], [Shot 5]): fully_preserved - face, hair color and bun, skin tone, the olive-green dress, its cutout neckline, the trailing sash, and the layered-jewelry styling stay identical to <Picture 1> throughout; no outfit change, no footwear invented.
<Subject 2> (appears in [Shot 1], [Shot 2], [Shot 3], [Shot 4], [Shot 5]): fully_preserved - the glossy black floor, light panels, haze, and geometric structures stay consistent across all five shots.

detailed_description: The target video is photorealistic, high-end luxury fashion-editorial cinematography — no anime, no cel-shaded linework, no 3D-CGI look, no chibi proportions; polished, dramatic, visually expensive.
[Shot 1] A macro-lens fashion close-up on <Subject 1>'s hand as her fingertips delicately adjust the edge of her sash where it meets her shoulder — the gesture subtle and elegant. A Rack Focus carries the focal plane from her fingertips to the sash's fabric weave, to the diamond stud earring beyond it, to her eyes, before the camera rapidly pulls out to a wider framing.
[Shot 2] At 00:02.500, the camera cuts to a wide framing as <Subject 1> performs a sharp, controlled pivot — her torso facing away while her hips and shoulders create opposing angles, one arm extending outward in an elegant diagonal line. The camera circles her in a 360-Degree Orbit rotating in the opposite direction from Shot 3 of Part 1, her hair and sash following the rotational momentum, completing the orbit directly behind her.
[Shot 3] At 00:05.500, the camera cuts to a frontal framing as <Subject 1> suddenly steps toward camera, her expression intense and confident. The camera performs a rapid forward Push In with slight handheld energy as she extends one hand toward the lens until her palm fills the entire frame edge-to-edge, nothing else visible at any edge. The frame cuts to complete darkness for a fraction of a second — a Flash Cut to black.
[Shot 4] At 00:07.500, the camera cuts to an extreme Dutch Angle, Worm's-Eye-View wide shot looking sharply upward at <Subject 1>, now in a dramatically elongated pose — one arm reaching vertically upward, the opposite arm angled downward, one leg extended diagonally behind her, forming a strong geometric silhouette. A hard Rim Light along one side separates her silhouette from the dark environment. The camera then performs a slow reverse Dutch Roll, rotating the horizon back level.
[Shot 5] At 00:10.500, the camera cuts to an extreme close-up on <Subject 1>'s eyes, locked directly onto the lens. The camera performs a rapid Pull Out from this close-up into a monumental full-body hero shot, revealing <Subject 1> standing completely still in a sophisticated asymmetrical stance — one shoulder slightly forward, one hand relaxed near her hip, head subtly tilted — with the entire luxury studio and her reflection on the glossy floor revealed beneath her. A final controlled photographic flash whites the frame briefly before cutting to black at 00:15.000.
Maintain <Subject 1>'s exact face, hair color, skin tone, dress, cutout neckline, and sash identity in every shot — no redesign, no outfit change, no footwear appearing at any point. No rubbery limbs, no melting face, no inconsistent hands, no warped anatomy, no identity drift between shots. Shot durations are deliberately uneven (2.5s, 3.0s, 2.0s, 3.0s, 4.5s) — no two consecutive shots share the same length.

overall_soundscape: Continuous soft fabric and sash movement sound under rhythmic footsteps and a crisp mechanical camera-shutter click on each pose change, building in density toward the final shot, followed by a single sharp shutter snap on the closing flash and then immediate silence.

non_diegetic_music: Deep electronic percussion at approximately 140 BPM continues from Part 1, joined by fuller sustained string textures that build to maximum density through Shot 4, resolving into a single sharp mechanical shutter-click hit on the final flash, then cutting to complete silence.

## QA findings from the actual generation

- Pose 7 (Spiral Turn): the single-shoulder sash rendered as two crossed straps — a minor
  wardrobe drift. See `references/multi-pose-fashion-sequence.md` for the fix pattern.
- Pose 8 (Lens Reach): the palm-fills-frame beat landed about 1s later than its scripted window
  — a small cumulative-drift instance.
- Pose 9 (Vertical Sculpture): a gold shoe appeared — undefined-footwear invention, same failure
  class as Part 1 Pose 1.
- Pose 10 (Iconic Final Frame): the pull-out only reached a chest-up medium shot by 00:12.0,
  not the scripted "monumental full-body" scale, before the cut to black — the payoff
  under-delivers relative to its own prompt text.
