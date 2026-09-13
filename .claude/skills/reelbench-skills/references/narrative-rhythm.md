# Narrative-Rhythm Tags

Eight tags, one per shot, answering a single question: *why does the viewer keep
watching at this exact moment?* This is a different layer from the Continuity & Style
Brief's camera/color vocabulary — that layer describes *how a shot looks*, this one
describes *what job it does in the sequence*. Adapted from the tagging system in
eternityspring/reelbench-skills' `video-shots` skill (钩子/铺垫/递进/重音/转折/兑现/换气/收口),
repurposed here to also steer new shot sequences written for Seedance/MiniMax H3 —
not just describe existing footage.

## The eight tags

| Tag | What it does | Recognize it by |
|---|---|---|
| **hook** | Opens the sequence, earns the next few seconds | The first shot; something unresolved, striking, or in motion right from frame one |
| **setup** | Establishes who/where/what before anything pays off | Wide/establishing framing, low event density, laying out geography or relationship |
| **escalation** | Raises stakes, tightens the frame, or speeds the cutting | Shot size tightening shot-to-shot, pacing accelerating, tension visibly building |
| **beat** | A held emotional or comedic point — the sequence pauses on it | Longer hold, a reaction shot, a line landing, minimal new visual information |
| **pivot** | The turn — new information recontextualizes what came before | A reveal, a reversal, a cut that changes what the scene is actually about |
| **payoff** | Delivers on what hook/setup/escalation promised | The moment the built-up tension or question resolves |
| **breath** | A deliberate release — pacing slows, frame relaxes | Wider shot, slower cut, quieter composition after a dense run |
| **closure** | Ends the sequence, signals "this beat is over" | Final shot; often mirrors or answers the hook |

Tags don't have to appear in this order, and a short sequence won't use all eight —
a 3-shot scene might just be hook → beat → closure. What matters is that neighboring
shots don't repeat the same tag without reason (six flat/identical tags in a row
is the failure mode this system exists to catch, per the source skill's own gate 15).

## Using it in Phase 1 (analyzing reference footage)

For each detected shot, add one tag plus a one-sentence reason tied to what's actually
visible/audible in that shot — never just the tag name alone:

```
Shot 3 (44.2s–48.4s, medium-close, handheld) — escalation: cut length drops from
~20s to ~4s here and the framing tightens onto Hadley's face mid-argument.
```

If the clip is a single continuous take (no cuts to tag individually), don't force
per-shot tags onto nothing — instead give the whole take one tag describing its
overall narrative function (e.g. "the entire 9s take reads as a *breath* — a held,
uneventful moment with no escalation or payoff of its own"). Say so explicitly rather
than inventing shot boundaries that don't exist.

## Using it in Phase 2 (steering a new shotlist)

This is the part the source skill doesn't do, since it only analyzes existing footage.
Once the reference clip's rhythm map exists (or the user describes the beats they want
without footage to measure), carry it into the handoff to the downstream skill as an
explicit **rhythm map** — not just a duration and a style brief:

```
Shot 1 → hook: performer's poi ignite mid-frame as the shot opens, already in motion.
Shot 2 → escalation: camera tightens, cuts quicken as the spin builds.
Shot 3 → payoff/closure: full-frame close-up on the trail at its brightest, hold.
```

Hand this to `seedance-shotlist-director` / `minimax-h3-shotlist-director` (the
multi-shot skills) as a per-shot instruction alongside the Continuity & Style Brief —
tell it explicitly which shot should function as which beat, not just what it should
look like. For the single-shot skills (`seedance-director`, `seedance-clean`,
`minimax-h3-prompt-writing`), give the one overall tag the shot needs to hit — a
single-shot scene can still be told "this needs to read as a payoff" and that changes
what gets emphasized (hold length, what's centered, whether it opens or closes on the
key visual).

## In Phase 3 (QA)

Check the generated shotlist's actual rhythm against the map you gave it: did the shot
you called out as the "beat" actually land as a held pause, or does it read the same
as the shot before it? A rhythm-tag mismatch is worth its own line in the QA report
even though it isn't one of the 15 continuity gates — cinematically, dead pacing
(six shots doing the same narrative job) fails a scene just as surely as a broken
eyeline does.
