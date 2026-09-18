# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

A personal knowledge base and workflow library for learning ComfyUI (Stable Diffusion / Flux /
WAN / image, video, audio, 3D generation), maintained in Thai by the author of the
[@iimate2485](https://www.youtube.com/@iimate2485) YouTube channel. It is **not a software
project** — there is no package.json, build step, linter, or test suite. Content is Markdown
docs, ComfyUI workflow `.json`/`.png` files, install shell scripts, and Jupyter notebooks.
Treat changes here as documentation/content edits, not code changes: there is nothing to "build"
or "run" in the traditional sense, only scripts meant to be copy-pasted or executed on a RunPod
GPU instance.

## Repository structure

| Path | Purpose |
|---|---|
| `docs/` | Thai-language lesson articles (`thai-NN-*.md`), indexed from `docs/00-index.md` in recommended reading order. Each lesson corresponds to a YouTube video. |
| `workflows/` | ComfyUI workflow files (`.json`) grouped by technique/model (e.g. `WAN/`, `Flux-Klein-WF/`, `z-image/`, `Qwen-Image-Edit-2509-StoryBoard/`), each with its own `readme.md` and reference screenshots/PNGs sitting alongside the JSON. |
| `file script/` | Install/setup scripts (`.sh`) and Jupyter notebooks (`.ipynb`) for provisioning a RunPod GPU instance — installing ComfyUI, CUDA/attention backends, downloading models/LoRAs. |
| `text2image_stuff/`, `text2video_stuff/`, `text2audio_stuff/`, `text2ThreeD_stuff/` | Prompt notes and technique write-ups organized by generation modality; some subfolders are placeholders ("SOON"). |
| `image/`, `references-research-ai-paper/` | Supporting images and AI paper reference notes. |
| `video-library/` | Growing personal collection of reference video clips (see its own `README.md`) — each entry under `video-library/<slug>/notes.md` records techniques observed in the clip vs. techniques worth adding, consumed by the `personal-video-library` skill. |
| `.claude/skills/` | Project-specific Claude Code skills (see below). |

Within `workflows/` and the `*_stuff/` folders, each subfolder is self-contained: a `readme.md`
(or `note`) plus the workflow JSON and any reference images it needs. When adding a new workflow
or technique writeup, follow this same pattern rather than a flat file dump.

## Claude Code skills in this repo

- **`reelbench-skills`** — cinematic-continuity coach/router for AI video prompt writing
  (MiniMax H3, Seedance families). Learns shot grammar from reference footage via
  ffprobe/ffmpeg, builds a Continuity & Style Brief + narrative-rhythm map + camera-emotion
  read, routes to the matching downstream prompt-writing skill, then QAs the output against a
  15-point checklist. See `.claude/skills/reelbench-skills/SKILL.md` for the full workflow and
  `examples/` for past prompt/report case studies.
- **`melies-cinematic-library`** — a local mirror of 424 named cinematic techniques (camera
  angles, movement, lighting, color, effects, etc.) with ready-to-adapt prompt fragments. Use to
  name a specific technique instead of a vague adjective when writing any video/image prompt.
- **`personal-video-library`** — coordinates the other three: when the user hands over a
  reference clip and wants a prompt built from it, this skill runs `story-wizard` first (if
  there's story stakes), forces `reelbench-skills`' footage analysis plus 2-3 deliberately
  *added* techniques from `melies-cinematic-library` (never a literal copy of the reference),
  then logs the result into `video-library/`.
- **`story-wizard`** — Phase-0 story reasoning layer, upstream of all three above: reads what a
  reference clip actually shows, then asks the user directly what the character should do, how
  it's presented, the story arc, the hook, and the ending, before any technical footage analysis
  or prompt writing starts.
- **`thai-songwriter-assistant`** — human-in-the-loop Thai lyric writer (แต่งเพลงไทย): works
  section-by-section (one guiding question at a time), covers Song Form, สัมผัส (rhyme), วรรค
  pacing, and Thai tone-vs-melody matching, then outputs a Suno-AI-ready lyric with meta tags.
  See `.claude/skills/thai-songwriter-assistant/SKILL.md` and its `references/` (songwriting
  craft, prosody-and-tone, melody-matching, suno-prompting, learned-additions). Pairs with
  `text2audio_stuff/music-style-library/readme.md` for genre keywords when picking a Suno style.

Read the actual `SKILL.md` files before writing or revising an AI video/image generation prompt
in this repo — the craft rules (H3/Seedance field syntax, duration handling, continuity rules)
live there, not in this file.

## Working in this repo

- Docs and workflow readmes are written in Thai; match that language and tone when editing
  existing Thai content.
- A `readme.md` next to a workflow JSON documents what that workflow does and links the source
  YouTube video — update it in the same change if you add or modify a workflow file.
- There is no CI, linter, or test command to run before committing.
