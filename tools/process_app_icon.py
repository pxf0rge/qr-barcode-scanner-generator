from PIL import Image
from collections import deque
import os

sources = {
    "from_client": r"C:\Users\Administrator\.cursor\projects\d-Projects-Flutter-QRCode-Generator\assets\c__Users_Administrator_AppData_Roaming_Cursor_User_workspaceStorage_a9935b6f9855a60e9bb2cae7d08e6410_images_IMG-20260927-WA0088-3221bf9d-49a8-4004-90c3-09f11fb48736.png",
    "generated": r"C:\Users\Administrator\.cursor\projects\d-Projects-Flutter-QRCode-Generator\assets\vectorqr_icon_gen.png",
}

out_dir = r"d:\Projects\Flutter\QRCode-Generator\assets\branding"
store_dir = r"d:\Projects\Flutter\QRCode-Generator\store_assets\icons"
os.makedirs(out_dir, exist_ok=True)
os.makedirs(store_dir, exist_ok=True)


def is_bg(r, g, b, a, threshold=242):
    if a < 30:
        return True
    # Near-white / light gray canvas
    return r >= threshold and g >= threshold and b >= threshold


def remove_white_bg(im: Image.Image) -> Image.Image:
    im = im.convert("RGBA")
    w, h = im.size
    pixels = im.load()
    visited = [[False] * w for _ in range(h)]
    q = deque()

    # Seed flood fill from edges
    edge = []
    for x in range(w):
        edge.append((x, 0))
        edge.append((x, h - 1))
    for y in range(h):
        edge.append((0, y))
        edge.append((w - 1, y))

    for x, y in edge:
        r, g, b, a = pixels[x, y]
        if is_bg(r, g, b, a) and not visited[y][x]:
            visited[y][x] = True
            q.append((x, y))

    dirs = [(1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (1, -1), (-1, 1), (-1, -1)]
    while q:
        x, y = q.popleft()
        pixels[x, y] = (0, 0, 0, 0)
        for dx, dy in dirs:
            nx, ny = x + dx, y + dy
            if 0 <= nx < w and 0 <= ny < h and not visited[ny][nx]:
                rr, gg, bb, aa = pixels[nx, ny]
                # Slightly softer threshold for fringe
                if is_bg(rr, gg, bb, aa, threshold=235):
                    visited[ny][nx] = True
                    q.append((nx, ny))

    # Soften remaining near-white fringe adjacent to transparency
    for y in range(h):
        for x in range(w):
            r, g, b, a = pixels[x, y]
            if a == 0:
                continue
            if r >= 220 and g >= 220 and b >= 220:
                # Check if neighbor is transparent → fringe
                near_t = False
                for dx, dy in dirs:
                    nx, ny = x + dx, y + dy
                    if 0 <= nx < w and 0 <= ny < h and pixels[nx, ny][3] == 0:
                        near_t = True
                        break
                if near_t or (r + g + b) / 3 >= 245:
                    whiteness = (r + g + b) / 3
                    new_a = int(max(0, min(255, (255 - whiteness) * 10)))
                    pixels[x, y] = (0, 0, 0, 0) if new_a < 50 else (r, g, b, new_a)

    return im


def to_square_icon(im: Image.Image, size=1024) -> Image.Image:
    bbox = im.getbbox()
    if bbox:
        pad = max(4, int(min(im.size) * 0.015))
        l, t, r, b = bbox
        l = max(0, l - pad)
        t = max(0, t - pad)
        r = min(im.size[0], r + pad)
        b = min(im.size[1], b + pad)
        im = im.crop((l, t, r, b))

    side = max(im.size)
    canvas = Image.new("RGBA", (side, side), (0, 0, 0, 0))
    ox = (side - im.size[0]) // 2
    oy = (side - im.size[1]) // 2
    canvas.paste(im, (ox, oy), im)
    return canvas.resize((size, size), Image.Resampling.LANCZOS)


def adaptive_foreground(master: Image.Image, content=720) -> Image.Image:
    fg = Image.new("RGBA", (1024, 1024), (0, 0, 0, 0))
    inset = master.resize((content, content), Image.Resampling.LANCZOS)
    fg.paste(inset, ((1024 - content) // 2, (1024 - content) // 2), inset)
    return fg


# Prefer exact client artwork (closest match), also keep generated variant.
processed = {}
for name, path in sources.items():
    if not os.path.exists(path):
        print("missing", name, path)
        continue
    raw = Image.open(path)
    print(name, "in", raw.size, raw.mode, "corners", [raw.convert("RGBA").getpixel(p) for p in [(0, 0), (raw.size[0] - 1, 0)]])
    clean = to_square_icon(remove_white_bg(raw), 1024)
    processed[name] = clean
    a0 = clean.getpixel((0, 0))[3]
    print(name, "out corner alpha", a0, "center", clean.getpixel((512, 512)))

# Primary = client source (closest to requested look)
primary = processed.get("from_client") or processed["generated"]
fg = adaptive_foreground(primary, 760)

paths = {
    os.path.join(out_dir, "app_icon.png"): primary,
    os.path.join(out_dir, "app_icon_foreground.png"): fg,
    os.path.join(store_dir, "app_icon_1024.png"): primary,
    os.path.join(store_dir, "app_icon_512.png"): primary.resize((512, 512), Image.Resampling.LANCZOS),
}
if "generated" in processed:
    paths[os.path.join(out_dir, "app_icon_generated.png")] = processed["generated"]

for p, img in paths.items():
    img.save(p, "PNG")
    print("wrote", p)
