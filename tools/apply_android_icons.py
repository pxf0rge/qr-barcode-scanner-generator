"""Apply branding/app_icon.png into Android ic_vectorqr mipmaps/drawables."""
from __future__ import annotations

from pathlib import Path

from PIL import Image

ROOT = Path(r"d:\Projects\Flutter\QRCode-Generator")
SRC = ROOT / "assets" / "branding" / "app_icon.png"
RES = ROOT / "android" / "app" / "src" / "main" / "res"

LEGACY = {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}
ADAPTIVE = {"mdpi": 108, "hdpi": 162, "xhdpi": 216, "xxhdpi": 324, "xxxhdpi": 432}

ADAPTIVE_XML = """<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
  <background android:drawable="@drawable/ic_vectorqr_background"/>
  <foreground>
      <inset
          android:drawable="@drawable/ic_vectorqr_foreground"
          android:inset="0%" />
  </foreground>
</adaptive-icon>
"""


def main() -> None:
    src = Image.open(SRC).convert("RGBA")
    for dens, size in LEGACY.items():
        d = RES / f"mipmap-{dens}"
        d.mkdir(parents=True, exist_ok=True)
        img = src.resize((size, size), Image.Resampling.LANCZOS)
        img.save(d / "ic_vectorqr.png", "PNG", optimize=True)
        img.save(d / "ic_vectorqr_round.png", "PNG", optimize=True)
        print("mipmap", dens, size)

    for dens, size in ADAPTIVE.items():
        d = RES / f"drawable-{dens}"
        d.mkdir(parents=True, exist_ok=True)
        img = src.resize((size, size), Image.Resampling.LANCZOS)
        img.save(d / "ic_vectorqr_foreground.png", "PNG", optimize=True)
        img.save(d / "ic_vectorqr_background.png", "PNG", optimize=True)
        print("drawable", dens, size)

    anydpi = RES / "mipmap-anydpi-v26"
    anydpi.mkdir(parents=True, exist_ok=True)
    (anydpi / "ic_vectorqr.xml").write_text(ADAPTIVE_XML, encoding="utf-8")
    (anydpi / "ic_vectorqr_round.xml").write_text(ADAPTIVE_XML, encoding="utf-8")
    print("xml ok")


if __name__ == "__main__":
    main()
