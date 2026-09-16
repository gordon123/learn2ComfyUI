# Path-annotated reference images: the drawn overlay leaks unless you stop naming it

A distinct sub-pattern of the grid/annotation problem `grid-reference-director` already covers
for multi-panel boards and top-down floor-plan camera maps: a **single photo with a camera-path
diagram drawn directly on top of the subject** — numbered waypoints, a curving line, an arrowhead —
used as an H3 Ref2VA `<Picture 1>` to script one continuous POV shot along that route (a "fly along
the body" insect/drone-POV shot is the recurring use case in this project). This file exists because
it took three full generations to find a fix that actually held, and each intermediate attempt is
informative on its own.

## The three-generation arc

**v1 — told the model the diagram exists, asked it to preserve everything anyway.**
`retention_analysis` read `<Picture 1>: fully_preserved`, with no distinction between the photo and
the annotation drawn on it. Result: the path line, dots, and labels rendered on screen for **over
half the clip's runtime**. A single prohibition sentence at the end of `detailed_description`
("prohibit rendering the reference path line...") did nothing against a field that was actively
telling the model to preserve the whole reference.

**v2 — reclassified the diagram as `attribute_transfer`, added positive "clean skin" language at
every waypoint, still named the diagram in `retention_analysis`.** This shrank the leak substantially
(from a thick line with large labels to a small arrow with 1-2 characters) but did not eliminate it —
it now appeared in ~65% of the runtime, reappearing right through the closing still-hold shot, which
had actually been clean in v1. **A new defect appeared**: the summary/detailed_description described
the POV as "a tiny flying observer — like a small insect," and the model rendered an actual visible
insect body (wings, legs) sitting at one waypoint. Naming a creature as a noun, even only to describe
a camera's implied viewpoint, gave the model a subject to draw, not just a framing conceit.

**v3 — removed all mention of the diagram from `subject_definitions` and `retention_analysis`
entirely; removed "insect" as a noun.** `<Picture 1>` is described in `subject_definitions` as
nothing more than an ordinary photo of the person/pet/room — no sentence anywhere states that it
carries a path, waypoints, or an arrow. The entire camera route is instead written as pure
cinematography prose in `detailed_description` (low, close, banking, decelerating at two named
points), derived from the diagram but never citing it as visual content. The POV's motion is
described only by its qualities (low, close, banking, hovering, weightless) — never as a creature.
Result, checked frame-by-frame at 0.5s intervals across the full clip: **zero path-line leakage,
zero visible creature body, zero hard cuts** — a complete fix, not an improvement. See
`examples/v3-corgi-pov-insect/` for the full prompt and QA report.

## The fix, stated as a rule

If a reference image has *anything* drawn on it that must not appear in the output (a path, an
arrow, a waypoint dot, a grid line, a panel border — anything from `grid-reference-director`'s own
list of annotation types), **do not describe that image as containing the annotation anywhere in
`subject_definitions` or `retention_analysis`.** Those two fields are where H3 is told what to
*preserve* from a reference; naming the annotation there, even to immediately disclaim it or
mark it `attribute_transfer`, still gives the model a reason to treat it as part of the reference
worth rendering. Instead:

- Describe `<Picture N>` only in terms of its actual photographic subject (the person, the pet, the
  room) — as if the annotation were never there.
- Translate whatever the annotation specifies (a camera route, a movement direction, a timing cue)
  into ordinary cinematography prose inside `detailed_description`, the same way
  `grid-reference-director`'s `floor-plan-camera-map.md` already directs for top-down camera maps.
  This file's finding sharpens that guidance for the specific case where the diagram is drawn
  directly on the subject in the same photo, rather than on a separate map image: even
  `attribute_transfer` — a real, official retention-analysis value — was not narrow enough to stop
  the leak once the diagram was named as part of what that Picture reference contains.
- If the shot's camera POV is metaphorically "like" some creature or object (an insect, a drone, a
  marble rolling), never use that word as a noun describing something present in the scene. Describe
  only the motion's physical qualities (speed, banking, altitude, hover behavior) and state
  explicitly, as its own separate sentence, that no creature/object body of any kind is ever visible
  on screen — don't fold this into the same sentence as the anti-annotation constraint, since v2's
  single blended framing left both problems half-solved.

## Using this in Phase 2 / Phase 3

- Before writing a Ref2VA prompt from any reference image carrying a drawn path/arrow/waypoint
  overlay, check the draft's `subject_definitions` and `retention_analysis` for any sentence that
  names the diagram — even a hedge like "the drawn line is not visual content" is still naming it,
  and per this file's confirmed finding, naming it at all is the failure mode, not just naming it
  uncritically.
- In Phase 3 QA on a generated clip from this pattern, sample frames across the *entire* duration,
  not just the opening — v1 and v2 both had clean stretches (a slow-motion emphasis shot, a fast
  transit) that masked leaks reappearing elsewhere, including at the very end.
- If the shot describes a bodiless/implied observer (insect-POV, drone-POV, spirit-POV), treat "does
  a visible body ever render" as its own explicit QA checkpoint, separate from the annotation-leak
  checkpoint — they are different failure modes with different fixes, confirmed by v2 hitting both at
  once.
