# Action & Destruction Sequence Craft

Five principles make a fight/action sequence read as real and exciting rather than
choreographed and weightless. Three already live elsewhere in this stack —
`camera-emotion.md` covers angle-to-emotion and position-to-emotion (principle 2),
and `minimax-h3-prompt-writing`'s own "Physical realism" and "Sound must follow its
cause" sections cover momentum/weight (principle 3) and impact-synced audio
(principle 5). §1–§2 below cover the two that weren't written down anywhere else:
**deliberate pacing irregularity** and **cumulative, irreversible environmental
damage across a multi-shot sequence** — both surfaced from a real prompt reviewed in
this project that got the second one right by instinct while nothing in the guides
actually told anyone to do it. §3–§4 are two further, distinct findings from later in
this project's history — a sequence-level content-drift failure mode, and a confirmed
platform-level duration pattern — that aren't part of the original five but belong in
the same pre-handoff/QA checklist.

## 1. Pacing irregularity is itself a technique, not an accident

`camera-emotion.md` §5 gives duration ranges by function (a hard-cut flash: 0.3–0.5s,
a wordless reaction: 5–10s, and so on) — but picking one value from that table and
reusing it for every shot in a sequence produces a metronome, not excitement. The
technique is the **variance itself**: a sequence that alternates a long establishing
or setup shot with a sudden sub-second impact flash reads as more violent and more
controlled than one where every shot runs the same length, even if every individual
shot's content is identical.

When writing a multi-shot action sequence:
- State an explicit, uneven rhythm across the shot list up front — e.g. "shot 1 holds
  for the full setup (3s), shot 2 is a half-second impact flash, shot 3 breathes at
  2s, shot 4 snaps to 0.4s" — rather than letting every shot default to the same
  duration.
- Longer holds belong on setup/escalation beats (the audience needs to read the
  geography and stakes); the shortest, sharpest cuts belong on the actual point of
  impact.
- A hard rule of thumb: no two consecutive shots in an action sequence should run the
  same duration. If they do, deliberately lengthen or shorten one of them.

## 2. Environmental damage must accumulate and never heal

A destroyed environment that looks pristine again one shot later reads as fake
immediately, no matter how good the physics looked in the moment it broke. Across a
multi-shot action/destruction sequence, treat damage to the environment with the
**same identity-lock discipline** `minimax-h3-prompt-writing` already applies to
characters and props — once broken, a wall, pillar, or patch of ground stays broken
for every subsequent shot, the same way a character's face has to stay the same face.

- **State the damage causal chain once, explicitly**, and reuse it: force → deforms →
  cracks → breaks apart → scatters → settles. Each subsequent shot that reuses the
  same location should describe it in whatever state the chain left it in, not reset
  to intact.
- **Name persistence directly in the prompt**, the same way a locked costume change
  gets named: "the cracked pillar from the previous shot remains cracked and does not
  repair," "the crater in the ground from shot 3 is still present in the background
  of shot 5." Don't assume the model will remember on its own — state it.
- **Debris behaves physically after the break, not just at the moment of it**: dust
  keeps settling, small fragments keep sliding to a stop, smoke keeps thinning — across
  the shots that follow, not just the shot where the break happens.
- **Scale the damage to the sequence's own escalation** — early shots crack and chip;
  later shots in the same sequence should show heavier, larger-scale destruction than
  earlier ones, consistent with the narrative-rhythm tag each shot carries (an
  `escalation` shot's damage should visibly exceed the `hook` shot's).
- **Negative-constraints line, every time a sequence has real destruction**: explicitly
  forbid environment reset/auto-heal, forbid damage disappearing between cuts, forbid
  debris vanishing instead of settling — this belongs in the same negative-constraints
  note `minimax-h3-prompt-writing` already recommends for scenes with real drift risk.

## 3. Cumulative shot-content drift in a long multi-beat sequence

A distinct failure mode from principle 1 (metronome pacing) and from the hard-cut/
frame-contrast lesson in `camera-emotion.md` §9: even when every individual cut is
well-specified (real frame-size contrast, a clean isolated scene-change spike measured
in QA), a long sequence of many fast beats back to back can still drift — each shot's
*content* lands later than its scripted window, and the delay compounds shot over shot
rather than resetting. A real 11-shot sequence in this project showed clean, isolated
cuts on a scene-change scan (the editing mechanics were fine) while the actual actions
(a vault, an insert, a reflex-and-line beat, a slap) ran increasingly behind their own
timestamps, to the point that a shove written for one shot never clearly appeared at
all and a fall meant for an earlier shot surfaced two shot-windows late.

- Treat this as a real, distinct finding in Phase 3 QA — separate from cut-mechanics
  fidelity — whenever several consecutive shots each land later than scripted rather
  than each miss being independent: name it as cumulative drift, not N unrelated misses.
- When a span of the sequence is doing a lot in a few fast shots (e.g. four sub-1.5s
  cuts back to back covering a prop lift, a realization, a line of dialogue, and a
  strike), consider that the actual risk factor — not any single shot's instructions.
  Shortening that span's shot count, or giving it slightly more total time, is worth
  trying before rewriting individual shots that were already well-specified.
- A beat that has already proven itself rendering cleanly elsewhere in the same
  sequence (per this project's history: an exclusive-framing insert, a ground-level
  impact) is a safer template to reuse for a new beat than inventing new camera
  treatment for it — e.g. swapping a mis-rendering two-handed shove for a kick that
  reuses the stomp's already-proven ground-level/low-angle language.

## 4. The +1.5s duration overrun is a confirmed platform pattern, not a hypothesis

Three separate generations in this project, with three different prompt texts, each
scripted its shots to sum to exactly 15.0s and each came back at exactly 16.5s — the
same +1.5s overrun, landing in the same place (the final shot running long past its
own content) every time. This is no longer worth treating as a one-off or blaming on
the specific prompt's math.

- If a hard duration ceiling actually matters for the target platform or edit, script
  the shot list to leave that margin — e.g. write to ~13.5s of real content rather than
  15.0s, when the pipeline in use has shown this pattern.
- Otherwise, tell the user up front that this generation pipeline has a known ~1.5s
  overrun pattern (most likely a duration setting in the user's own generation
  workflow, not the prompt) before they spend another pass chasing it as a prompt
  defect.
- Keep watching for a fourth data point before treating the exact "+1.5s, in the final
  shot" shape as universal — but stop re-deriving it as a fresh hypothesis each time;
  cite this section instead.

## 5. Full checklist for an action/destruction sequence

Before handing an action-scene prompt to a downstream skill, or QA-ing one that came
back, check all five:

1. **Pacing**: does shot duration deliberately vary (no two consecutive shots the same
   length), with longer holds on setup and the shortest cuts on impact?
2. **Angle**: does the camera angle change with the beat (wide/establishing → low-angle
   attack → close-up impact → wide resolution), per `camera-emotion.md` §2–3, rather
   than holding one angle throughout?
3. **Physical weight**: does every strike show a visible physical consequence (stagger,
   recoil, momentum carried through), per `minimax-h3-prompt-writing`'s physical
   realism section? Is any two-character contact (shove, grab, mutual block) written as
   staggered/asymmetric rather than a simultaneous, mirrored, bilateral motion — a
   symmetrical two-handed shove has produced a visible anatomy-rendering glitch in this
   project's own history (`micro-expression-physics.md` §2a)?
4. **Environmental damage continuity**: does damage accumulate and persist across every
   shot that reuses the same location, scaling up with the sequence's escalation,
   with persistence stated explicitly rather than assumed?
5. **Sound-to-impact sync**: does every discrete sound follow its cause at the exact
   moment of contact, per `minimax-h3-prompt-writing`'s sound-causality rule?

A sequence failing #1 or #4 is the two failure modes this project has actually run
into and nothing previously caught — treat them with the same weight as the other
three when reviewing an action prompt.
