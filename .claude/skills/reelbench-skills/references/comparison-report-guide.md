# Before/After Comparison Report Guide

Build this as a self-contained HTML Artifact, not a text summary — the whole point is
that the user can watch both clips and see the measured data next to them, not just
read a verdict. Follow the artifact-design and dataviz skills' fundamentals (theme
tokens for light/dark, a real palette, an interactive chart with a hover layer) rather
than a bare unstyled dump.

## What goes in it

1. **Header** — one line naming what's being compared (reference clip vs. what it
   generated) and why (checking a specific prompt's fidelity, not a generic review).

2. **Source clips, side by side** — both videos embedded and playable, each with its
   own stat chips (duration, resolution, shot/cut count if known). Label columns
   consistently (e.g. "Reference" / "Generated") and carry that same left/right or
   teal/amber convention through every section below — a reader should never have to
   re-figure out which column is which partway down the page.

3. **Sampled frames, matched positions** — pull frames from both clips at comparable
   relative points (e.g. start / middle / near-end, or every Nth shot if both have
   multiple), grid them so the same position lines up visually between the two clips.
   This is usually where a continuity miss (a different camera angle where one was
   supposed to hold, a dropped prop, a costume that didn't carry over) becomes obvious
   at a glance, faster than reading about it — caption what to look for.

4. **Scene-change score, both clips, one chart** — run the same ffprobe scene-score
   analysis (`footage-analysis-guide.md`) on both clips and overlay them on one chart,
   x-axis normalized to % of each clip's own duration (so different lengths compare
   fairly), single y-axis, one line per clip in a fixed two-color assignment matching
   the column labels above. State plainly if the analysis can't cleanly separate real
   cuts from motion-induced delta (e.g. a spinning prop or handheld shake keeps the
   score elevated throughout) rather than overclaiming precision it doesn't have.

5. **Fidelity table** — the actual QA content. List what the prompt specifically asked
   for (pull the real fields/lines from the prompt that was sent to generation — not a
   restatement of the Continuity & Style Brief) as rows, with a Match / Partial /
   Diverged verdict and a one-line concrete reason for each. Cover at minimum whatever
   the prompt locked down explicitly: identity/appearance, wardrobe or prop state,
   camera movement type, color/lighting grade, location, and duration. A generic "looks
   similar" is not a row — every verdict needs to point at something visible in the
   frames or audible in the clip.

6. **Process-gap callout, if one exists** — if something about how the prompt was
   written plausibly caused a miss (an unstated duration, an ambiguous reference role,
   a camera instruction that wasn't emphatic enough), say so explicitly as a note on
   the pipeline's own output, not just a note on the generation model's behavior. This
   is the difference between a QA report and a complaint about the model.

7. **Verdict** — a short score (e.g. "3/6 fields matched") plus what to change in the
   next prompt pass. Keep it actionable — name the specific rewrite, not just "try
   again."

## What NOT to do

- Don't fabricate a shot-by-shot cut list for the generated clip from scene-score data
  alone when the prompt only specified one continuous shot — eyeball the sampled
  frames and describe what's actually visible (different angles, a held take) rather
  than asserting a precise cut count the detector can't reliably give you.
- Don't score fidelity against the Continuity & Style Brief when a specific prompt
  exists — the brief informed the prompt, but the prompt is the actual contract the
  generation should be checked against.
- Don't skip the process-gap callout to make the pipeline look cleaner than it was —
  an honest miss on this skill's own side (like an unstated duration) is exactly the
  kind of finding this report exists to surface.
