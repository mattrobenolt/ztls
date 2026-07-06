#!/usr/bin/env python3
"""Generate the ztls wordmark as SVG with glyphs converted to vector paths.

Text is laid out from a monospace font (JetBrains Mono) and emitted as filled
paths, so the SVG renders identically without the font installed. Run via
`just brand-wordmark` inside the `.#brand` dev shell, which supplies
ZTLS_BRAND_FONT_DIR.
"""

from __future__ import annotations

import os
import sys
from pathlib import Path

from fontTools.pens.svgPathPen import SVGPathPen
from fontTools.ttLib import TTFont

OUT_DIR = Path("images/logo")

TITLE = ".ztls"
TAGLINE = "Sans-I/O TLS 1.3 in Zig"

TITLE_PT = 200.0
TAG_PT = 52.0

MARGIN_X = 44.0
MARGIN_TOP = 40.0
MARGIN_BOTTOM = 40.0
LINE_GAP = 44.0

THEMES = {
    "": {"title": "#16181d", "tag": "#5b606b"},
    "-dark": {"title": "#f2f0ea", "tag": "#9aa0ab"},
}


def font_file(name: str) -> Path:
    root = os.environ.get("ZTLS_BRAND_FONT_DIR")
    if not root:
        sys.exit("ZTLS_BRAND_FONT_DIR is unset; run inside `nix develop .#brand`")
    matches = list(Path(root).rglob(name))
    if not matches:
        sys.exit(f"font {name} not found under {root}")
    return matches[0]


class Line:
    def __init__(self, text: str, font_path: Path, pt: float):
        self.font = TTFont(font_path)
        self.upm = self.font["head"].unitsPerEm
        self.scale = pt / self.upm
        self.glyphs = self.font.getGlyphSet()
        self.cmap = self.font.getBestCmap()
        hhea = self.font["hhea"]
        self.ascent = hhea.ascent * self.scale
        self.descent = hhea.descent * self.scale  # negative
        self.text = text

    def path_and_width(self) -> tuple[str, float]:
        """Return (svg path data in font units, advance width in font units)."""
        parts: list[str] = []
        x = 0.0
        for ch in self.text:
            gname = self.cmap.get(ord(ch))
            if gname is None:
                sys.exit(f"glyph missing for {ch!r}")
            glyph = self.glyphs[gname]
            pen = SVGPathPen(self.glyphs)
            glyph.draw(pen)
            d = pen.getCommands()
            if d:
                parts.append(f'<path transform="translate({x:.2f} 0)" d="{d}"/>')
            x += glyph.width
        return "\n      ".join(parts), x


def group(line: Line, origin_x: float, baseline_y: float, color: str) -> str:
    inner, _ = line.path_and_width()
    # Flip Y (font up -> SVG down) and scale font units to px at the baseline.
    return (
        f'  <g fill="{color}" '
        f'transform="translate({origin_x:.2f} {baseline_y:.2f}) '
        f'scale({line.scale:.5f} {-line.scale:.5f})">\n'
        f"      {inner}\n"
        f"  </g>"
    )


def main() -> None:
    title_font = font_file("JetBrainsMono-Medium.ttf")
    tag_font = font_file("JetBrainsMono-Regular.ttf")

    title = Line(TITLE, title_font, TITLE_PT)
    tag = Line(TAGLINE, tag_font, TAG_PT)

    _, title_units = title.path_and_width()
    _, tag_units = tag.path_and_width()
    title_w = title_units * title.scale
    tag_w = tag_units * tag.scale

    title_baseline = MARGIN_TOP + title.ascent
    tag_baseline = title_baseline - title.descent + LINE_GAP + tag.ascent
    height = tag_baseline - tag.descent + MARGIN_BOTTOM
    width = MARGIN_X * 2 + max(title_w, tag_w)

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    for suffix, colors in THEMES.items():
        body = "\n".join(
            [
                group(title, MARGIN_X, title_baseline, colors["title"]),
                group(tag, MARGIN_X, tag_baseline, colors["tag"]),
            ]
        )
        svg = (
            f'<svg xmlns="http://www.w3.org/2000/svg" '
            f'viewBox="0 0 {width:.0f} {height:.0f}" '
            f'width="{width:.0f}" height="{height:.0f}" '
            f'role="img" aria-label="ztls — Sans-I/O TLS 1.3 in Zig">\n'
            f"{body}\n"
            f"</svg>\n"
        )
        out = OUT_DIR / f"wordmark{suffix}.svg"
        out.write_text(svg)
        print(f"wrote {out} ({width:.0f}x{height:.0f})")


if __name__ == "__main__":
    main()
