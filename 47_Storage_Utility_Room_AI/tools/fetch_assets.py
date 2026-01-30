import os
import urllib.request
import datetime

# Configuration
BASE_DIR = "47_Storage_Utility_Room_AI"
ASSETS_DIR = os.path.join(BASE_DIR, "assets")
MANIFEST_FILE = os.path.join(ASSETS_DIR, "ASSET_SOURCES.md")

# Unsplash Source IDs (High quality utility/storage/interior)
# We map target filenames to Unsplash LONG IDs
IMAGE_MAP = {
    # Examples (Dashboard)
    "examples/ex_01.jpg": "1676320514014-f76904adeace",
    "examples/ex_02.jpg": "1626806819282-2c1dc01a5e0c",
    "examples/ex_03.jpg": "1626806787461-102c1bfaaea1",
    "examples/ex_04.jpg": "1682888818612-1c18ebecf3ec",
    "examples/ex_05.jpg": "1688302740525-021cd48a1c2f",
    "examples/ex_06.jpg": "1681487158724-443dc1f2c2c7",
    "examples/ex_07.jpg": "1701421048900-e0adbde9b90c",
    "examples/ex_08.jpg": "1646592474094-342fbc28736c",
    "examples/ex_09.jpg": "1649805418927-643004a0afe6",
    "examples/ex_10.jpg": "1604335398980-ededcadcc37d",
    "examples/ex_11.jpg": "1632923565835-6582b54f2105",
    "examples/ex_12.jpg": "1638949493140-edb10b7be2f3",

    # Style Tiles (Textures/Details for Moodboards)
    "style_tiles/tile_wood.jpg": "1625479761344-dacc79d7d4bc",
    "style_tiles/tile_metal.jpg": "1657064575960-efefbe831c2e",
    "style_tiles/tile_white.jpg": "1626806787461-102c1bfaaea1", # Reusing
    "style_tiles/tile_concrete.jpg": "1683134216649-0f37150de33e",
    "style_tiles/tile_basket.jpg": "1625479761344-dacc79d7d4bc", # reusing texture
    "style_tiles/tile_shelf.jpg": "1682888818612-1c18ebecf3ec",

    # Onboarding
    "onboarding/guide_good.jpg": "1676320514014-f76904adeace",
    "onboarding/guide_bad.jpg": "1688302740525-021cd48a1c2f", # Dark/small
    "onboarding/framing.jpg": "1626806819282-2c1dc01a5e0c",

    # Illustrations (Empty states - using abstract photos)
    "illustrations/empty_history.jpg": "1681487158724-443dc1f2c2c7",
    "illustrations/empty_favorites.jpg": "1625479761344-dacc79d7d4bc",
}

# For Style Moodboards, we will just copy some examples to act as placeholders
# The real app will build 2x2 grids from tiles/examples
MOODBOARD_PLACEHOLDERS = [
    "style_moodboards/style_01.jpg",
    "style_moodboards/style_02.jpg",
    "style_moodboards/style_03.jpg",
    "style_moodboards/style_04.jpg",
    "style_moodboards/style_05.jpg",
]

def download_file(url, filepath):
    try:
        print(f"Downloading {url} to {filepath}...")
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req) as response:
            with open(filepath, 'wb') as out_file:
                out_file.write(response.read())
        return True
    except Exception as e:
        print(f"Error downloading {url}: {e}")
        return False

def main():
    manifest_lines = [
        "# Asset Sources and Licenses",
        "",
        "All images downloaded from Unsplash (Royalty Free).",
        "",
        "| Filename | Source URL | Date Downloaded | License |",
        "|---|---|---|---|"
    ]

    for rel_path, unsplash_id in IMAGE_MAP.items():
        # Using the direct photo-ID url structure
        url = f"https://images.unsplash.com/photo-{unsplash_id}?auto=format&fit=crop&w=800&q=80"
        filepath = os.path.join(ASSETS_DIR, rel_path)

        # Ensure dir exists
        os.makedirs(os.path.dirname(filepath), exist_ok=True)

        if download_file(url, filepath):
            date_str = datetime.date.today().isoformat()
            manifest_lines.append(f"| `{rel_path}` | `https://unsplash.com/photos/{unsplash_id}` | {date_str} | Unsplash License (Free) |")

    # Handle moodboard placeholders (copying existing)
    if os.path.exists(os.path.join(ASSETS_DIR, "examples/ex_01.jpg")):
        src = os.path.join(ASSETS_DIR, "examples/ex_01.jpg")
        for mb in MOODBOARD_PLACEHOLDERS:
             dst = os.path.join(ASSETS_DIR, mb)
             # Copy file
             with open(src, 'rb') as fsrc:
                 content = fsrc.read()
                 with open(dst, 'wb') as fdst:
                     fdst.write(content)
             manifest_lines.append(f"| `{mb}` | Derived from `examples/ex_01.jpg` | - | - |")

    # Write manifest
    with open(MANIFEST_FILE, "w") as f:
        f.write("\n".join(manifest_lines))

    print("Asset acquisition complete.")

if __name__ == "__main__":
    main()
