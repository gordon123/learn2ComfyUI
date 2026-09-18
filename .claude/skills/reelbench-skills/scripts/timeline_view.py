#!/usr/bin/env python3
"""Filmstrip + waveform composite PNG for a time range of a video.

One glanceable image instead of a separate frame-grid and a separate audio
chart: N evenly-spaced frames across the top, a waveform ribbon underneath
(rendered by ffmpeg's own showwavespic filter, no numpy/librosa needed), and
a time ruler along the bottom. Optionally overlays word-level labels if a
transcript is supplied (see --transcript).

Dependencies: ffmpeg on PATH, Pillow (`pip install Pillow`). Nothing else.

Usage:
    python3 timeline_view.py INPUT.mp4 --start 0 --end 10 --n-frames 10 --out timeline.png
    python3 timeline_view.py INPUT.mp4 --start 8 --end 12 --transcript words.json --out clash.png

--transcript expects a JSON file: a list of {"start": float, "end": float, "text": str}
word/phrase objects (this is the shape ElevenLabs Scribe, Gemini's transcribe tools, and
most ASR APIs return, or can be trivially mapped to) — entirely optional; the filmstrip
and waveform render fine without it.
"""

import argparse
import json
import subprocess
import sys
import tempfile
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


def run(cmd: list[str]) -> None:
    subprocess.run(cmd, check=True, capture_output=True)


def probe_duration(video: Path) -> float:
    out = subprocess.run(
        ["ffprobe", "-v", "error", "-show_entries", "format=duration",
         "-of", "default=noprint_wrappers=1:nokey=1", str(video)],
        check=True, capture_output=True, text=True,
    )
    return float(out.stdout.strip())


def extract_frames(video: Path, start: float, end: float, n: int, frame_h: int, tmpdir: Path) -> list[Path]:
    paths = []
    span = max(end - start, 0.001)
    for i in range(n):
        t = start + span * (i + 0.5) / n
        dest = tmpdir / f"f{i:03d}.jpg"
        run(["ffmpeg", "-y", "-ss", f"{t:.3f}", "-i", str(video),
             "-frames:v", "1", "-vf", f"scale=-2:{frame_h}",
             "-q:v", "3", str(dest)])
        paths.append(dest)
    return paths


def render_waveform(video: Path, start: float, end: float, width: int, height: int, tmpdir: Path) -> Path:
    dest = tmpdir / "wave.png"
    run(["ffmpeg", "-y", "-ss", f"{start:.3f}", "-t", f"{max(end - start, 0.05):.3f}",
         "-i", str(video),
         "-filter_complex",
         f"[0:a]aformat=channel_layouts=mono,"
         f"showwavespic=s={width}x{height}:colors=0x3a2e3f",
         "-frames:v", "1", str(dest)])
    return dest


def load_font(size: int) -> ImageFont.ImageFont:
    for candidate in (
        "/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf",
        "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
    ):
        if Path(candidate).exists():
            return ImageFont.truetype(candidate, size)
    return ImageFont.load_default()


def main() -> None:
    ap = argparse.ArgumentParser(description="Filmstrip + waveform composite for a video range")
    ap.add_argument("video", type=Path)
    ap.add_argument("--start", type=float, default=0.0)
    ap.add_argument("--end", type=float, default=None)
    ap.add_argument("--n-frames", type=int, default=10)
    ap.add_argument("--frame-h", type=int, default=140)
    ap.add_argument("--wave-h", type=int, default=90)
    ap.add_argument("--transcript", type=Path, default=None,
                     help="optional JSON list of {start,end,text} word/phrase objects")
    ap.add_argument("--out", type=Path, default=Path("timeline.png"))
    args = ap.parse_args()

    if args.end is None:
        args.end = probe_duration(args.video)

    with tempfile.TemporaryDirectory() as tmp:
        tmpdir = Path(tmp)
        frame_paths = extract_frames(args.video, args.start, args.end, args.n_frames, args.frame_h, tmpdir)
        frames = [Image.open(p) for p in frame_paths]
        strip_w = sum(f.width for f in frames)
        wave_path = render_waveform(args.video, args.start, args.end, strip_w, args.wave_h, tmpdir)
        wave = Image.open(wave_path)

        ruler_h = 26
        pad_top = 6
        total_h = pad_top + args.frame_h + args.wave_h + ruler_h + 10
        canvas = Image.new("RGB", (strip_w, total_h), "white")
        draw = ImageDraw.Draw(canvas)
        font = load_font(12)

        cursor = 0
        for f in frames:
            canvas.paste(f, (cursor, pad_top))
            cursor += f.width
        draw.line([(0, pad_top + args.frame_h), (strip_w, pad_top + args.frame_h)], fill="black", width=1)

        wave_y = pad_top + args.frame_h
        canvas.paste(wave, (0, wave_y))

        # Optional word labels ticked above the waveform
        if args.transcript and args.transcript.exists():
            words = json.loads(args.transcript.read_text())
            span = max(args.end - args.start, 0.001)
            for w in words:
                if w["end"] < args.start or w["start"] > args.end:
                    continue
                x = int((max(w["start"], args.start) - args.start) / span * strip_w)
                draw.line([(x, wave_y), (x, wave_y + 6)], fill="red", width=1)
                draw.text((x + 2, wave_y - 12), w["text"][:12], fill="red", font=font)

        # Time ruler
        ruler_y = wave_y + args.wave_h + 4
        draw.line([(0, ruler_y), (strip_w, ruler_y)], fill="black", width=1)
        span = args.end - args.start
        step = 1.0 if span <= 15 else round(span / 10)
        t = args.start
        while t <= args.end + 0.001:
            x = int((t - args.start) / span * strip_w) if span > 0 else 0
            draw.line([(x, ruler_y), (x, ruler_y + 5)], fill="black", width=1)
            draw.text((x + 2, ruler_y + 6), f"{t:.1f}s", fill="black", font=font)
            t += step

        canvas.save(args.out)
        print(f"wrote {args.out} ({canvas.width}x{canvas.height})")


if __name__ == "__main__":
    main()
