"""Build opaque launcher icons from assets/app_icon.png — full art visible, not zoomed."""
from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageFilter

ROOT = Path(r"d:\Projects\Flutter\QRCode-Generator")
SRC = ROOT / "assets" / "app_icon.png"
OUT = ROOT / "assets" / "branding"
STORE = ROOT / "store_assets" / "icons"
# Fallback; real edge color is sampled from the source art.
TEAL = (6, 78, 59, 255)


def crop_alpha(im: Image.Image) -> Image.Image:
    bbox = im.getbbox()
    return im.crop(bbox) if bbox else im


def sample_edge_color(im: Image.Image) -> tuple[int, int, int, int]:
    """Average opaque pixels near the alpha bbox edge for seamless padding."""
    im = im.convert("RGBA")
    w, h = im.size
    px = im.load()
    rs = gs = bs = n = 0
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            if a < 200:
                continue
            # Prefer near-transparent neighbors → true edge of the squircle.
            edge = False
            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                nx, ny = x + dx, y + dy
                if not (0 <= nx < w and 0 <= ny < h) or px[nx, ny][3] < 32:
                    edge = True
                    break
            if edge:
                rs += r
                gs += g
                bs += b
                n += 1
    if n == 0:
        return TEAL
    return (rs // n, gs // n, bs // n, 255)


def flatten(im: Image.Image, bg: tuple[int, int, int, int]) -> Image.Image:
    base = Image.new("RGBA", im.size, bg)
    base.paste(im, (0, 0), im)
    r, g, b, _ = base.split()
    return Image.merge("RGBA", (r, g, b, Image.new("L", im.size, 255)))


def fit_pad(
    im: Image.Image,
    size: int = 1024,
    fill: float = 0.84,
    bg: tuple[int, int, int, int] = TEAL,
) -> Image.Image:
    """Center the full artwork; `fill` = fraction of canvas the art should occupy."""
    art = im.convert("RGBA")
    canvas = Image.new("RGBA", (size, size), bg)
    target = max(1, int(round(size * fill)))
    scale = min(target / art.width, target / art.height)
    nw = max(1, int(round(art.width * scale)))
    nh = max(1, int(round(art.height * scale)))
    scaled = art.resize((nw, nh), Image.Resampling.LANCZOS)
    x = (size - nw) // 2
    y = (size - nh) // 2
    canvas.paste(scaled, (x, y), scaled)
    return flatten(canvas, bg)


def assert_opaque_square(im: Image.Image) -> None:
    assert im.size[0] == im.size[1], im.size
    px = im.load()
    w, h = im.size
    for pt in ((0, 0), (w - 1, 0), (0, h - 1), (w - 1, h - 1), (w // 2, h // 2)):
        r, g, b, a = px[pt]
        assert a == 255, (pt, px[pt])
        assert not (r < 10 and g < 10 and b < 10), (pt, px[pt])


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    STORE.mkdir(parents=True, exist_ok=True)

    raw = Image.open(SRC).convert("RGBA")
    art = crop_alpha(raw)
    bg = sample_edge_color(art)
    print("source", raw.size, "art", art.size, "pad_bg", bg)

    # Legacy + adaptive use the same full composition (no zoom/crop).
    # 0.84 keeps brackets inside Android adaptive safe zone (~66–80%).
    launcher = fit_pad(art, 1024, fill=0.84, bg=bg)
    assert_opaque_square(launcher)

    sharp = launcher.filter(ImageFilter.UnsharpMask(radius=1.0, percent=110, threshold=2))
    sharp = flatten(sharp, bg)

    files = {
        OUT / "app_icon.png": sharp,
        OUT / "app_icon_foreground.png": sharp,
        STORE / "app_icon_1024.png": sharp,
        STORE / "app_icon_512.png": sharp.resize((512, 512), Image.Resampling.LANCZOS),
    }
    for path, img in files.items():
        img.save(path, "PNG", optimize=True)
        print(
            "wrote",
            path.name,
            "corner",
            img.getpixel((0, 0)),
            "center",
            img.getpixel((img.size[0] // 2, img.size[1] // 2)),
        )


if __name__ == "__main__":
    main()
