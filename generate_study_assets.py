import os
import random

base_path = "42_Study_Class_AI/assets"

def create_moodboard_svg(filename, colors, title):
    # colors is a list of 4 hex codes
    c1, c2, c3, c4 = colors
    content = f'''<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">
  <!-- Top Left -->
  <rect x="0" y="0" width="200" height="200" fill="{c1}" />
  <circle cx="100" cy="100" r="40" fill="rgba(255,255,255,0.1)" />

  <!-- Top Right -->
  <rect x="200" y="0" width="200" height="200" fill="{c2}" />
  <rect x="250" y="50" width="100" height="100" fill="rgba(255,255,255,0.1)" />

  <!-- Bottom Left -->
  <rect x="0" y="200" width="200" height="200" fill="{c3}" />
  <path d="M50 350 L100 250 L150 350 Z" fill="rgba(255,255,255,0.1)" />

  <!-- Bottom Right -->
  <rect x="200" y="200" width="200" height="200" fill="{c4}" />
  <circle cx="300" cy="300" r="50" fill="rgba(0,0,0,0.1)" />

  <!-- Overlay Text -->
  <rect x="0" y="340" width="400" height="60" fill="rgba(0,0,0,0.6)" />
  <text x="200" y="375" dominant-baseline="middle" text-anchor="middle" font-family="Arial" font-weight="bold" font-size="20" fill="white">{title}</text>
</svg>'''
    with open(filename, 'w') as f:
        f.write(content)

def create_simple_svg(filename, color, text):
    content = f'''<svg width="400" height="600" xmlns="http://www.w3.org/2000/svg">
  <rect width="400" height="600" fill="{color}" />
  <text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" font-family="Arial" font-size="24" fill="white">{text}</text>
</svg>'''
    with open(filename, 'w') as f:
        f.write(content)

# Colors
palette = [
    "#0A0D14", "#0F1422", "#151C2E", "#1B2440", # Darks
    "#D0A85C", "#2A2417", # Gold/Brown
    "#4B86FF", "#2EC8A6", "#2DBA8A", "#D14B4B", # Accents
    "#A8A39A", "#2A3350" # Muted
]

def get_random_colors():
    return [random.choice(palette) for _ in range(4)]

styles = [
    ("dark_academia", "Dark Academia Study"),
    ("modern_minimal", "Modern Minimal Study"),
    ("scandi_bright", "Scandinavian Bright Desk"),
    ("japandi_calm", "Japandi Calm Study"),
    ("industrial_loft", "Industrial Study Loft"),
    ("cozy_lamp", "Cozy Lamp Corner"),
    ("library_wall", "Library Wall Study"),
    ("whiteboard_pro", "Whiteboard Classroom"),
    ("student_dorm", "Student Dorm Compact"),
    ("small_desk_hack", "Small Desk Space Hack"),
    ("gaming_hybrid", "Gaming-Study Hybrid"),
    ("creative_art", "Creative Art Studio"),
    ("minimal_mono", "Minimal Monochrome"),
    ("warm_wood", "Warm Wood Study"),
    ("korean_clean", "Korean Clean Desk"),
    ("parisian_nook", "Parisian Study Nook"),
    ("mid_century", "Mid-Century Study"),
    ("futuristic_pod", "Futuristic Study Pod"),
    ("botanical_calm", "Botanical Calm Study"),
    ("high_contrast", "High Contrast Black"),
    ("soft_pastel", "Soft Pastel Study"),
    ("tech_workspace", "Tech Workspace Pro"),
    ("montessori_kids", "Montessori Kids"),
    ("exam_focus", "Exam Focus Setup"),
    ("night_owl", "Night Owl Study"),
    ("daylight_prod", "Daylight Productivity"),
    ("storage_max", "Storage Maximalist"),
    ("silent_zen", "Silent Zen Study"),
    ("custom_adv", "Custom Advanced")
]

# Generate Style Moodboards
for code, name in styles:
    colors = get_random_colors()
    create_moodboard_svg(f"{base_path}/style_moodboards/{code}.svg", colors, name)

# Generate Style Tiles (can reuse moodboards or simplify) - reusing logic for now but specific files
for code, name in styles:
    colors = get_random_colors()
    create_moodboard_svg(f"{base_path}/style_tiles/{code}.svg", colors, name) # Same visual for now

# Generate Examples (Portrait)
for i in range(1, 7):
    create_simple_svg(f"{base_path}/examples/example_{i}.svg", random.choice(palette), f"Example {i}")

# Generate Onboarding
onboarding = [
    ("onboard_good", "Good Photo"),
    ("onboard_bad", "Bad Photo"),
    ("onboard_frame", "Framing Guide"),
    ("onboard_lighting", "Lighting Guide")
]
for code, name in onboarding:
    create_simple_svg(f"{base_path}/onboarding/{code}.svg", "#151C2E", name)

# Generate Illustrations
illustrations = [
    ("empty_history", "No History Yet"),
    ("empty_favorites", "No Favorites"),
    ("no_internet", "No Connection"),
    ("quota_limit", "Quota Reached")
]
for code, name in illustrations:
    create_simple_svg(f"{base_path}/illustrations/{code}.svg", "#0F1422", name)

print("Study Class AI assets generated successfully.")
