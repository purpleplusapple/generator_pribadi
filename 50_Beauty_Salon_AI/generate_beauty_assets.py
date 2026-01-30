import os
import random

PROJECT_ROOT = "50_Beauty_Salon_AI"
ASSETS_DIR = os.path.join(PROJECT_ROOT, "assets")
MOODBOARDS_DIR = os.path.join(ASSETS_DIR, "style_moodboards")
EXAMPLES_DIR = os.path.join(ASSETS_DIR, "examples")
ONBOARDING_DIR = os.path.join(ASSETS_DIR, "onboarding")
ILLUSTRATIONS_DIR = os.path.join(ASSETS_DIR, "illustrations")

# Colors
PALETTE = {
    "bg": "#FFF7FB",
    "primary": "#C24D7C",
    "primarySoft": "#F7D3E3",
    "ink": "#1B1020",
    "gold": "#D7B58A",
    "mint": "#2EC8A6",
    "white": "#FFFFFF",
    "dark": "#3A2A40"
}

STYLES = [
    "Runway Rose Luxe", "Minimal White Glam", "Dark Chic Salon", "Korean Clean Beauty",
    "Japandi Calm Beauty", "Scandinavian Soft Beauty", "Hollywood Mirror Glam", "Parisian Chic Salon",
    "Modern Marble Beauty", "Rose Gold Boutique", "Orchid Neon-Subtle Studio", "Spa Serenity Corner",
    "Clinic-Clean Aesthetic", "Nail Bar Focus", "Hair Studio Focus", "Makeup Station Pro",
    "Reception-First Boutique", "Retail Product Wall Showcase", "Cozy Warm Lounge Salon", "Luxury Hotel Salon Suite",
    "Industrial Beauty Loft", "Tropical Beauty Studio", "Boho Soft Beauty", "Pastel Candy Beauty",
    "Premium Black & Champagne", "Budget Practical Salon", "Small Salon Space Hack", "High Capacity Multi-Station",
    "Content-Creator Friendly Salon", "Bridal Beauty Suite", "Men's Grooming Corner", "Eco-Friendly Natural Beauty"
]

def create_svg_moodboard(filename, style_name, seed):
    random.seed(seed)

    # 2x2 Grid colors
    c1 = random.choice([PALETTE["primary"], PALETTE["primarySoft"], PALETTE["gold"], PALETTE["bg"]])
    c2 = random.choice([PALETTE["white"], PALETTE["mint"], PALETTE["primarySoft"]])
    c3 = random.choice([PALETTE["ink"], PALETTE["dark"], PALETTE["primary"]])
    c4 = random.choice([PALETTE["gold"], PALETTE["primarySoft"], PALETTE["white"]])

    svg = f"""<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">
      <defs>
        <filter id="blur" x="0" y="0">
          <feGaussianBlur in="SourceGraphic" stdDeviation="2" />
        </filter>
      </defs>
      <rect x="0" y="0" width="400" height="400" fill="{PALETTE['bg']}" />

      <!-- Top Left: Material/Texture -->
      <rect x="10" y="10" width="185" height="185" rx="8" fill="{c1}" opacity="0.8"/>
      <circle cx="100" cy="100" r="50" fill="white" opacity="0.2"/>

      <!-- Top Right: Lighting/Vibe -->
      <rect x="205" y="10" width="185" height="185" rx="8" fill="{c2}" opacity="0.9"/>
      <circle cx="297" cy="102" r="30" fill="{PALETTE['gold']}" opacity="0.5" filter="url(#blur)"/>

      <!-- Bottom Left: Furniture/Shape -->
      <rect x="10" y="205" width="185" height="185" rx="8" fill="{c3}" opacity="0.8"/>
      <rect x="50" y="250" width="100" height="80" fill="white" opacity="0.1"/>

      <!-- Bottom Right: Detail/Accessory -->
      <rect x="205" y="205" width="185" height="185" rx="8" fill="{c4}" opacity="0.9"/>
      <line x1="220" y1="220" x2="380" y2="380" stroke="{PALETTE['primary']}" stroke-width="2" opacity="0.3"/>

      <!-- Text Overlay (Simulated Label) -->
      <rect x="0" y="360" width="400" height="40" fill="white" opacity="0.9"/>
      <text x="20" y="385" font-family="Arial" font-size="14" fill="{PALETTE['ink']}">{style_name}</text>
    </svg>"""

    with open(filename, "w") as f:
        f.write(svg)

def generate_all():
    print("Generating assets...")

    # 1. Styles
    for i, style in enumerate(STYLES):
        safe_name = style.lower().replace(" ", "_").replace("&", "and").replace("'", "")
        filename = os.path.join(MOODBOARDS_DIR, f"style_{safe_name}.svg")
        create_svg_moodboard(filename, style, i)

    # 2. Examples (Placeholders)
    for i in range(1, 13):
        filename = os.path.join(EXAMPLES_DIR, f"example_salon_{i}.svg")
        create_svg_moodboard(filename, f"Salon Inspiration {i}", i + 100)

    # 3. Onboarding
    onboarding_steps = ["lighting", "angles", "clean_space", "reflection"]
    for step in onboarding_steps:
        filename = os.path.join(ONBOARDING_DIR, f"guide_{step}.svg")
        create_svg_moodboard(filename, f"Guide: {step}", 500)

    # 4. Illustrations (Empty states)
    filename = os.path.join(ILLUSTRATIONS_DIR, "empty_history.svg")
    create_svg_moodboard(filename, "No Salons Yet", 999)

    print("Assets generated.")

    # 5. Manifest
    with open(os.path.join(ASSETS_DIR, "ASSET_SOURCES.md"), "w") as f:
        f.write("# Asset Sources\n\n")
        f.write("| Filename | Source | License | Date |\n")
        f.write("|---|---|---|---|\n")
        f.write("| All .svg files | Generated In-Project (Moodboard Engine) | MIT | 2024-05-23 |\n")
        f.write("| Note | Primary images generated procedurally to ensure style consistency and availability. |\n")

if __name__ == "__main__":
    generate_all()
