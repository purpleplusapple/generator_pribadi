
enum ControlType {
  chips,
  slider,
  toggle,
  stepper,
}

class ControlSpec {
  final String id;
  final String label;
  final ControlType type;
  final List<String>? options; // For chips/toggle
  final double? min;
  final double? max;
  final double? defaultValue; // For slider/stepper

  const ControlSpec({
    required this.id,
    required this.label,
    required this.type,
    this.options,
    this.min,
    this.max,
    this.defaultValue,
  });
}

class StyleCategory {
  final String id;
  final String title;
  final String description;
  final String basePrompt;
  final List<ControlSpec> controls;

  const StyleCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.basePrompt,
    required this.controls,
  });
}

// ================== DATA ==================

const List<StyleCategory> terraceCategories = [
  // 1. Cozy Lantern Lounge
  StyleCategory(
    id: 'cozy_lantern',
    title: 'Cozy Lantern Lounge',
    description: 'Warm, intimate space with soft glowing lanterns and textiles.',
    basePrompt: 'cozy lantern lounge balcony, warm atmosphere, soft lighting',
    controls: [
      ControlSpec(id: 'lighting', label: 'Lighting Type', type: ControlType.chips, options: ['Lanterns', 'String Lights', 'Floor Lamp']),
      ControlSpec(id: 'warmth', label: 'Warmth Level', type: ControlType.slider, min: 0, max: 100, defaultValue: 70),
      ControlSpec(id: 'seating', label: 'Seating', type: ControlType.chips, options: ['Rattan Set', 'Bench', 'Floor Cushions']),
      ControlSpec(id: 'textiles', label: 'Add Textiles', type: ControlType.toggle, options: ['Rug', 'Throws', 'Curtains']),
      ControlSpec(id: 'decor', label: 'Decor', type: ControlType.chips, options: ['Candles', 'Small Table', 'Wall Art']),
    ],
  ),

  // 2. Tropical Night Garden
  StyleCategory(
    id: 'tropical_night',
    title: 'Tropical Night Garden',
    description: 'Lush greenery, exotic plants, and jungle vibes at night.',
    basePrompt: 'tropical night garden terrace, lush greenery, exotic plants',
    controls: [
      ControlSpec(id: 'greenery', label: 'Greenery Density', type: ControlType.chips, options: ['Low', 'Medium', 'Jungle']),
      ControlSpec(id: 'plant_type', label: 'Plant Type', type: ControlType.chips, options: ['Broadleaf', 'Ferns', 'Mixed']),
      ControlSpec(id: 'planter', label: 'Planter Style', type: ControlType.chips, options: ['Clay', 'Concrete', 'Hanging']),
      ControlSpec(id: 'privacy', label: 'Privacy Screen', type: ControlType.toggle, options: ['Bamboo', 'Fabric']),
      ControlSpec(id: 'light_style', label: 'Lighting Style', type: ControlType.toggle, options: ['Warm String', 'Hidden LED']),
    ],
  ),

  // 3. Modern Minimal Night
  StyleCategory(
    id: 'modern_minimal',
    title: 'Modern Minimal Night',
    description: 'Sleek lines, monochromatic palette, and uncluttered space.',
    basePrompt: 'modern minimal balcony night, sleek design, monochromatic',
    controls: [
      ControlSpec(id: 'palette', label: 'Color Palette', type: ControlType.chips, options: ['Charcoal', 'Black Wood', 'Concrete']),
      ControlSpec(id: 'furniture', label: 'Furniture', type: ControlType.chips, options: ['Modular', '2 Chairs', 'Bench']),
      ControlSpec(id: 'lines', label: 'Design Lines', type: ControlType.toggle, options: ['Clean Straight', 'Soft Rounded']),
      ControlSpec(id: 'storage', label: 'Storage', type: ControlType.toggle, options: ['Hidden', 'Open Shelves']),
      ControlSpec(id: 'clutter', label: 'Clutter Removal', type: ControlType.slider, min: 0, max: 100, defaultValue: 90),
    ],
  ),

  // 4. Rooftop Party Lights
  StyleCategory(
    id: 'rooftop_party',
    title: 'Rooftop Party Lights',
    description: 'Vibrant, energetic space perfect for social gatherings.',
    basePrompt: 'rooftop party terrace night, vibrant lighting, social layout',
    controls: [
      ControlSpec(id: 'intensity', label: 'Light Intensity', type: ControlType.slider, min: 0, max: 100, defaultValue: 60),
      ControlSpec(id: 'bar', label: 'Bar Setup', type: ControlType.chips, options: ['Mini Bar', 'Serving Cart', 'None']),
      ControlSpec(id: 'seating_count', label: 'Guest Capacity', type: ControlType.stepper, min: 2, max: 12, defaultValue: 4),
      ControlSpec(id: 'vibe', label: 'Music Vibe', type: ControlType.chips, options: ['Chill', 'DJ', 'Lounge']),
      ControlSpec(id: 'accent_color', label: 'Accent Color', type: ControlType.chips, options: ['Violet', 'Teal', 'Amber']),
    ],
  ),

  // 5. Compact Narrow Balcony
  StyleCategory(
    id: 'compact_narrow',
    title: 'Compact Narrow Balcony',
    description: 'Space-saving solutions for long, narrow urban balconies.',
    basePrompt: 'compact narrow balcony night, space saving, smart layout',
    controls: [
      ControlSpec(id: 'width', label: 'Visual Width', type: ControlType.slider, min: 0, max: 100, defaultValue: 30),
      ControlSpec(id: 'layout', label: 'Layout Strategy', type: ControlType.chips, options: ['Linear', 'Corner L', 'Foldable']),
      ControlSpec(id: 'furniture', label: 'Furniture Type', type: ControlType.chips, options: ['Foldable', 'Built-in Bench', 'Slim Bar']),
      ControlSpec(id: 'greenery', label: 'Greenery', type: ControlType.chips, options: ['Vertical Wall', 'Pots', 'Minimal']),
      ControlSpec(id: 'walkway', label: 'Keep Walkway Clear', type: ControlType.toggle, options: ['Yes', 'No']),
    ],
  ),

  // 6. Pet-Friendly Terrace
  StyleCategory(
    id: 'pet_friendly',
    title: 'Pet-Friendly Terrace',
    description: 'Safe and fun environment for your furry friends.',
    basePrompt: 'pet friendly terrace night, safe materials, durable',
    controls: [
      ControlSpec(id: 'pet_type', label: 'Pet Type', type: ControlType.chips, options: ['Cat', 'Small Dog', 'Large Dog']),
      ControlSpec(id: 'flooring', label: 'Flooring', type: ControlType.chips, options: ['Anti-slip', 'Decking', 'Tile']),
      ControlSpec(id: 'safety', label: 'Plant Safety', type: ControlType.toggle, options: ['Non-toxic Only', 'All Plants']),
      ControlSpec(id: 'play_zone', label: 'Add Play Zone', type: ControlType.toggle, options: ['Yes', 'No']),
      ControlSpec(id: 'clean', label: 'Easy Clean Level', type: ControlType.slider, min: 0, max: 100, defaultValue: 80),
    ],
  ),

  // 7. Boho Rattan Glow
  StyleCategory(
    id: 'boho_rattan',
    title: 'Boho Rattan Glow',
    description: 'Eclectic bohemian style with rattan textures and patterns.',
    basePrompt: 'boho rattan balcony night, eclectic, patterned textiles',
    controls: [
      ControlSpec(id: 'pattern', label: 'Pattern Density', type: ControlType.slider, min: 0, max: 100, defaultValue: 60),
      ControlSpec(id: 'rattan_shade', label: 'Rattan Shade', type: ControlType.chips, options: ['Light', 'Dark', 'Mixed']),
      ControlSpec(id: 'macrame', label: 'Macrame Art', type: ControlType.toggle, options: ['Yes', 'No']),
      ControlSpec(id: 'rugs', label: 'Layered Rugs', type: ControlType.toggle, options: ['Yes', 'No']),
      ControlSpec(id: 'seating', label: 'Seating', type: ControlType.chips, options: ['Peacock Chair', 'Pouf', 'Swing']),
    ],
  ),

  // 8. Japandi Outdoor Calm
  StyleCategory(
    id: 'japandi_calm',
    title: 'Japandi Outdoor Calm',
    description: 'Fusion of Japanese rustic minimalism and Scandinavian functionality.',
    basePrompt: 'japandi outdoor balcony night, wood and stone, zen',
    controls: [
      ControlSpec(id: 'wood_tone', label: 'Wood Tone', type: ControlType.chips, options: ['Light Ash', 'Warm Oak', 'Dark Walnut']),
      ControlSpec(id: 'stone', label: 'Stone Elements', type: ControlType.toggle, options: ['Pebbles', 'Pavers']),
      ControlSpec(id: 'bonsai', label: 'Bonsai/Statement Plant', type: ControlType.toggle, options: ['Yes', 'No']),
      ControlSpec(id: 'furniture', label: 'Furniture Height', type: ControlType.chips, options: ['Low Profile', 'Standard']),
      ControlSpec(id: 'harmony', label: 'Visual Harmony', type: ControlType.slider, min: 0, max: 100, defaultValue: 90),
    ],
  ),

  // 9. Mediterranean Patio Night
  StyleCategory(
    id: 'mediterranean',
    title: 'Mediterranean Patio',
    description: 'Terracotta, warm colors, and olive trees.',
    basePrompt: 'mediterranean patio night, terracotta, olive trees, warm',
    controls: [
      ControlSpec(id: 'flooring', label: 'Flooring', type: ControlType.chips, options: ['Terracotta Tile', 'Stone', 'Patterned']),
      ControlSpec(id: 'colors', label: 'Accent Colors', type: ControlType.chips, options: ['Azure Blue', 'Ochre', 'White']),
      ControlSpec(id: 'plants', label: 'Key Plants', type: ControlType.chips, options: ['Olive Tree', 'Bougainvillea', 'Herbs']),
      ControlSpec(id: 'shade', label: 'Pergola/Shade', type: ControlType.toggle, options: ['Wood Pergola', 'Fabric']),
      ControlSpec(id: 'dining', label: 'Dining Setup', type: ControlType.toggle, options: ['Large Table', 'Bistro Set']),
    ],
  ),

  // 10. Urban Industrial Terrace
  StyleCategory(
    id: 'urban_industrial',
    title: 'Urban Industrial',
    description: 'Raw materials, metal accents, and city vibes.',
    basePrompt: 'urban industrial terrace night, metal, concrete, brick',
    controls: [
      ControlSpec(id: 'metal', label: 'Metal Finish', type: ControlType.chips, options: ['Black Matte', 'Rust', 'Brushed']),
      ControlSpec(id: 'walls', label: 'Wall Texture', type: ControlType.chips, options: ['Exposed Brick', 'Concrete', 'Wood']),
      ControlSpec(id: 'lights', label: 'Lighting', type: ControlType.chips, options: ['Edison Bulbs', 'Industrial Pendant', 'Spotlights']),
      ControlSpec(id: 'greenery', label: 'Soften Edges', type: ControlType.slider, min: 0, max: 100, defaultValue: 30),
      ControlSpec(id: 'seating', label: 'Seating', type: ControlType.chips, options: ['Metal Chairs', 'Pallet Sofa', 'Leather']),
    ],
  ),

  // 11. Zen Garden Balcony
  StyleCategory(
    id: 'zen_garden',
    title: 'Zen Garden Balcony',
    description: 'Peaceful rock garden elements and water features.',
    basePrompt: 'zen garden balcony night, rocks, sand, water feature',
    controls: [
      ControlSpec(id: 'ground', label: 'Ground Cover', type: ControlType.chips, options: ['Sand', 'Gravel', 'Moss']),
      ControlSpec(id: 'water', label: 'Water Feature', type: ControlType.toggle, options: ['Fountain', 'Bird Bath', 'None']),
      ControlSpec(id: 'rocks', label: 'Rock Placement', type: ControlType.slider, min: 0, max: 100, defaultValue: 50),
      ControlSpec(id: 'bamboo', label: 'Bamboo Elements', type: ControlType.toggle, options: ['Fence', 'Planter']),
      ControlSpec(id: 'lantern', label: 'Stone Lantern', type: ControlType.toggle, options: ['Yes', 'No']),
    ],
  ),

  // 12. Scandinavian Outdoor Soft
  StyleCategory(
    id: 'scandi_soft',
    title: 'Scandinavian Soft',
    description: 'Hygge vibes, soft textures, and light woods.',
    basePrompt: 'scandinavian outdoor balcony night, hygge, cozy, light wood',
    controls: [
      ControlSpec(id: 'hygge', label: 'Hygge Factor', type: ControlType.slider, min: 0, max: 100, defaultValue: 80),
      ControlSpec(id: 'blankets', label: 'Blankets', type: ControlType.chips, options: ['Chunky Knit', 'Fleece', 'Wool']),
      ControlSpec(id: 'palette', label: 'Palette', type: ControlType.chips, options: ['White/Grey', 'Pastel', 'Nature']),
      ControlSpec(id: 'furniture', label: 'Furniture Shape', type: ControlType.chips, options: ['Organic', 'Functional']),
      ControlSpec(id: 'candles', label: 'Candlelight', type: ControlType.toggle, options: ['Lots', 'Minimal']),
    ],
  ),

  // 13. Romantic Candle Terrace
  StyleCategory(
    id: 'romantic_candle',
    title: 'Romantic Candle Terrace',
    description: 'Intimate setting with abundant candlelight and roses.',
    basePrompt: 'romantic terrace night, candlelight, roses, intimate',
    controls: [
      ControlSpec(id: 'candles', label: 'Candle Amount', type: ControlType.slider, min: 0, max: 100, defaultValue: 90),
      ControlSpec(id: 'flowers', label: 'Flowers', type: ControlType.chips, options: ['Roses', 'Jasmine', 'Mixed']),
      ControlSpec(id: 'dining', label: 'Dinner for Two', type: ControlType.toggle, options: ['Yes', 'No']),
      ControlSpec(id: 'drapes', label: 'Privacy Drapes', type: ControlType.toggle, options: ['Sheer', 'Velvet']),
      ControlSpec(id: 'music', label: 'Ambiance', type: ControlType.chips, options: ['Soft Jazz', 'Classical', 'Silence']),
    ],
  ),

  // 14. BBQ Social Corner
  StyleCategory(
    id: 'bbq_social',
    title: 'BBQ Social Corner',
    description: 'Focused on grilling and dining with friends.',
    basePrompt: 'bbq terrace night, grill station, dining table, social',
    controls: [
      ControlSpec(id: 'grill', label: 'Grill Type', type: ControlType.chips, options: ['Built-in', 'Portable', 'Egg']),
      ControlSpec(id: 'table', label: 'Dining Table', type: ControlType.chips, options: ['Long Wooden', 'Round', 'Bar']),
      ControlSpec(id: 'seating', label: 'Seats', type: ControlType.stepper, min: 2, max: 10, defaultValue: 6),
      ControlSpec(id: 'lighting', label: 'Task Lighting', type: ControlType.toggle, options: ['Yes', 'No']),
      ControlSpec(id: 'prep', label: 'Prep Station', type: ControlType.toggle, options: ['Yes', 'No']),
    ],
  ),

  // 15. Luxury Hotel Terrace
  StyleCategory(
    id: 'luxury_hotel',
    title: 'Luxury Hotel Terrace',
    description: 'High-end furniture, sleek glass, and premium finishes.',
    basePrompt: 'luxury hotel terrace night, premium furniture, glass railing',
    controls: [
      ControlSpec(id: 'finish', label: 'Finishes', type: ControlType.chips, options: ['Marble', 'Teak', 'Gold Accent']),
      ControlSpec(id: 'lounge', label: 'Lounge Type', type: ControlType.chips, options: ['Daybed', 'Chaise', 'Sectional']),
      ControlSpec(id: 'fire', label: 'Fire Pit', type: ControlType.toggle, options: ['Modern Gas', 'Tabletop', 'None']),
      ControlSpec(id: 'glass', label: 'Glass Elements', type: ControlType.slider, min: 0, max: 100, defaultValue: 70),
      ControlSpec(id: 'service', label: 'Service Cart', type: ControlType.toggle, options: ['Yes', 'No']),
    ],
  ),

  // 16. Plant Jungle Max
  StyleCategory(
    id: 'plant_jungle',
    title: 'Plant Jungle Max',
    description: 'Overgrown, immersive botanical experience.',
    basePrompt: 'plant jungle balcony night, overgrown, dense foliage',
    controls: [
      ControlSpec(id: 'density', label: 'Plant Density', type: ControlType.slider, min: 50, max: 100, defaultValue: 100),
      ControlSpec(id: 'vertical', label: 'Vertical Garden', type: ControlType.toggle, options: ['Yes', 'No']),
      ControlSpec(id: 'ceiling', label: 'Hanging Plants', type: ControlType.toggle, options: ['Yes', 'No']),
      ControlSpec(id: 'path', label: 'Path Type', type: ControlType.chips, options: ['Stepping Stones', 'Hidden', 'Wood']),
      ControlSpec(id: 'mist', label: 'Misting System', type: ControlType.toggle, options: ['Visible', 'Hidden']),
    ],
  ),

  // 17. Kids-Safe Terrace
  StyleCategory(
    id: 'kids_safe',
    title: 'Kids-Safe Terrace',
    description: 'Playful, secure, and family-friendly.',
    basePrompt: 'kids safe terrace night, playful, secure railing, soft floor',
    controls: [
      ControlSpec(id: 'railing', label: 'Railing Safety', type: ControlType.toggle, options: ['Mesh', 'Plexiglass']),
      ControlSpec(id: 'floor', label: 'Soft Flooring', type: ControlType.chips, options: ['Rubber Tiles', 'Outdoor Rug', 'Grass']),
      ControlSpec(id: 'toys', label: 'Toy Storage', type: ControlType.toggle, options: ['Bench Box', 'Shelves']),
      ControlSpec(id: 'colors', label: 'Color Pop', type: ControlType.slider, min: 0, max: 100, defaultValue: 60),
      ControlSpec(id: 'activity', label: 'Activity Corner', type: ControlType.chips, options: ['Chalkboard', 'Tent', 'Table']),
    ],
  ),

  // 18. Rainy Season Cozy
  StyleCategory(
    id: 'rainy_cozy',
    title: 'Rainy Season Cozy',
    description: 'Covered, warm, and perfect for watching the rain.',
    basePrompt: 'rainy season balcony night, covered, wet floor reflection',
    controls: [
      ControlSpec(id: 'cover', label: 'Coverage', type: ControlType.chips, options: ['Full Roof', 'Retractable Awning', 'Umbrella']),
      ControlSpec(id: 'heater', label: 'Patio Heater', type: ControlType.toggle, options: ['Standing', 'Tabletop', 'None']),
      ControlSpec(id: 'glass', label: 'Glass Enclosure', type: ControlType.toggle, options: ['Yes', 'No']),
      ControlSpec(id: 'mood', label: 'Rain Mood', type: ControlType.chips, options: ['Stormy', 'Drizzle', 'After Rain']),
      ControlSpec(id: 'beverage', label: 'Warm Drink Spot', type: ControlType.toggle, options: ['Yes', 'No']),
    ],
  ),
];
