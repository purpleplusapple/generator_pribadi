import os

def create_svg(filename, color, text):
    content = f'''<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">
  <rect width="400" height="400" fill="{color}" />
  <circle cx="200" cy="150" r="100" fill="rgba(255,255,255,0.2)" />
  <circle cx="200" cy="200" r="150" fill="rgba(0,0,0,0.1)" />
  <text x="50%" y="80%" dominant-baseline="middle" text-anchor="middle" font-family="Arial" font-size="24" fill="white">{text}</text>
</svg>'''
    with open(filename, 'w') as f:
        f.write(content)

base_path = "38_Balcony_Terrace_AI/assets"

# Styles
styles = [
    ("style_cozy_lantern", "#E7A35A", "Cozy Lantern"),
    ("style_modern_minimal", "#263332", "Modern Minimal"),
    ("style_tropical_garden", "#2DBA8A", "Tropical Garden"),
    ("style_boho_rattan", "#D4AF37", "Boho Rattan"),
    ("style_rooftop_party", "#6F7CFF", "Rooftop Party"),
    ("style_japandi_calm", "#A3ACA2", "Japandi Calm"),
    ("style_mediterranean", "#2FA37B", "Mediterranean"),
    ("style_urban_industrial", "#3E2723", "Industrial"),
    ("style_zen_garden", "#0B1110", "Zen Garden"),
    ("style_scandi_soft", "#D2D7CF", "Scandi Soft"),
    ("style_romantic_candle", "#D14B4B", "Romantic"),
    ("style_bbq_social", "#BF8040", "BBQ Social"),
    ("style_compact_narrow", "#212121", "Narrow Hack"),
    ("style_luxury_hotel", "#070B0A", "Luxury Hotel"),
    ("style_pet_friendly", "#66BB6A", "Pet Friendly"),
    ("style_plant_jungle", "#142220", "Jungle Max"),
    ("style_rainy_cozy", "#6F7CFF", "Rainy Cozy"),
    ("style_minimal_green", "#2FA37B", "Minimal Green"),
    ("style_wabi_sabi", "#9E9E9E", "Wabi-Sabi"),
    ("style_moroccan", "#E7A35A", "Moroccan"),
    ("style_korean_minimal", "#FAFAFA", "Korean Minimal"),
    ("style_bistro_paris", "#263332", "Bistro Paris"),
    ("style_beachy_coastal", "#A3ACA2", "Beachy Coastal"),
    ("style_fire_pit", "#EF5350", "Fire Pit"),
]

for name, color, label in styles:
    create_svg(f"{base_path}/style_thumbs/{name}.svg", color, label)

# Examples
for i in range(1, 6):
    create_svg(f"{base_path}/examples/example_scene_{i}.svg", "#101A18", f"Example {i}")

# Onboarding
create_svg(f"{base_path}/onboarding/onboard_good_photo.svg", "#2DBA8A", "Good Photo")
create_svg(f"{base_path}/onboarding/onboard_bad_photo.svg", "#D14B4B", "Bad Photo")
create_svg(f"{base_path}/onboarding/onboard_before_frame.svg", "#3E2723", "Before")
create_svg(f"{base_path}/onboarding/onboard_after_frame.svg", "#2FA37B", "After")

# Illustrations
create_svg(f"{base_path}/illustrations/empty_history.svg", "#263332", "No History")
create_svg(f"{base_path}/illustrations/empty_favorites.svg", "#263332", "No Favorites")
create_svg(f"{base_path}/illustrations/no_internet.svg", "#D14B4B", "No Internet")
create_svg(f"{base_path}/illustrations/quota_finished.svg", "#E7A35A", "Quota Finished")

print("Assets generated.")
