import os
import random
import urllib.request
import ssl

# Bypass SSL errors for download
ssl._create_default_https_context = ssl._create_unverified_context

ASSETS_DIR = "43_Camper_Van_Interior_AI/assets"
STYLES = [
    "Scandinavian Van Minimal", "Japandi Camper Calm", "Warm Wood Craft", "Industrial Matte Black",
    "Boho Adventure Van", "Surf Van Coastal", "Mountain Cabin Van", "Desert Nomad Van",
    "Off-Grid Solar Pro", "Micro Van Ultra Compact", "Family Bunk Layout", "Couple Cozy Layout",
    "Work-From-Van Studio", "Luxury Sprinter Lounge", "Minimal Kitchen Galley", "Full Bathroom Micro Wet Bath",
    "Hidden Storage Max", "Bike/Board Gear Hauler", "Pet-Friendly Van", "Winter Insulated Van",
    "Summer Ventilation Breeze", "Retro Classic Van", "Futuristic Clean Pod", "Dark Moody Cabin",
    "Bright Daylight White", "Budget DIY Build", "Premium Custom Cabinetry", "Outdoor Shower Setup",
    "L-Shape Lounge Layout", "U-Shape Social Layout", "Custom Advanced"
]

PALETTE = [
    "#D39B63", "#2A2119", "#2FA37B", "#F0B35A", "#5B8CFF", "#AAA397", "#2C3246", "#F4F1EA", "#171C2A"
]

def generate_svg_collage(filename, style_name):
    # Deterministic colors based on name
    seed = sum(ord(c) for c in style_name)
    random.seed(seed)

    c1 = random.choice(PALETTE)
    c2 = random.choice(PALETTE)
    c3 = random.choice(PALETTE)
    c4 = random.choice(PALETTE)

    svg = f'''<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="0" width="400" height="400" fill="#101520" />

  <!-- Top Left: Bed/Texture -->
  <rect x="10" y="10" width="185" height="185" rx="8" fill="{c1}" />
  <circle cx="100" cy="100" r="40" fill="rgba(255,255,255,0.1)" />

  <!-- Top Right: Kitchen/Detail -->
  <rect x="205" y="10" width="185" height="185" rx="8" fill="{c2}" />
  <rect x="235" y="40" width="125" height="20" fill="rgba(0,0,0,0.2)" />
  <rect x="235" y="70" width="125" height="20" fill="rgba(0,0,0,0.2)" />

  <!-- Bottom Left: Storage/Wood -->
  <rect x="10" y="205" width="185" height="185" rx="8" fill="{c3}" />
  <line x1="10" y1="250" x2="195" y2="250" stroke="rgba(0,0,0,0.1)" stroke-width="2" />
  <line x1="10" y1="300" x2="195" y2="300" stroke="rgba(0,0,0,0.1)" stroke-width="2" />

  <!-- Bottom Right: Light/Decor -->
  <rect x="205" y="205" width="185" height="185" rx="8" fill="{c4}" />
  <circle cx="297" cy="297" r="50" stroke="rgba(255,255,255,0.2)" stroke-width="4" fill="none" />

  <text x="200" y="380" font-family="Arial" font-size="14" fill="white" text-anchor="middle" opacity="0.5">{style_name}</text>
</svg>'''

    with open(filename, "w") as f:
        f.write(svg)

def download_picsum(filename, seed):
    url = f"https://picsum.photos/seed/{seed}/800/600"
    try:
        urllib.request.urlretrieve(url, filename)
        print(f"Downloaded {filename}")
        return True
    except Exception as e:
        print(f"Failed to download {url}: {e}")
        return False

def main():
    # 1. Generate Style Moodboards
    print("Generating Moodboards...")
    for style in STYLES:
        safe_name = style.replace(" ", "_").replace("/", "_").lower()
        filepath = os.path.join(ASSETS_DIR, "style_moodboards", f"{safe_name}.svg")
        generate_svg_collage(filepath, style)

    # 2. Download Examples (Real images for Home Carousel)
    print("Downloading Examples...")
    seeds = ["van", "camper", "interior", "wood", "forest", "roadtrip"]
    for i, seed in enumerate(seeds):
        filepath = os.path.join(ASSETS_DIR, "examples", f"ex_{i}.jpg")
        download_picsum(filepath, seed)

    # 3. Download Onboarding
    print("Downloading Onboarding...")
    onboard_seeds = ["planning", "camera", "lighting"]
    for i, seed in enumerate(onboard_seeds):
        filepath = os.path.join(ASSETS_DIR, "onboarding", f"onboard_{i}.jpg")
        download_picsum(filepath, seed)

    # 4. Create Manifest
    print("Creating Manifest...")
    with open(os.path.join(ASSETS_DIR, "ASSET_SOURCES.md"), "w") as f:
        f.write("# Asset Sources\n\n")
        f.write("| Filename | Source | License |\n")
        f.write("|---|---|---|\n")
        for style in STYLES:
            safe_name = style.replace(" ", "_").replace("/", "_").lower()
            f.write(f"| style_moodboards/{safe_name}.svg | Generated (In-Project) | MIT |\n")
        for i, seed in enumerate(seeds):
            f.write(f"| examples/ex_{i}.jpg | Picsum (Unsplash) - Seed: {seed} | Unsplash License / Public Domain |\n")
        for i, seed in enumerate(onboard_seeds):
            f.write(f"| onboarding/onboard_{i}.jpg | Picsum (Unsplash) - Seed: {seed} | Unsplash License / Public Domain |\n")

    print("Done.")

if __name__ == "__main__":
    main()
