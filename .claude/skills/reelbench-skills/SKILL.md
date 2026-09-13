---
name: reelbench-skills
description: Cinematic-continuity coach and router for the prompt-writing skill family (minimax-h3-shotlist-director, minimax-h3-prompt-writing, seedance-shotlist-director, seedance-director, seedance-clean, seedance-footage-vfx). Learns real shot grammar from reference footage the user supplies (via ffprobe/ffmpeg scene analysis), turns it into a Continuity & Style Brief, asks for (or recommends from the measured clip) a target generation duration, routes the actual prompt-writing task to the right downstream skill, then reviews that skill's output against a 15-point cinematic quality-gate checklist before it goes to generation. Once the user has an actual generated clip back, can also build a before/after HTML comparison report (original vs. generated: side-by-side players, sampled frames, scene-change chart, prompt-fidelity table) as an Artifact. Use when the user wants a sequence of AI-video prompts (MV, ad, scene, short film) to hold together as one continuous cinematic production instead of a pile of disconnected clips, when they hand over reference footage/films and want its shot language applied to new prompts, or when they want to check a generated clip against the reference it was built from. Does not replace or edit the downstream skills — it is a separate supporting layer that briefs them, QAs their output, and reports on the result.
---

# reelbench-skills

A support layer, not a prompt writer. It never writes the final MiniMax H3 / Seedance
prompt itself — that stays the job of the skill named in the brief below. Its job is
the two things nothing else in the stack does: (1) turn real footage into a concrete,
reusable cinematic vocabulary, and (2) hold every downstream skill's output to that
vocabulary and to basic continuity so a shotlist reads as one production, not N
disconnected generations.

## When to invoke

- User hands over reference footage (a film clip, a competitor MV, a mood reel) and
  wants its shot language ("cut like this") applied to a new prompt set.
- User is about to run a multi-shot sequence across `minimax-h3-*` or `seedance-*`
  skills and wants continuity enforced (recurring characters, consistent lighting/color,
  180-degree rule, matched pacing) rather than each shot prompt written in isolation.
- User asks "which skill should I use for this" between the MiniMax H3 family and the
  Seedance family.
- User already has a shotlist/prompt set from one of those skills and wants it audited
  before spending render credits.
- User has both the reference clip and the clip a downstream skill's prompt actually
  generated, and wants a before/after comparison.

Do not invoke for a single one-off prompt with no continuity or reference-footage need —
send that straight to the relevant skill (see routing table).

## Workflow

### Phase 1 — Learn (only if reference footage is supplied)

Run shot-level analysis on the reference footage with ffprobe/ffmpeg (see
`references/footage-analysis-guide.md` for the exact commands) to extract, per shot:
duration, shot size (wide/medium/close/etc.), camera movement, cut type, and dominant
color/lighting. Aggregate into a **Continuity & Style Brief**: average shot length,
shot-size distribution, camera-movement vocabulary actually used, pacing rhythm (are
cuts accelerating/decelerating), and color/lighting throughline. Present this brief to
the user before moving on — it's the thing the downstream skill's prompts get checked
against in Phase 3.

If no footage is supplied, skip straight to Phase 2 using the user's stated genre/tone
as the style brief instead of measured data — say explicitly that the brief is
inferred, not measured.

### Phase 2 — Route

Before handing off, settle the target duration — never leave it implicit. Every
downstream skill's format either requires a stated duration (MiniMax H3: 4-15 whole
seconds) or defaults to one if you don't give it one (Seedance: defaults to 10s, hard
cap 15s), so an unstated duration isn't a neutral omission — it's a silent guess that can come
back wrong (a real generation once came back at 18.6s, past H3's own 15s cap, from a
prompt that never named a duration). Ask the user what duration they want; if a reference clip
was analyzed in Phase 1, offer its own measured length as the starting suggestion
(rounded to a valid value for the target platform — nearest whole second for H3,
clamped to 4-15s for either), since matching the reference's own pacing is usually the
safest default when the user hasn't said otherwise. If the user's scene needs
noticeably more beats than the reference had shots for, say so and suggest a longer
duration instead of forcing it into the reference's runtime.

Then match the task to the right skill using `references/routing-matrix.md`. Tell the
user which skill you're handing off to and why, then invoke it (via Skill tool)
carrying the Continuity & Style Brief and the confirmed duration as context for it to
write against. Do not silently pick a skill the user didn't ask for if their ask
already names one — routing only resolves ambiguity.

### Phase 3 — QA the output

Once the downstream skill produces a shotlist or prompt set, walk it against the 15
gates in `references/quality-gates.md`. Report gate-by-gate pass/fail, and for every
fail give a concrete rewritten line the user can hand back to the same skill for a
targeted fix — never patch the other skill's output yourself. Flag gates you could not
check (e.g. no reference footage was given, so color-continuity has nothing to compare
against) as "not applicable" rather than guessing.

### Phase 4 — Before/after comparison report (once a generated clip exists)

When the user comes back with the actual clip a downstream prompt generated, and wants
it checked against the reference it was built from, build the comparison as an HTML
Artifact rather than a text summary — see `references/comparison-report-guide.md` for
the full structure (measured scene-change data for both clips, side-by-side players,
matched sampled frames, an overlaid chart, and a fidelity table scored against what the
prompt actually asked for, not against the Continuity & Style Brief in the abstract).
Score fidelity item-by-item against the specific prompt fields (identity, wardrobe,
camera move, color grade, duration, etc.) and call out misses plainly, including any
gap in the prompt itself (like an unstated duration) that plausibly caused one — this
report is a QA record, not a highlight reel.

## Boundaries

- Never edit files belonging to another skill.
- Never fabricate footage-analysis numbers — if ffprobe/ffmpeg isn't available or the
  file can't be read, say so and fall back to the inferred-brief path.
- The quality gates are advisory, not a hard gate that blocks generation — the user
  decides whether to act on a flagged issue.
- Never leave generation duration unstated when handing off to a downstream skill —
  ask, or propose the measured reference length, but always confirm one explicitly.
- In a comparison report, never grade fidelity against a vaguer brief than what the
  prompt actually said — a "partial" or "diverged" verdict must trace to a specific
  line in the prompt, not a general vibe.
