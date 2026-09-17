# Multi-pose fashion-editorial sequences: three failure modes distinct from action/destruction craft

A 4-part, 60-second luxury fashion film (10 poses per 15s prompt, split across a studio pair and
a palace pair per `examples/royal-fashion-film/`) surfaced three failure modes this project
hadn't documented before, plus one confirmation. None of these are the action/fight-specific
findings in `action-sequence-craft.md` — a fashion-pose sequence has no combat, no destruction,
and often no causal chain between beats, but it shares the same "many distinct compositions in
15 seconds" risk profile, and needs its own checklist.

## 1. Cumulative drift can compress a whole pose out of existence, not just delay it

`action-sequence-craft.md` §3 documents content landing *late* relative to its scripted window.
This project's palace sequence showed a harsher version: one pose (a golden-window profile
portrait, scripted for 00:06.0-00:09.0) held roughly 4-5 seconds past its own end, and the next
scripted pose (seated on a marble staircase) never appeared in the clip at all — not late, not
compressed into a fragment, simply absent. The pose after that (a body-turn silhouette scripted
for a full 3.5s window) did eventually appear, but compressed into the final ~1 second of the
clip. Confirmed via dense frame sampling: the scene-change score at both of that pose's scripted
cut points was near zero (0.02, 0.01), against 0.4+ scores at every other cut in the same clip —
a real content failure, not a soft continuous move as the prompt's own transition language
might suggest.

**Root cause (consistent with action-sequence-craft.md §3's smaller-scale version)**: a portrait/
hold beat with no explicit maximum duration is free to run long, and every beat after it inherits
the deficit. Five poses in 15 seconds (3s average) is already tight; one beat overrunning by even
2-3 uncapped seconds is enough to delete a later beat outright rather than merely delay it.

**The fix**: for any beat that is a hold/portrait/pause (not a hard action), state an explicit
duration ceiling *at that beat*, and pre-commit the very next beat to start immediately at that
ceiling — both halves matter:
```
The camera holds the silhouette for no more than 2.5 seconds total — this profile portrait
must not extend past 00:06.500 under any circumstance.
[Shot 4] At 00:06.500, the camera cuts immediately to reveal her already seated on the wide
marble step — no continued profile hold, no lingering on the window portrait from Shot 3.
```
A bare `[Shot N] At MM:SS.mmm, ...` timestamp on the *next* shot is not sufficient by itself —
this project already had that timestamp in the failing prompt. The addition that matters is the
explicit ceiling stated on the *overrunning* shot, paired with an explicit "cuts immediately,
no lingering" instruction on the shot after it.

## 2. An attribute genuinely absent from the reference image gets invented, inconsistently, across shots

`action-beat-defaults.md` §3 already documents a named object ("a bicycle") rendering as a
visually-adjacent substitute. This is the sharper case: the reference image showed a floor-length
gown with the subject's feet never visible at all, so footwear was never defined by any reference
or subject description. Across a 4-part, 20-pose sequence, three separate shots each invented
different footwear — an open sandal, pointed heels, a gold shoe — none matching each other, none
matching anything in the reference. A same-shot identity drift compounded it once: the one pose
that most needed a floor-length hem (a seated reveal) also rendered the dress itself shortened to
knee-length alongside the invented heels.

**Root cause**: "no footwear appearing" as a bare negative constraint has nothing positive to
replace it with once a shot's own composition (a seated pose, a low-angle full-body shot) makes
feet compositionally unavoidable — the same failure shape `micro-expression-physics.md` §4
documents for behavior, here applied to an undefined visual attribute. A negative constraint
alone doesn't survive contact with a shot that structurally needs an answer.

**The fix — pick one, deliberately, rather than leaving it implicit**:
- **Crop around it**: for every shot where the framing risks showing feet, state the framing
  ceiling explicitly — "the framing never drops below her ankles at any point in this shot" —
  rather than trusting a generic negative constraint to hold.
- **Define it**: if some shots must show full body, give the model something to lock instead of
  leaving a blank — "wearing simple nude strappy sandals, low heel, consistent across every
  shot" — the same principle as replacing "a bicycle" with "a pedal bicycle, no engine, no
  helmet" in `action-beat-defaults.md` §3. An undefined attribute invites a different guess in
  every shot; a defined one is at least a consistent guess.
- Whichever is chosen, state the identity-lock for any attribute the reference image doesn't
  show at every beat that could reveal it, the same discipline already used for face/hair/
  outfit — don't assume a single blanket "no X" sentence written once covers every later shot
  compositionally.

## 3. Prose-only continuity between separately-generated clips is unreliable — confirmed, not just theorized

This project flagged in advance that a written "seamless transition" instruction between two
independently-generated H3 clips is weaker than an actual first-frame anchor, since neither
generation has access to the other's real pixels. The 4-part film confirmed this directly on
one boundary and got a lucky partial pass on the other: the clip designed to open on a graphic
echo of the previous clip's ending (a held reflection-and-flash beat) instead opened as a
completely fresh establishing shot with no visual relationship to what preceded it. The next
boundary's clip, by contrast, opened on a hand/face occlusion that plausibly read as a
continuation of the prior clip's shoulder-turn ending — but this was not designed to do that any
more precisely than the failed boundary was; it happened to land closer by chance.

**The fix, when true seamlessness matters**: don't rely on prose describing the *previous*
generation's content — the current generation was never shown it. Once the earlier clip is
actually rendered, extract its real final frame and feed it forward as a concrete `<Picture N>`
first-frame anchor for the next prompt's `[Shot 1]` (per `minimax-h3-prompt-writing`'s
`ref-en.md` §2.2, a `<Picture N>` can anchor a shot's first frame even in full-reference mode).
This is the only mechanism that gives the next generation the actual prior pixels rather than a
verbal description of them. Reserve prose-only bridging (matching the *kind* of composition —
both a held close facial framing, both a hero stillness) for drafts where a human editor will
cut the two clips together and only needs them to *feel* continuous, not for a claim of true
frame-locked continuity.

## Using this in Phase 2 / Phase 3

- When a multi-pose sequence divides N poses across a duration, check the poses-per-second ratio
  against 15s H3 clip: much past ~3 poses per clip (5 poses / 15s, as used here) raises real
  compression risk per finding #1 — state an explicit duration ceiling on every hold/portrait
  beat, not just a start timestamp on the following one.
- Before handing off a Ref2VA prompt, check every subject attribute the reference image does
  *not* show (footwear, hands if cropped, jewelry beyond what's visible) and either add a framing
  ceiling or a stated definition for each — don't rely on a single negative constraint sentence
  written once.
- Never promise the user (or write into a prompt's summary) that two separately-generated H3
  clips will be pixel-seamless from prose description alone — say explicitly that true
  seamlessness requires the last-frame-anchor technique above, once the first clip actually
  exists to extract a frame from.
- In Phase 3 QA on a multi-pose sequence, when a scene-change score near a scripted cut is near
  zero, don't assume it's an intentional continuous move just because the prompt scripted one —
  check the actual frame content at and after that timestamp; a genuinely dropped or heavily
  delayed pose produces the same near-zero score as a successful continuous shot.
