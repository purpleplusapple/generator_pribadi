import os
import random

# Define styles
styles = [
    "Speakeasy Noir Bar", "Modern Marble Bar", "Japandi Mini Bar", "Scandinavian Light",
    "Tropical Tiki Corner", "Industrial Pipe Shelf Bar", "Luxury Hotel Mini Bar", "Art Deco Glam Bar",
    "Mid-Century Bar Cart", "Wine Cellar Wall Mini", "Coffee + Bar Hybrid", "Zero-Proof Mocktail Bar",
    "Compact Pantry Bar", "Outdoor Balcony Mini Bar", "Neon-Subtle Lounge Bar", "Warm Wood Craft Bar",
    "Black & Brass Bar", "Concrete Minimal Bar", "Boho Rattan Bar", "Coastal Breeze Bar",
    "Retro Diner Bar", "Futuristic Clean Bar", "Budget DIY Bar Corner", "Premium Custom Cabinetry Bar",
    "Hidden Fold-Out Bar", "Corner Shelf Bar", "Sink + Ice Station Bar", "Bottle Showcase Gallery",
    "Custom (Advanced)"
]

# Paths
base_dir = "48_Mini_Bar_AI/assets"
moodboard_dir = os.path.join(base_dir, "style_moodboards")
examples_dir = os.path.join(base_dir, "examples")
onboarding_dir = os.path.join(base_dir, "onboarding")
illustrations_dir = os.path.join(base_dir, "illustrations")

def ensure_dir(d):
    if not os.path.exists(d):
        os.makedirs(d)

ensure_dir(moodboard_dir)
ensure_dir(examples_dir)
ensure_dir(onboarding_dir)
ensure_dir(illustrations_dir)

def generate_svg_collage(filename, title, color1, color2, style_type="luxe"):
    # Generate a 2x2 moodboard SVG
    svg_content = f'''<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="grad1" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:{color1};stop-opacity:1" />
      <stop offset="100%" style="stop-color:{color2};stop-opacity:1" />
    </linearGradient>
    <pattern id="pattern1" x="0" y="0" width="20" height="20" patternUnits="userSpaceOnUse">
        <circle cx="2" cy="2" r="1" fill="#FFFFFF33" />
    </pattern>
  </defs>

  <!-- Tile 1: Material (Top Left) -->
  <rect x="0" y="0" width="200" height="200" fill="url(#grad1)" />
  <text x="100" y="100" font-family="serif" font-size="20" fill="white" text-anchor="middle" dominant-baseline="middle">Material</text>

  <!-- Tile 2: Display (Top Right) -->
  <rect x="200" y="0" width="200" height="200" fill="{color2}" />
  <rect x="200" y="0" width="200" height="200" fill="url(#pattern1)" />
  <text x="300" y="100" font-family="serif" font-size="20" fill="white" text-anchor="middle" dominant-baseline="middle">Display</text>

  <!-- Tile 3: Lighting (Bottom Left) -->
  <rect x="0" y="200" width="200" height="200" fill="{color1}" />
  <circle cx="100" cy="300" r="50" fill="url(#grad1)" fill-opacity="0.5" />
  <text x="100" y="300" font-family="serif" font-size="20" fill="white" text-anchor="middle" dominant-baseline="middle">Lighting</text>

  <!-- Tile 4: Glassware (Bottom Right) -->
  <rect x="200" y="200" width="200" height="200" fill="#141A27" />
  <text x="300" y="300" font-family="serif" font-size="20" fill="white" text-anchor="middle" dominant-baseline="middle">Glassware</text>

  <!-- Overlay Title -->
  <rect x="0" y="360" width="400" height="40" fill="#000000" fill-opacity="0.6" />
  <text x="20" y="385" font-family="sans-serif" font-size="16" fill="white">{title}</text>
</svg>'''

    with open(filename, "w") as f:
        f.write(svg_content)

# Colors for variety
colors = [
    ("#1A237E", "#880E4F"), ("#004D40", "#F9A825"), ("#263238", "#CFD8DC"),
    ("#3E2723", "#D7CCC8"), ("#33691E", "#DCEDC8"), ("#BF360C", "#FFCCBC"),
    ("#0D47A1", "#BBDEFB"), ("#1B5E20", "#C8E6C9"), ("#880E4F", "#F8BBD0"),
    ("#4A148C", "#E1BEE7"), ("#B71C1C", "#FFCDD2"), ("#F57F17", "#FFF9C4"),
    ("#212121", "#757575"), ("#006064", "#B2EBF2"), ("#E65100", "#FFE0B2")
]

print("Generating Style Moodboards...")
for i, style in enumerate(styles):
    c1, c2 = colors[i % len(colors)]
    filename = os.path.join(moodboard_dir, f"style_{i+1}.svg")
    generate_svg_collage(filename, style, c1, c2)

print("Generating Examples...")
examples = ["Signature Lounge", "Home Speakeasy", "Corner Bar", "Wine Wall"]
for i, ex in enumerate(examples):
    c1, c2 = colors[(i+5) % len(colors)]
    filename = os.path.join(examples_dir, f"example_{i+1}.svg")
    generate_svg_collage(filename, ex, c1, c2)

print("Generating Onboarding...")
onboarding_steps = ["Upload Space", "Choose Style", "Get Results"]
for i, step in enumerate(onboarding_steps):
    c1, c2 = colors[(i+10) % len(colors)]
    filename = os.path.join(onboarding_dir, f"onboard_{i+1}.svg")
    generate_svg_collage(filename, step, c1, c2)

print("Generating Manifest...")
manifest_content = """# Asset Sources

All assets in this project are generated placeholders or royalty-free compatible.

| Filename | Category | Source | License |
|---|---|---|---|
"""
for i in range(len(styles)):
    manifest_content += f"| style_{i+1}.svg | Style Moodboard | Generated In-Project | MIT/Apache 2.0 |\n"

for i in range(len(examples)):
    manifest_content += f"| example_{i+1}.svg | Example | Generated In-Project | MIT/Apache 2.0 |\n"

for i in range(len(onboarding_steps)):
    manifest_content += f"| onboard_{i+1}.svg | Onboarding | Generated In-Project | MIT/Apache 2.0 |\n"

with open(os.path.join(base_dir, "ASSET_SOURCES.md"), "w") as f:
    f.write(manifest_content)

print("Done.")
