#!/usr/bin/env python3
"""
Regenerate macOS AppIcon PNGs from a square master, or fall back to vector ring art.

Place `app_icon_source_master.png` (ideally 1024×1024) in:
  app/tooling/

To adopt a new design: replace that file, then run:
  python3 app/tooling/generate_macos_app_icon.py
"""
from __future__ import annotations

import math
import sys
from pathlib import Path

from PIL import Image, ImageDraw

MASTER = 1024
SIZES = (16, 32, 64, 128, 256, 512, 1024)

# Fallback ring (matches app_ui) — only used if no source master exists
BG = (19, 19, 29)
GRAY = (90, 95, 110)
TEAL = (45, 212, 191)
_BASE_R = 330
_BASE_STROKE = 28
_BASE_DOT = 22


def draw_vector_master(size: int) -> Image.Image:
    img = Image.new("RGB", (size, size), BG)
    d = ImageDraw.Draw(img)
    cx = cy = size // 2
    scale = size / MASTER
    r = max(4, int(_BASE_R * scale))
    stroke = max(2, int(_BASE_STROKE * scale))
    dot_r = max(2, int(_BASE_DOT * scale))
    bbox = (cx - r, cy - r, cx + r, cy + r)
    d.arc(bbox, start=0, end=360, fill=GRAY, width=stroke)
    d.arc(bbox, start=270, end=360, fill=TEAL, width=stroke)
    dot_x = cx + int(r * math.cos(0.0))
    dot_y = cy + int(r * math.sin(0.0))
    d.ellipse(
        (dot_x - dot_r, dot_y - dot_r, dot_x + dot_r, dot_y + dot_r),
        fill=TEAL,
    )
    return img


def load_source_master(path: Path) -> Image.Image:
    img = Image.open(path).convert("RGBA")
    w, h = img.size
    side = min(w, h)
    left = (w - side) // 2
    top = (h - side) // 2
    img = img.crop((left, top, left + side, top + side))
    img = img.resize((MASTER, MASTER), Image.Resampling.LANCZOS)
    if img.mode == "RGBA":
        bg = Image.new("RGB", (MASTER, MASTER), (19, 19, 29))
        bg.paste(img, mask=img.split()[3])
        return bg
    return img.convert("RGB")


def main() -> int:
    root = Path(__file__).resolve().parents[1]
    appicon = root / "macos/Runner/Assets.xcassets/AppIcon.appiconset"
    if not appicon.is_dir():
        print(f"Missing {appicon}", file=sys.stderr)
        return 1

    source = root / "tooling" / "app_icon_source_master.png"
    if source.is_file():
        base = load_source_master(source)
        print(f"Using source: {source}", file=sys.stderr)
    else:
        base = draw_vector_master(MASTER)
        print("No app_icon_source_master.png; using built-in ring art.", file=sys.stderr)

    for w in SIZES:
        img = base if w == MASTER else base.resize((w, w), Image.Resampling.LANCZOS)
        out = appicon / f"app_icon_{w}.png"
        img.save(out, "PNG", optimize=True)
        print(out)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
