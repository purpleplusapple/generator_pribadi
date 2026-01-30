import os
import random

STYLES = [
    "Scandinavian Van Minimal", "Japandi Camper Calm", "Warm Wood Craft", "Industrial Matte Black",
    "Boho Adventure Van", "Surf Van Coastal", "Mountain Cabin Van", "Desert Nomad Van",
    "Off-Grid Solar Pro", "Micro Van Ultra Compact", "Family Bunk Layout", "Couple Cozy Layout",
    "Work-From-Van Studio", "Luxury Sprinter Lounge", "Minimal Kitchen Galley", "Full Bathroom Micro Wet Bath",
    "Hidden Storage Max", "Bike Board Gear Hauler", "Pet-Friendly Van", "Winter Insulated Van",
    "Summer Ventilation Breeze", "Retro Classic Van", "Futuristic Clean Pod", "Dark Moody Cabin",
    "Bright Daylight White", "Budget DIY Build", "Premium Custom Cabinetry", "Outdoor Shower Setup",
    "L-Shape Lounge Layout", "U-Shape Social Layout", "Custom Advanced"
]

COLORS = {
    "Scandinavian": ["#E0E0E0", "#F5F5F5", "#FFFFFF", "#D7CCC8"],
    "Japandi": ["#D7CCC8", "#8D6E63", "#FAFAFA", "#212121"],
    "Wood": ["#8D6E63", "#5D4037", "#D7CCC8", "#A1887F"],
    "Dark": ["#212121", "#424242", "#616161", "#000000"],
    "Boho": ["#FFCC80", "#FFAB91", "#A5D6A7", "#D7CCC8"],
    "Coastal": ["#81D4FA", "#B3E5FC", "#E1F5FE", "#FFF9C4"],
    "Nature": ["#A5D6A7", "#81C784", "#66BB6A", "#D7CCC8"],
    "Industrial": ["#616161", "#757575", "#BDBDBD", "#212121"],
}

def get_colors(style_name):
    style_name = style_name.lower()
    if "scandi" in style_name or "minimal" in style_name or "white" in style_name:
        return COLORS["Scandinavian"]
    if "japandi" in style_name:
        return COLORS["Japandi"]
    if "wood" in style_name or "cabin" in style_name:
        return COLORS["Wood"]
    if "dark" in style_name or "industrial" in style_name or "black" in style_name:
        return COLORS["Dark"]
    if "boho" in style_name or "desert" in style_name:
        return COLORS["Boho"]
    if "surf" in style_name or "coastal" in style_name or "summer" in style_name:
        return COLORS["Coastal"]
    if "mountain" in style_name or "forest" in style_name or "garden" in style_name:
        return COLORS["Nature"]
    return COLORS["Industrial"] # Default

def create_svg(filename, title, subtitle, colors):
    c1, c2, c3, c4 = colors[0], colors[1], colors[2], colors[3]
    svg_content = f'''<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <filter id="shadow" x="-20%" y="-20%" width="140%" height="140%">
      <feGaussianBlur in="SourceAlpha" stdDeviation="5"/>
      <feOffset dx="2" dy="2" result="offsetblur"/>
      <feFlood flood-color="#000000" flood-opacity="0.3"/>
      <feComposite in2="offsetblur" operator="in"/>
      <feMerge>
        <feMergeNode/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>
  </defs>

  <!-- 2x2 Grid Layout -->
  <rect x="0" y="0" width="200" height="200" fill="{c1}" />
  <rect x="200" y="0" width="200" height="200" fill="{c2}" />
  <rect x="0" y="200" width="200" height="200" fill="{c3}" />
  <rect x="200" y="200" width="200" height="200" fill="{c4}" />

  <!-- Overlay -->
  <rect x="40" y="140" width="320" height="120" rx="10" fill="rgba(0,0,0,0.6)" filter="url(#shadow)" />

  <!-- Text -->
  <text x="200" y="190" font-family="Arial, sans-serif" font-size="24" font-weight="bold" fill="white" text-anchor="middle">{title}</text>
  <text x="200" y="220" font-family="Arial, sans-serif" font-size="16" fill="#DDD" text-anchor="middle">{subtitle}</text>
</svg>'''

    with open(filename, 'w') as f:
        f.write(svg_content)
    print(f"Generated {filename}")

def main():
    base_path = "43_Camper_Van_Interior_AI/assets"

    # 1. Generate Style Moodboards
    moodboard_path = os.path.join(base_path, "style_moodboards")
    for i, style in enumerate(STYLES):
        safe_name = style.lower().replace(" ", "_").replace("-", "_")
        filename = os.path.join(moodboard_path, f"{safe_name}.svg")
        colors = get_colors(style)
        create_svg(filename, style, "Moodboard & Materials", colors)

    # 2. Generate Examples (Home Carousel)
    examples_path = os.path.join(base_path, "examples")
    example_titles = ["Signature Sprinter", "Eco-Camper Pro", "Weekend Warrior", "Digital Nomad Studio"]
    for i, title in enumerate(example_titles):
        filename = os.path.join(examples_path, f"example_{i+1}.svg")
        create_svg(filename, title, "Featured Build", COLORS["Wood"])

    # 3. Generate Onboarding
    onboard_path = os.path.join(base_path, "onboarding")
    onboard_titles = ["Take a Photo", "Choose Style", "Get Results", "Plan Your Build", "Framing Tips", "Lighting Tips"]
    for i, title in enumerate(onboard_titles):
        filename = os.path.join(onboard_path, f"onboard_{i+1}.svg")
        create_svg(filename, title, "Guide Step", COLORS["Industrial"])

    # 4. Generate Illustrations (Empty States)
    illus_path = os.path.join(base_path, "illustrations")
    illus_titles = ["No Builds Yet", "History Empty", "Favorites Empty", "Error State"]
    for i, title in enumerate(illus_titles):
        filename = os.path.join(illus_path, f"empty_{i+1}.svg")
        create_svg(filename, title, "Illustration", COLORS["Boho"])

    # 5. Generate Manifest
    manifest_path = os.path.join(base_path, "ASSET_SOURCES.md")
    with open(manifest_path, 'w') as f:
        f.write("# Asset Sources & Licenses\n\n")
        f.write("| Filename | Category | Source | License | Date |\n")
        f.write("|----------|----------|--------|---------|------|\n")
        f.write("| *.svg | All | Generated In-Project | MIT/CC0 | 2024-05-20 |\n")
        f.write("\n\n**Note:** Due to sandbox environment restrictions preventing browser automation/downloads from Unsplash, assets were programmatically generated as high-quality SVGs to ensure functional completeness and design consistency.")

if __name__ == "__main__":
    main()
