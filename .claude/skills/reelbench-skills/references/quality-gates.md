# 15 Cinematic Continuity Gates

Run every downstream prompt set (from `minimax-h3-*` or `seedance-*`) through all 15.
Mark each: PASS / FAIL / N/A (with why). A FAIL needs a concrete rewritten line, not
just "fix this."

1. **Shot-length consistency** — does each shot's stated/implied duration match the
   pacing rhythm from the Continuity & Style Brief (or the user's stated tempo)?
2. **Shot-size progression** — does the sequence vary wide/medium/close with intent,
   rather than repeating the same framing shot after shot?
3. **180-degree rule** — do consecutive shots of the same interaction keep camera on
   the same side of the action axis, unless a deliberate line-cross is called out?
4. **Eyeline / gaze match** — when two shots are cut together as a look/reaction pair,
   do the described gaze directions actually match up?
5. **Camera-movement vocabulary** — does the prompt only use movements present in the
   brief's vocabulary (or explicitly justified new ones), not a random grab-bag?
6. **Motivated movement** — is every camera move (push, pan, whip) tied to something in
   the scene (a character move, a reveal, an emotional beat), not decorative?
7. **Color/lighting continuity** — does each shot's stated lighting and palette stay
   consistent with the brief's throughline (or with the previous shot, if no brief)?
8. **Character/costume/prop continuity** — do recurring characters keep consistent
   described appearance, wardrobe, and held props across shots?
9. **Location/set continuity** — does the described environment stay coherent shot to
   shot (time of day, weather, set dressing) unless a transition is intentional?
10. **Transition logic** — is the cut/transition type (hard cut, match cut, dissolve)
    stated and does it make sense for what's being cut together?
11. **Coverage completeness** — does the sequence include the shots needed to cut the
    scene together (establishing, coverage, insert/cutaway) rather than gaps?
12. **Aspect ratio / format consistency** — is the aspect ratio and resolution setting
    consistent across the whole shotlist for the same deliverable?
13. **Genre/tone consistency** — does word choice and camera language stay in the
    established genre register (e.g. a horror scene doesn't drift into sitcom framing)?
14. **Subject prominence** — is the intended subject of each shot clearly the visual
    focus (framing, depth of field, blocking), not incidental?
15. **Platform-field completeness** — does the prompt use all fields the target model
    expects (e.g. MiniMax H3's integrated_multimodal_description / overall_soundscape /
    non_diegetic_music, or Seedance's required prompt structure) — a missing field is a
    FAIL even if the prose reads fine.
