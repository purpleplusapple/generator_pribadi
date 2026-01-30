import os
import urllib.request
import ssl

# Bypass SSL verification for legacy environments
ssl._create_default_https_context = ssl._create_unverified_context

IDs = [
    "GWe0dlVD9e0", "RNsKphkdBTk", "_-KLkj7on_c", "zjoQRRdff5k",
    "ZPod9V7zB3A", "-UdYbiywGeg", "ULh0i2txBCY", "0sT9YhNgSEs",
    "ONe-snuCaqQ", "eHD8Y1Znfpk", "TKwMsC7aZwA", "bIZJRVBLfOM",
    "1RT4txDDAbM", "Q80LYxv_Tbs", "iJqA68oJxtk", "L__MBAI3ucc",
    "zceI0ftblcM", "u4WFV0pAZpc", "RclD9QITFNI", "0bf868a2d407",
    "7c45262b82b4", "41eaead166d4", "43e0a6382a83", "b212dbd6ee72",
    "f016b77ca51a", "2d2bb372094a", "329426d1aef5", "4d58a73eba1e",
    "6870744d04b2", "57a46cb521d3"
]

# Use a direct photo URL format that might be more permissive or try standard photo page scraping if needed.
# Actually, the "download" endpoint usually requires a key or session.
# Let's try downloading the image preview (w=1080) which is public.
# Format: https://images.unsplash.com/photo-{ID}?w=600&q=80
BASE_URL = "https://images.unsplash.com/photo-{}?w=600&q=80"

TARGET_DIR = "45_Meeting_Room_AI/assets/style_sources"
MANIFEST_FILE = "45_Meeting_Room_AI/assets/ASSET_SOURCES.md"

if not os.path.exists(TARGET_DIR):
    os.makedirs(TARGET_DIR)

manifest_content = "| Filename | Source | License |\n| --- | --- | --- |\n"

print(f"Downloading {len(IDs)} images...")

opener = urllib.request.build_opener()
opener.addheaders = [('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36')]
urllib.request.install_opener(opener)

for i, img_id in enumerate(IDs):
    url = BASE_URL.format(img_id)
    filename = f"source_{i+1:03d}.jpg"
    filepath = os.path.join(TARGET_DIR, filename)

    try:
        print(f"Downloading {img_id} to {filename}...")
        urllib.request.urlretrieve(url, filepath)
        manifest_content += f"| {filename} | https://unsplash.com/photos/{img_id} | Unsplash License |\n"
    except Exception as e:
        print(f"Failed to download {img_id}: {e}")

with open(MANIFEST_FILE, "w") as f:
    f.write("# Asset Sources\n\n" + manifest_content)

print("Download complete.")
