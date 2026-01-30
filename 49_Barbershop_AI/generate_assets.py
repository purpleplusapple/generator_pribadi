import os

def ensure_dir(path):
    if not os.path.exists(path):
        os.makedirs(path)

# Colors
CHARCOAL = "#141A27"
GOLD = "#D0A85C"
INK = "#F5F2ED"
MUTED = "#A8A19A"
CHROME = "#E0E0E0"
LEATHER = "#5C4033"
WOOD = "#8B5A2B"
RED = "#D64B4B"
BLUE = "#3E7BFA"

def create_svg(filename, width, height, content):
    svg = f'<svg width="{width}" height="{height}" xmlns="http://www.w3.org/2000/svg">{content}</svg>'
    with open(filename, 'w') as f:
        f.write(svg)

def rect(x, y, w, h, fill, opacity=1.0):
    return f'<rect x="{x}" y="{y}" width="{w}" height="{h}" fill="{fill}" fill-opacity="{opacity}" />'

def circle(cx, cy, r, fill, opacity=1.0):
    return f'<circle cx="{cx}" cy="{cy}" r="{r}" fill="{fill}" fill-opacity="{opacity}" />'

def text(x, y, content, fill=INK, size=20):
    return f'<text x="{x}" y="{y}" font-family="serif" font-size="{size}" fill="{fill}" text-anchor="middle">{content}</text>'

# 1. Style Moodboards (4-tile collage)
# Layout:
# [ Chair ] [ Mirror ]
# [ Matrl ] [ Light  ]
def generate_style_moodboards():
    out_dir = "49_Barbershop_AI/assets/style_moodboards/"
    ensure_dir(out_dir)

    styles = [
        ("classic_heritage", LEATHER, GOLD, "Heritage"),
        ("modern_minimal", "#222222", "#FFFFFF", "Modern"),
        ("industrial_concrete", "#555555", "#000000", "Industrial"),
        ("luxury_black_gold", "#000000", GOLD, "Luxury"),
        ("vintage_brick", "#8B4513", "#F5F5DC", "Vintage"),
        ("scandinavian", "#E0E0E0", "#FFFFFF", "Scandi"),
        ("japandi", "#D2B48C", "#FFFFFF", "Japandi"),
        ("retro_diner", RED, "#FFFFFF", "Retro"),
        ("streetwear_urban", "#333333", "#FF0000", "Urban"),
        ("premium_hotel", "#1A1A1A", "#C0C0C0", "Hotel"),
        ("dark_moody", "#050505", "#333333", "Moody"),
        ("bright_clean", "#FFFFFF", "#AAAAAA", "Clean"),
        ("compact_2chair", "#444444", "#DDDDDD", "Compact"),
        ("efficient_line", "#222222", "#AAAAAA", "Line"),
        ("high_capacity", "#111111", "#999999", "Large"),
        ("wash_station", "#000066", "#FFFFFF", "Wash"),
        ("waiting_lounge", LEATHER, "#222222", "Lounge"),
        ("product_retail", "#333333", GOLD, "Retail"),
        ("neon_subtle", "#111111", "#00FF00", "Neon"),
        ("wood_chrome", WOOD, CHROME, "Wood"),
        ("marble_grooming", "#F0F0F0", "#333333", "Marble"),
        ("tattoo_hybrid", "#000000", "#FF00FF", "Tattoo"),
        ("kids_friendly", BLUE, RED, "Kids"),
        ("budget_diy", "#AAAAAA", "#CCCCCC", "Budget"),
        ("custom_cabinetry", WOOD, "#444444", "Custom"),
        ("minimal_mono", "#000000", "#FFFFFF", "Mono"),
        ("heritage_stripe", "#000044", RED, "Stripe"),
        ("glass_steel", "#DDEEFF", "#999999", "Glass"),
        ("cozy_warm", "#5C4033", "#FFAA00", "Cozy"),
        ("content_creator", "#222222", "#FF00AA", "Creator"),
    ]

    for name, primary, secondary, label in styles:
        # Create a 2x2 grid look
        content = ""
        # Bg
        content += rect(0, 0, 400, 400, CHARCOAL)

        # Tile 1: Chair (Top Left)
        content += rect(10, 10, 185, 185, primary)
        content += circle(102, 102, 40, secondary) # Chair seat representation

        # Tile 2: Mirror (Top Right)
        content += rect(205, 10, 185, 185, "#2A3144")
        content += rect(230, 30, 135, 145, "#4A5164") # Mirror reflection

        # Tile 3: Material Detail (Bottom Left)
        content += rect(10, 205, 185, 185, secondary)
        content += f'<path d="M10 205 L195 390" stroke="{primary}" stroke-width="2" />' # Texture

        # Tile 4: Lighting (Bottom Right)
        content += rect(205, 205, 185, 185, "#000000")
        content += circle(297, 297, 30, "#FFFFCC", opacity=0.8) # Light glow

        # Overlay Text
        # content += text(200, 380, label, INK, 24)

        create_svg(f"{out_dir}/{name}.svg", 400, 400, content)

# 2. Example Shops (Carousel)
def generate_example_shops():
    out_dir = "49_Barbershop_AI/assets/examples/"
    ensure_dir(out_dir)

    for i in range(1, 13):
        content = rect(0, 0, 600, 800, CHARCOAL)
        content += rect(0, 0, 600, 800, "url(#grad1)", opacity=0.3)
        # Perspective lines
        content += f'<path d="M0 800 L300 400 L600 800" fill="{WOOD}" opacity="0.5"/>'
        # Mirror
        content += rect(100, 100, 400, 300, CHROME)
        content += rect(120, 120, 360, 260, "#333333")

        create_svg(f"{out_dir}/shop_{i:02d}.svg", 600, 800, content)

# 3. Onboarding & Illus
def generate_illustrations():
    out_dir = "49_Barbershop_AI/assets/illustrations/"
    ensure_dir(out_dir)

    # Empty State
    create_svg(f"{out_dir}/empty_history.svg", 300, 300,
               rect(0,0,300,300, CHARCOAL) + circle(150,150, 80, MUTED) + text(150, 160, "?", CHARCOAL, 80))

    out_dir_onboard = "49_Barbershop_AI/assets/onboarding/"
    ensure_dir(out_dir_onboard)

    # Guides
    create_svg(f"{out_dir_onboard}/guide_lighting.svg", 400, 300, rect(0,0,400,300, CHARCOAL) + circle(200,100, 50, GOLD))
    create_svg(f"{out_dir_onboard}/guide_angle.svg", 400, 300, rect(0,0,400,300, CHARCOAL) + rect(100,100, 200,100, CHROME))

if __name__ == "__main__":
    generate_style_moodboards()
    generate_example_shops()
    generate_illustrations()
    print("Assets generated.")
