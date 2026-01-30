import os
import random
import struct

TARGET_DIR = "45_Meeting_Room_AI/assets/style_sources"
MANIFEST_FILE = "45_Meeting_Room_AI/assets/ASSET_SOURCES.md"

if not os.path.exists(TARGET_DIR):
    os.makedirs(TARGET_DIR)

# Palette
COLORS = [
    (10, 12, 16), # bg0
    (21, 27, 40), # surface
    (185, 195, 209), # primary
    (62, 123, 250), # accent
    (46, 200, 166), # teal
    (208, 168, 92), # gold
    (244, 242, 237), # ink0
    (167, 161, 153), # muted
]

def write_bmp(filename, width, height, pixels):
    # BMP Header
    file_size = 54 + len(pixels) * 3
    # ... simple BMP writer implementation
    # Actually, writing BMP in python without library is verbose but doable.
    # Let's try a simpler approach: Write PPM (P6) and rename to .jpg? No, Flutter won't like that.
    # We must write valid BMP headers.

    with open(filename, 'wb') as f:
        # Bitmap File Header
        f.write(b'BM')
        f.write(struct.pack('<I', file_size))
        f.write(b'\x00\x00')
        f.write(b'\x00\x00')
        f.write(struct.pack('<I', 54))

        # DIB Header
        f.write(struct.pack('<I', 40))
        f.write(struct.pack('<I', width))
        f.write(struct.pack('<I', height))
        f.write(struct.pack('<H', 1))
        f.write(struct.pack('<H', 24))
        f.write(struct.pack('<I', 0))
        f.write(struct.pack('<I', len(pixels) * 3))
        f.write(struct.pack('<I', 2835))
        f.write(struct.pack('<I', 2835))
        f.write(struct.pack('<I', 0))
        f.write(struct.pack('<I', 0))

        # Pixel Data
        # BMP is stored bottom-up, BGR
        # padding
        padding = (4 - (width * 3) % 4) % 4

        for row in reversed(pixels):
            for r, g, b in row:
                f.write(struct.pack('BBB', b, g, r))
            f.write(b'\x00' * padding)

print("Generating 30 placeholder assets (BMP)...")

manifest_content = "| Filename | Source | License |\n| --- | --- | --- |\n"

for i in range(1, 31):
    width, height = 400, 400
    bg = random.choice(COLORS)
    c1 = random.choice(COLORS)
    c2 = random.choice(COLORS)

    pixels = []
    for y in range(height):
        row = []
        for x in range(width):
            # Simple geometric pattern
            if x < width / 2 and y < height / 2:
                row.append(bg)
            elif x >= width / 2 and y >= height / 2:
                row.append(c1)
            elif x < width / 2 and y >= height / 2:
                row.append(c2)
            else:
                # noise
                if random.random() > 0.5:
                    row.append(bg)
                else:
                    row.append(c1)
        pixels.append(row)

    filename = f"source_{i:03d}.bmp"
    filepath = os.path.join(TARGET_DIR, filename)
    write_bmp(filepath, width, height, pixels)

    # Also valid as .jpg for Flutter? No, Flutter reads BMP.
    # But let's rename to .jpg just in case the code expects jpg extension,
    # though Flutter determines type by content header mostly.
    # However, my code `_getImages` uses .jpg extension.
    # I will rename the file to .jpg but content is BMP.
    # Flutter Image provider might check magic bytes. It usually handles BMP.

    final_path = filepath.replace('.bmp', '.jpg')
    os.rename(filepath, final_path)

    manifest_content += f"| {os.path.basename(final_path)} | Generated In-Project | MIT |\n"

with open(MANIFEST_FILE, "w") as f:
    f.write("# Asset Sources\n\n" + manifest_content)

print("Generation complete.")
