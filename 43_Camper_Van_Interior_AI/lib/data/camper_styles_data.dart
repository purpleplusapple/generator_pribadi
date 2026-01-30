// lib/data/camper_styles_data.dart

import '../model/camper_style_def.dart';

class CamperStylesData {

  static List<StyleControl> get _commonControls => [
    const StyleControl(
      id: 'van_size',
      label: 'Van Size',
      type: ControlType.chips,
      options: ['Micro', 'Mid-Size', 'Sprinter 144', 'Sprinter 170', 'Box Truck'],
      defaultString: 'Sprinter 144',
    ),
    const StyleControl(
      id: 'layout_bed',
      label: 'Bed Orientation',
      type: ControlType.chips,
      options: ['Fixed Rear', 'Convertible Dinette', 'Murphy Bed', 'Elevator Bed'],
      defaultString: 'Fixed Rear',
    ),
    const StyleControl(
      id: 'off_grid',
      label: 'Off-Grid Capability',
      type: ControlType.slider,
      min: 0, max: 100, defaultDouble: 50,
    ),
    const StyleControl(
      id: 'materials',
      label: 'Material Palette',
      type: ControlType.chips,
      options: ['Light Wood', 'Dark Walnut', 'White Laminate', 'Industrial Metal', 'Recycled'],
      defaultString: 'Light Wood',
    ),
    const StyleControl(
      id: 'lighting',
      label: 'Lighting Ambience',
      type: ControlType.chips,
      options: ['Warm 2700K', 'Daylight 4000K', 'RGB Mood', 'Task Focused'],
      defaultString: 'Warm 2700K',
    ),
    const StyleControl(
      id: 'budget',
      label: 'Build Budget Estimate',
      type: ControlType.slider,
      min: 5000, max: 150000, defaultDouble: 30000,
    ),
    const StyleControl(
      id: 'user_note',
      label: 'Special Requests',
      type: ControlType.text,
    ),
  ];

  static List<StyleControl> _mergeControls(List<StyleControl> specific) {
    return [..._commonControls, ...specific];
  }

  static final List<CamperStyle> styles = [
    // 1. Scandinavian Van Minimal
    CamperStyle(
      id: 'scandi_minimal',
      name: 'Scandinavian Minimal',
      description: 'Clean lines, light wood, airy feel.',
      moodboardImage: 'assets/style_moodboards/scandinavian_van_minimal.svg',
      tags: ['Minimal', 'Bright', 'Cozy'],
      controls: _mergeControls([
        const StyleControl(id: 'hygge_level', label: 'Hygge Factor', type: ControlType.slider, min: 0, max: 100, defaultDouble: 80),
      ]),
    ),
    // 2. Japandi Camper Calm
    CamperStyle(
      id: 'japandi_calm',
      name: 'Japandi Calm',
      description: 'Fusion of Japanese rustic and Scandinavian functional.',
      moodboardImage: 'assets/style_moodboards/japandi_camper_calm.svg',
      tags: ['Zen', 'Wood', 'Low-profile'],
      controls: _mergeControls([
        const StyleControl(id: 'tatami_area', label: 'Tatami Mat Area', type: ControlType.toggle, defaultBool: false),
      ]),
    ),
    // 3. Warm Wood Craft
    CamperStyle(
      id: 'warm_wood',
      name: 'Warm Wood Craft',
      description: 'Traditional carpentry, cedar planking, cabin feel.',
      moodboardImage: 'assets/style_moodboards/warm_wood_craft.svg',
      tags: ['Rustic', 'Cozy', 'Traditional'],
      controls: _mergeControls([
         const StyleControl(id: 'wood_type', label: 'Wood Species', type: ControlType.chips, options: ['Cedar', 'Pine', 'Oak'], defaultString: 'Cedar'),
      ]),
    ),
    // 4. Industrial Matte Black
    CamperStyle(
      id: 'industrial_black',
      name: 'Industrial Matte',
      description: 'Stealth look, metal fixtures, utilitarian.',
      moodboardImage: 'assets/style_moodboards/industrial_matte_black.svg',
      tags: ['Modern', 'Stealth', 'Durable'],
      controls: _mergeControls([]),
    ),
    // 5. Boho Adventure Van
    CamperStyle(
      id: 'boho_adventure',
      name: 'Boho Adventure',
      description: 'Macrame, patterns, plants, relaxed vibe.',
      moodboardImage: 'assets/style_moodboards/boho_adventure_van.svg',
      tags: ['Eclectic', 'Soft', 'Colorful'],
      controls: _mergeControls([]),
    ),
    // 6. Surf Van Coastal
    CamperStyle(
      id: 'surf_coastal',
      name: 'Surf Coastal',
      description: 'Beach vibes, white wash, gear storage.',
      moodboardImage: 'assets/style_moodboards/surf_van_coastal.svg',
      tags: ['Beach', 'Fresh', 'Airy'],
      controls: _mergeControls([
         const StyleControl(id: 'board_storage', label: 'Surfboard Rack', type: ControlType.chips, options: ['Ceiling', 'Wall', 'Garage'], defaultString: 'Ceiling'),
      ]),
    ),
    // 7. Mountain Cabin Van
    CamperStyle(
      id: 'mountain_cabin',
      name: 'Mountain Cabin',
      description: 'Insulated, stone accents, fireplace feel.',
      moodboardImage: 'assets/style_moodboards/mountain_cabin_van.svg',
      tags: ['Winter', 'Cozy', 'Dark'],
      controls: _mergeControls([]),
    ),
    // 8. Desert Nomad Van
    CamperStyle(
      id: 'desert_nomad',
      name: 'Desert Nomad',
      description: 'Earth tones, terracotta, heat management.',
      moodboardImage: 'assets/style_moodboards/desert_nomad_van.svg',
      tags: ['Warm', 'Earthy', 'Rugged'],
      controls: _mergeControls([]),
    ),
    // 9. Off-Grid Solar Pro
    CamperStyle(
      id: 'solar_pro',
      name: 'Solar Pro',
      description: 'Tech-heavy, massive battery bank, efficiency.',
      moodboardImage: 'assets/style_moodboards/off_grid_solar_pro.svg',
      tags: ['Tech', 'Functional', 'Power'],
      controls: _mergeControls([
        const StyleControl(id: 'solar_capacity', label: 'Solar Capacity', type: ControlType.chips, options: ['200W', '400W', '800W+'], defaultString: '400W'),
        const StyleControl(id: 'battery_bank', label: 'Battery Priority', type: ControlType.chips, options: ['Balanced', 'Power Heavy'], defaultString: 'Power Heavy'),
      ]),
    ),
    // 10. Micro Van Ultra Compact
    CamperStyle(
      id: 'micro_compact',
      name: 'Micro Compact',
      description: 'Optimized for small footprints like Transit Connect.',
      moodboardImage: 'assets/style_moodboards/micro_van_ultra_compact.svg',
      tags: ['Small', 'Smart', 'Efficient'],
      controls: _mergeControls([]),
    ),
    // 11. Family Bunk Layout
    CamperStyle(
      id: 'family_bunk',
      name: 'Family Bunk',
      description: 'Sleeps 4+, safe for kids, durable materials.',
      moodboardImage: 'assets/style_moodboards/family_bunk_layout.svg',
      tags: ['Family', 'Sleeping', 'Practical'],
      controls: _mergeControls([
        const StyleControl(id: 'bunk_count', label: 'Bunk Count', type: ControlType.stepper, defaultInt: 2, min: 1, max: 4),
        const StyleControl(id: 'safety_rail', label: 'Safety Rails', type: ControlType.toggle, defaultBool: true),
      ]),
    ),
    // 12. Couple Cozy Layout
    CamperStyle(
      id: 'couple_cozy',
      name: 'Couple Cozy',
      description: 'Romantic lighting, large bed, wine storage.',
      moodboardImage: 'assets/style_moodboards/couple_cozy_layout.svg',
      tags: ['Romantic', 'Comfort', 'Lounge'],
      controls: _mergeControls([]),
    ),
    // 13. Work-From-Van Studio
    CamperStyle(
      id: 'wfv_studio',
      name: 'WFV Studio',
      description: 'Ergonomic desk, multiple monitors, sound dampening.',
      moodboardImage: 'assets/style_moodboards/work_from_van_studio.svg',
      tags: ['Office', 'Productivity', 'Tech'],
      controls: _mergeControls([
        const StyleControl(id: 'desk_type', label: 'Desk Type', type: ControlType.chips, options: ['Fixed', 'Lagun Table', 'Fold-down'], defaultString: 'Fixed'),
        const StyleControl(id: 'monitor_count', label: 'Monitors', type: ControlType.stepper, defaultInt: 1, min: 1, max: 3),
      ]),
    ),
    // 14. Luxury Sprinter Lounge
    CamperStyle(
      id: 'luxury_lounge',
      name: 'Luxury Lounge',
      description: 'Limousine feel, leather, high-end finish.',
      moodboardImage: 'assets/style_moodboards/luxury_sprinter_lounge.svg',
      tags: ['Premium', 'Social', 'Comfort'],
      controls: _mergeControls([]),
    ),
    // 15. Minimal Kitchen Galley
    CamperStyle(
      id: 'minimal_kitchen',
      name: 'Minimal Kitchen',
      description: 'Focus on cooking, large counter, induction.',
      moodboardImage: 'assets/style_moodboards/minimal_kitchen_galley.svg',
      tags: ['Cooking', 'Chef', 'Clean'],
      controls: _mergeControls([]),
    ),
    // 16. Full Bathroom Micro Wet Bath
    CamperStyle(
      id: 'wet_bath',
      name: 'Wet Bath Micro',
      description: 'Internal shower/toilet unit in small footprint.',
      moodboardImage: 'assets/style_moodboards/full_bathroom_micro_wet_bath.svg',
      tags: ['Plumbing', 'Comfort', 'Clean'],
      controls: _mergeControls([
        const StyleControl(id: 'bath_size', label: 'Bath Size', type: ControlType.chips, options: ['Micro (24x24)', 'Standard (32x24)', 'Large'], defaultString: 'Micro (24x24)'),
        const StyleControl(id: 'toilet_type', label: 'Toilet', type: ControlType.chips, options: ['Compost', 'Cassette', 'None'], defaultString: 'Compost'),
      ]),
    ),
    // 17. Hidden Storage Max
    CamperStyle(
      id: 'storage_max',
      name: 'Hidden Storage',
      description: 'False floors, ceiling cabinets, every inch used.',
      moodboardImage: 'assets/style_moodboards/hidden_storage_max.svg',
      tags: ['Practical', 'Organized', 'Gear'],
      controls: _mergeControls([]),
    ),
    // 18. Bike/Board Gear Hauler
    CamperStyle(
      id: 'gear_hauler',
      name: 'Gear Hauler',
      description: 'Garage heavy, slide-out trays, durable floor.',
      moodboardImage: 'assets/style_moodboards/bike_board_gear_hauler.svg',
      tags: ['Active', 'Garage', 'Durable'],
      controls: _mergeControls([
        const StyleControl(id: 'gear_type', label: 'Gear Focus', type: ControlType.chips, options: ['Bikes', 'Moto', 'Ski', 'Climb'], defaultString: 'Bikes'),
      ]),
    ),
    // 19. Pet-Friendly Van
    CamperStyle(
      id: 'pet_friendly',
      name: 'Pet Friendly',
      description: 'Scratch-proof, built-in kennel, spill-proof bowls.',
      moodboardImage: 'assets/style_moodboards/pet_friendly_van.svg',
      tags: ['Pets', 'Durable', 'Cozy'],
      controls: _mergeControls([]),
    ),
    // 20. Winter Insulated Van
    CamperStyle(
      id: 'winter_insulated',
      name: 'Winter Ready',
      description: 'Heater priority, drying closet, thermal curtains.',
      moodboardImage: 'assets/style_moodboards/winter_insulated_van.svg',
      tags: ['Cold', 'Insulated', 'Cozy'],
      controls: _mergeControls([]),
    ),
    // 21. Summer Ventilation Breeze
    CamperStyle(
      id: 'summer_breeze',
      name: 'Summer Breeze',
      description: 'Max airflow, screen doors, light colors.',
      moodboardImage: 'assets/style_moodboards/summer_ventilation_breeze.svg',
      tags: ['Hot', 'Airy', 'Open'],
      controls: _mergeControls([]),
    ),
    // 22. Retro Classic Van
    CamperStyle(
      id: 'retro_classic',
      name: 'Retro Classic',
      description: '70s vibe, shag rug, orange/brown tones.',
      moodboardImage: 'assets/style_moodboards/retro_classic_van.svg',
      tags: ['Vintage', 'Funky', 'Colorful'],
      controls: _mergeControls([]),
    ),
    // 23. Futuristic Clean Pod
    CamperStyle(
      id: 'futuristic_pod',
      name: 'Future Pod',
      description: 'Curved white surfaces, LED strips, spaceship.',
      moodboardImage: 'assets/style_moodboards/futuristic_clean_pod.svg',
      tags: ['Sci-fi', 'Clean', 'White'],
      controls: _mergeControls([]),
    ),
    // 24. Dark Moody Cabin
    CamperStyle(
      id: 'dark_moody',
      name: 'Dark Moody',
      description: 'Black walls, ambient light, masculine.',
      moodboardImage: 'assets/style_moodboards/dark_moody_cabin.svg',
      tags: ['Dark', 'Elegant', 'Bold'],
      controls: _mergeControls([]),
    ),
    // 25. Bright Daylight White
    CamperStyle(
      id: 'bright_daylight',
      name: 'Bright White',
      description: 'All white, max light reflection, feels huge.',
      moodboardImage: 'assets/style_moodboards/bright_daylight_white.svg',
      tags: ['Bright', 'Spacious', 'Clean'],
      controls: _mergeControls([]),
    ),
    // 26. Budget DIY Build
    CamperStyle(
      id: 'budget_diy',
      name: 'Budget DIY',
      description: 'Plywood, simple framing, exposed structure.',
      moodboardImage: 'assets/style_moodboards/budget_diy_build.svg',
      tags: ['Cheap', 'Simple', 'Honest'],
      controls: _mergeControls([]),
    ),
    // 27. Premium Custom Cabinetry
    CamperStyle(
      id: 'premium_cabinetry',
      name: 'Custom Cabinetry',
      description: 'Intricate joinery, curved wood, professional.',
      moodboardImage: 'assets/style_moodboards/premium_custom_cabinetry.svg',
      tags: ['Expensive', 'Craft', 'Detailed'],
      controls: _mergeControls([]),
    ),
    // 28. Outdoor Shower Setup
    CamperStyle(
      id: 'outdoor_shower',
      name: 'Outdoor Shower',
      description: 'Rear door shower curtain, water heater focus.',
      moodboardImage: 'assets/style_moodboards/outdoor_shower_setup.svg',
      tags: ['Summer', 'Water', 'Beach'],
      controls: _mergeControls([]),
    ),
    // 29. L-Shape Lounge Layout
    CamperStyle(
      id: 'l_shape_lounge',
      name: 'L-Shape Lounge',
      description: 'Social seating converts to bed.',
      moodboardImage: 'assets/style_moodboards/l_shape_lounge_layout.svg',
      tags: ['Social', 'Layout', 'Convertible'],
      controls: _mergeControls([]),
    ),
    // 30. U-Shape Social Layout
    CamperStyle(
      id: 'u_shape_social',
      name: 'U-Shape Social',
      description: 'Huge rear dinette for 6 people.',
      moodboardImage: 'assets/style_moodboards/u_shape_social_layout.svg',
      tags: ['Social', 'Layout', 'Huge Bed'],
      controls: _mergeControls([]),
    ),
    // Custom Advanced
    CamperStyle(
      id: 'custom_advanced',
      name: 'Custom Advanced',
      description: 'Fully custom prompt and controls.',
      moodboardImage: 'assets/style_moodboards/custom_advanced.svg',
      tags: ['Expert', 'Unlimited'],
      controls: _mergeControls([
        const StyleControl(id: 'custom_prompt', label: 'Custom Prompt', type: ControlType.text),
        const StyleControl(id: 'negative_prompt', label: 'Negative Prompt', type: ControlType.text),
        const StyleControl(id: 'strictness', label: 'Strictness', type: ControlType.slider, min: 0, max: 100, defaultDouble: 60),
      ]),
    ),
  ];
}
