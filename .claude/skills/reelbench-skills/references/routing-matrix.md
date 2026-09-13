# Routing Matrix

Resolve ambiguity only — if the user already named a skill, use it and skip this table.

| Situation | Route to |
|---|---|
| Full script/scene breakdown → shotlist with Seedance prompts | `seedance-shotlist-director` |
| Single scene/shot, from scratch, no source footage, target = Seedance | `seedance-director` or `seedance-clean` (clean = simpler single standalone prompt; director = fuller cinematic breakdown) |
| User has an existing clip and wants a VFX/environment transform applied to it, target = Seedance | `seedance-footage-vfx` |
| Full script/song → shotlist with MiniMax H3 prompts (needs audio/soundscape fields) | `minimax-h3-shotlist-director` |
| Single scene/shot, from scratch, target = MiniMax H3 (T2VA/I2VA/FL2VA/L2VA/Ref2VA) | `minimax-h3-prompt-writing` |
| Song with lyrics needing a Creative Brief before any shot is written | run `mv-storytelling-framework` first, then route per above |
| Ad/commercial needing a hook + caption/VFX/SFX plan before the prompt | run `ad-clip-director` first, then route per above |
| Reference photos + need a full production board (floor plan, camera positions) rather than a plain shotlist | `storyboard-board` |

## Deciding MiniMax H3 vs Seedance when the user hasn't said

- Needs synchronized dialogue, diegetic sound, or music baked into the generation →
  MiniMax H3 (it's the omni-modal video+audio model).
- Silent/visual-only cinematic footage, or a footage-to-footage VFX transform → Seedance.
- If genuinely unclear, ask the user rather than guessing — the two families produce
  incompatible prompt structures and picking wrong wastes a full prompt-writing pass.
