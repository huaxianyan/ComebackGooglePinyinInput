#!/usr/bin/env python3
"""Generate the pinyin subtype icon from a CJK font glyph.

Android 17 renders each input method's subtype icon as a small monochrome mark
in the input method switcher. Pointing that at the full-colour app icon makes
it collapse into an unreadable block, so the subtype points at a single glyph
instead, the way Gboard does it (「あ」 for Japanese, 「拼」 for Chinese).

Run this only when the glyph needs to change. It needs fontTools and a CJK
font; the font is not vendored because it is large and platform-supplied:

    python scripts/generate_pinyin_subtype_icon.py path/to/NotoSansCJK-Regular.ttc

The default font path is the one pulled from a device's /system/fonts.
"""

from __future__ import annotations

import argparse
from pathlib import Path

from fontTools.misc.transform import Transform
from fontTools.pens.boundsPen import BoundsPen
from fontTools.pens.svgPathPen import SVGPathPen
from fontTools.pens.transformPen import TransformPen
from fontTools.ttLib import TTCollection

ROOT = Path(__file__).resolve().parent.parent
DEFAULT_FONT = ROOT / "work/NotoSansCJK-Regular.ttc"
DEFAULT_OUTPUT = ROOT / "patches/res/drawable/ic_ime_subtype_pinyin.xml"
CHARACTER = "拼"
VIEWPORT = 24.0
PADDING = 2.0


def pick_simplified_chinese(collection: TTCollection):
    for font in collection.fonts:
        if "SC" in (font["name"].getDebugName(4) or ""):
            return font
    raise SystemExit("no Simplified Chinese subfont found in the collection")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("font", type=Path, nargs="?", default=DEFAULT_FONT)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()

    if not args.font.is_file():
        raise SystemExit(f"font not found: {args.font}")

    font = pick_simplified_chinese(TTCollection(str(args.font)))
    glyph_set = font.getGlyphSet()
    glyph_name = font.getBestCmap()[ord(CHARACTER)]

    bounds_pen = BoundsPen(glyph_set)
    glyph_set[glyph_name].draw(bounds_pen)
    x_min, y_min, x_max, y_max = bounds_pen.bounds

    box = VIEWPORT - 2 * PADDING
    scale = min(box / (x_max - x_min), box / (y_max - y_min))
    width = scale * (x_max - x_min)
    height = scale * (y_max - y_min)

    # Android vector space is y-down while font space is y-up, so y takes a
    # negative scale and the translate re-anchors the glyph box into the
    # viewport with even padding on all sides.
    transform = Transform(
        scale,
        0.0,
        0.0,
        -scale,
        (VIEWPORT - width) / 2 - scale * x_min,
        (VIEWPORT - height) / 2 + scale * y_max,
    )

    pen = SVGPathPen(glyph_set, ntos=lambda value: f"{value:.3f}")
    glyph_set[glyph_name].draw(TransformPen(pen, transform))

    drawable = (
        '<?xml version="1.0" encoding="utf-8"?>\n'
        '<vector xmlns:android="http://schemas.android.com/apk/res/android"\n'
        '    android:width="24dp"\n'
        '    android:height="24dp"\n'
        f'    android:viewportWidth="{VIEWPORT:g}"\n'
        f'    android:viewportHeight="{VIEWPORT:g}">\n'
        "    <!--\n"
        f"        The {CHARACTER} glyph from {font['name'].getDebugName(4)}. Android 17\n"
        "        renders each input method's subtype icon as a small monochrome\n"
        "        mark, so pointing at the full-colour app icon only produced a\n"
        "        block. Black on purpose: the system tints subtype icons itself.\n"
        "    -->\n"
        "    <path\n"
        '        android:fillColor="#FF000000"\n'
        f'        android:pathData="{pen.getCommands()}" />\n'
        "</vector>\n"
    )

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(drawable, encoding="utf-8", newline="\n")
    print(f"wrote {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
