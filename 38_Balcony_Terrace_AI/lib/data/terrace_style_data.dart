// lib/data/terrace_style_data.dart

class TerraceControl {
  final String id;
  final String label;
  final String type; // chip, slider, toggle, stepper, note
  final List<String>? options; // For chips
  final double? min;
  final double? max;
  final String? defaultValue; // Store as string for flexibility

  const TerraceControl({
    required this.id,
    required this.label,
    required this.type,
    this.options,
    this.min,
    this.max,
    this.defaultValue,
  });
}

class TerraceStyleCategory {
  final String id;
  final String title;
  final String description;
  final List<TerraceControl> controls;
  final String basePrompt;

  const TerraceStyleCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.controls,
    required this.basePrompt,
  });
}

final List<TerraceStyleCategory> terraceCategories = [
  // 1. Cozy Lantern Lounge
  TerraceStyleCategory(
    id: 'cozy_lantern',
    title: 'Cozy Lantern Lounge',
    description: 'Warm, intimate space with soft glowing lanterns and comfortable seating.',
    basePrompt: 'cozy night balcony with warm lantern lighting, intimate atmosphere',
    controls: [
      TerraceControl(id: 'lighting', label: 'Lighting Style', type: 'chip', options: ['Lanterns', 'String Lights', 'Floor Lamps'], defaultValue: 'Lanterns'),
      TerraceControl(id: 'warmth', label: 'Warmth Level', type: 'slider', min: 0, max: 100, defaultValue: '70'),
      TerraceControl(id: 'seating', label: 'Seating', type: 'chip', options: ['Rattan Set', 'Bench', 'Floor Cushions'], defaultValue: 'Rattan Set'),
      TerraceControl(id: 'textiles', label: 'Textiles', type: 'chip', options: ['Rug', 'Throws', 'Linen'], defaultValue: 'Rug'),
      TerraceControl(id: 'decor', label: 'Decor', type: 'chip', options: ['Candles', 'Small Table', 'Wall Art'], defaultValue: 'Candles'),
      TerraceControl(id: 'note', label: 'Notes', type: 'note'),
    ],
  ),

  // 2. Tropical Night Garden
  TerraceStyleCategory(
    id: 'tropical_night',
    title: 'Tropical Night Garden',
    description: 'Lush greenery, exotic plants, and a jungle vibe under the stars.',
    basePrompt: 'tropical night garden balcony, lush greenery, exotic plants',
    controls: [
      TerraceControl(id: 'greenery', label: 'Greenery Level', type: 'chip', options: ['Low', 'Medium', 'Jungle'], defaultValue: 'Jungle'),
      TerraceControl(id: 'plant_type', label: 'Plant Type', type: 'chip', options: ['Broadleaf', 'Fern', 'Mixed'], defaultValue: 'Mixed'),
      TerraceControl(id: 'planter', label: 'Planter Style', type: 'chip', options: ['Clay', 'Concrete', 'Hanging'], defaultValue: 'Clay'),
      TerraceControl(id: 'privacy', label: 'Privacy', type: 'chip', options: ['Bamboo', 'Fabric', 'None'], defaultValue: 'Bamboo'),
      TerraceControl(id: 'lighting', label: 'Lighting', type: 'toggle', defaultValue: 'true'), // Warm string
      TerraceControl(id: 'note', label: 'Notes', type: 'note'),
    ],
  ),

  // 3. Modern Minimal Night
  TerraceStyleCategory(
    id: 'modern_minimal',
    title: 'Modern Minimal Night',
    description: 'Sleek lines, monochromatic palette, and uncluttered design.',
    basePrompt: 'modern minimal night terrace, sleek design, monochromatic',
    controls: [
      TerraceControl(id: 'palette', label: 'Palette', type: 'chip', options: ['Charcoal', 'Black Wood', 'Concrete'], defaultValue: 'Charcoal'),
      TerraceControl(id: 'furniture', label: 'Furniture', type: 'chip', options: ['Modular', '2 Chairs', 'Bench'], defaultValue: 'Modular'),
      TerraceControl(id: 'lines', label: 'Lines', type: 'chip', options: ['Clean', 'Rounded'], defaultValue: 'Clean'),
      TerraceControl(id: 'clutter', label: 'Clutter/Items', type: 'slider', min: 0, max: 50, defaultValue: '10'),
      TerraceControl(id: 'lighting', label: 'Lighting', type: 'chip', options: ['Track', 'Spot', 'LED Strip'], defaultValue: 'LED Strip'),
      TerraceControl(id: 'note', label: 'Notes', type: 'note'),
    ],
  ),

  // 4. Rooftop Party Lights
  TerraceStyleCategory(
    id: 'rooftop_party',
    title: 'Rooftop Party Lights',
    description: 'Vibrant, energetic space perfect for entertaining guests.',
    basePrompt: 'rooftop party terrace, vibrant lighting, entertainment space',
    controls: [
      TerraceControl(id: 'intensity', label: 'Light Intensity', type: 'slider', min: 0, max: 100, defaultValue: '60'),
      TerraceControl(id: 'bar', label: 'Bar Setup', type: 'chip', options: ['Mini Bar', 'Serving Cart', 'None'], defaultValue: 'Mini Bar'),
      TerraceControl(id: 'seating_count', label: 'Guests', type: 'stepper', min: 2, max: 12, defaultValue: '4'),
      TerraceControl(id: 'vibe', label: 'Music Vibe', type: 'chip', options: ['Chill', 'DJ', 'Lounge'], defaultValue: 'Lounge'),
      TerraceControl(id: 'accent', label: 'Accent Color', type: 'chip', options: ['Violet', 'Teal', 'Amber'], defaultValue: 'Violet'),
      TerraceControl(id: 'note', label: 'Notes', type: 'note'),
    ],
  ),

  // 5. Compact Narrow Balcony Hack
  TerraceStyleCategory(
    id: 'narrow_hack',
    title: 'Compact Narrow Hack',
    description: 'Clever solutions for tight spaces, maximizing utility and style.',
    basePrompt: 'narrow balcony makeover, space saving, clever design',
    controls: [
      TerraceControl(id: 'width', label: 'Width Perception', type: 'slider', min: 0, max: 100, defaultValue: '50'),
      TerraceControl(id: 'layout', label: 'Layout', type: 'chip', options: ['Linear', 'Corner L', 'Foldable'], defaultValue: 'Linear'),
      TerraceControl(id: 'furniture', label: 'Furniture', type: 'chip', options: ['Foldable', 'Built-in', 'Slim Bar'], defaultValue: 'Foldable'),
      TerraceControl(id: 'storage', label: 'Storage', type: 'chip', options: ['Vertical', 'Under-seat'], defaultValue: 'Vertical'),
      TerraceControl(id: 'walkway', label: 'Clear Walkway', type: 'toggle', defaultValue: 'true'),
      TerraceControl(id: 'note', label: 'Notes', type: 'note'),
    ],
  ),

  // 6. Pet-Friendly Terrace
  TerraceStyleCategory(
    id: 'pet_friendly',
    title: 'Pet-Friendly Terrace',
    description: 'Safe and fun environment for your furry friends.',
    basePrompt: 'pet friendly terrace, safe materials, play area',
    controls: [
      TerraceControl(id: 'pet', label: 'Pet Type', type: 'chip', options: ['Cat', 'Small Dog', 'Large Dog'], defaultValue: 'Cat'),
      TerraceControl(id: 'flooring', label: 'Flooring', type: 'chip', options: ['Anti-slip', 'Deck', 'Tile'], defaultValue: 'Anti-slip'),
      TerraceControl(id: 'safety', label: 'Plant Safety', type: 'toggle', defaultValue: 'true'),
      TerraceControl(id: 'play', label: 'Play Zone', type: 'toggle', defaultValue: 'true'),
      TerraceControl(id: 'fence', label: 'Safety Mesh', type: 'toggle', defaultValue: 'true'),
      TerraceControl(id: 'note', label: 'Notes', type: 'note'),
    ],
  ),

  // 7. Boho Rattan Glow
  TerraceStyleCategory(
    id: 'boho_rattan',
    title: 'Boho Rattan Glow',
    description: 'Eclectic bohemian style with rattan furniture and patterned textiles.',
    basePrompt: 'boho rattan balcony, eclectic style, patterned textiles',
    controls: [
      TerraceControl(id: 'texture', label: 'Texture Load', type: 'slider', min: 0, max: 100, defaultValue: '80'),
      TerraceControl(id: 'rattan_color', label: 'Rattan Shade', type: 'chip', options: ['Natural', 'Dark', 'White'], defaultValue: 'Natural'),
      TerraceControl(id: 'plants', label: 'Hanging Plants', type: 'chip', options: ['Many', 'Few', 'None'], defaultValue: 'Many'),
      TerraceControl(id: 'lighting', label: 'Lighting', type: 'chip', options: ['Fairy Lights', 'Lanterns'], defaultValue: 'Fairy Lights'),
      TerraceControl(id: 'note', label: 'Notes', type: 'note'),
    ],
  ),

  // 8. Japandi Outdoor Calm
  TerraceStyleCategory(
    id: 'japandi_calm',
    title: 'Japandi Outdoor Calm',
    description: 'Blend of Japanese minimalism and Scandinavian functionality.',
    basePrompt: 'japandi outdoor terrace, wood and stone, zen atmosphere',
    controls: [
      TerraceControl(id: 'wood_tone', label: 'Wood Tone', type: 'chip', options: ['Light Oak', 'Walnut', 'Cedar'], defaultValue: 'Light Oak'),
      TerraceControl(id: 'stone', label: 'Stone Elements', type: 'toggle', defaultValue: 'true'),
      TerraceControl(id: 'plants', label: 'Plant Style', type: 'chip', options: ['Bonsai', 'Bamboo', 'Minimal'], defaultValue: 'Bamboo'),
      TerraceControl(id: 'furniture', label: 'Furniture Low', type: 'toggle', defaultValue: 'true'),
      TerraceControl(id: 'note', label: 'Notes', type: 'note'),
    ],
  ),

  // 9. Mediterranean Patio Night
  TerraceStyleCategory(
    id: 'mediterranean_patio',
    title: 'Mediterranean Patio',
    description: 'Warm colors, terracotta tiles, and a relaxed southern European vibe.',
    basePrompt: 'mediterranean patio night, terracotta, warm colors',
    controls: [
      TerraceControl(id: 'tile', label: 'Tile Pattern', type: 'chip', options: ['Terracotta', 'Mosaic', 'Stone'], defaultValue: 'Terracotta'),
      TerraceControl(id: 'colors', label: 'Accents', type: 'chip', options: ['Blue', 'Ochre', 'Olive'], defaultValue: 'Blue'),
      TerraceControl(id: 'plants', label: 'Plants', type: 'chip', options: ['Citrus', 'Olive Tree', 'Herbs'], defaultValue: 'Olive Tree'),
      TerraceControl(id: 'shade', label: 'Pergola', type: 'toggle', defaultValue: 'true'),
      TerraceControl(id: 'note', label: 'Notes', type: 'note'),
    ],
  ),

  // 10. Urban Industrial Terrace
  TerraceStyleCategory(
    id: 'urban_industrial',
    title: 'Urban Industrial',
    description: 'Raw materials, metal accents, and a city-ready look.',
    basePrompt: 'urban industrial terrace, metal and concrete, raw look',
    controls: [
      TerraceControl(id: 'metal', label: 'Metal Finish', type: 'chip', options: ['Black', 'Rust', 'Brushed'], defaultValue: 'Black'),
      TerraceControl(id: 'concrete', label: 'Concrete', type: 'slider', min: 0, max: 100, defaultValue: '60'),
      TerraceControl(id: 'lighting', label: 'Lighting', type: 'chip', options: ['Edison Bulb', 'Neon', 'Spot'], defaultValue: 'Edison Bulb'),
      TerraceControl(id: 'furniture', label: 'Furniture', type: 'chip', options: ['Pallet', 'Metal', 'Leather'], defaultValue: 'Metal'),
      TerraceControl(id: 'note', label: 'Notes', type: 'note'),
    ],
  ),

  // 11. Zen Garden Balcony
  TerraceStyleCategory(
    id: 'zen_garden',
    title: 'Zen Garden',
    description: 'Peaceful sanctuary with rocks, sand, and water features.',
    basePrompt: 'zen garden balcony, peaceful, rocks and sand',
    controls: [
      TerraceControl(id: 'elements', label: 'Elements', type: 'chip', options: ['Rocks', 'Sand', 'Water'], defaultValue: 'Rocks'),
      TerraceControl(id: 'plants', label: 'Greenery', type: 'chip', options: ['Moss', 'Bamboo', 'Maple'], defaultValue: 'Moss'),
      TerraceControl(id: 'flooring', label: 'Flooring', type: 'chip', options: ['Wood Deck', 'Gravel', 'Tatami'], defaultValue: 'Gravel'),
      TerraceControl(id: 'lighting', label: 'Lighting', type: 'chip', options: ['Low', 'Hidden', 'Paper Lantern'], defaultValue: 'Hidden'),
      TerraceControl(id: 'note', label: 'Notes', type: 'note'),
    ],
  ),

  // 12. Scandinavian Outdoor Soft
  TerraceStyleCategory(
    id: 'scandi_soft',
    title: 'Scandinavian Soft',
    description: 'Hygge atmosphere with soft textiles and light wood.',
    basePrompt: 'scandinavian outdoor balcony, hygge, soft textiles',
    controls: [
      TerraceControl(id: 'textiles', label: 'Textiles', type: 'slider', min: 0, max: 100, defaultValue: '80'),
      TerraceControl(id: 'wood', label: 'Wood', type: 'chip', options: ['Light', 'White', 'Grey'], defaultValue: 'Light'),
      TerraceControl(id: 'colors', label: 'Palette', type: 'chip', options: ['White/Grey', 'Pastel', 'Monochrome'], defaultValue: 'White/Grey'),
      TerraceControl(id: 'lighting', label: 'Lighting', type: 'chip', options: ['Candles', 'String', 'Bulb'], defaultValue: 'Candles'),
      TerraceControl(id: 'note', label: 'Notes', type: 'note'),
    ],
  ),

  // 13. Romantic Candle Terrace
  TerraceStyleCategory(
    id: 'romantic_candle',
    title: 'Romantic Candle',
    description: 'Dreamy setting with hundreds of candles and soft drapes.',
    basePrompt: 'romantic candle terrace, dreamy, soft lighting',
    controls: [
      TerraceControl(id: 'candles', label: 'Candle Count', type: 'slider', min: 0, max: 100, defaultValue: '80'),
      TerraceControl(id: 'drapes', label: 'Drapes', type: 'chip', options: ['Sheer White', 'Velvet', 'None'], defaultValue: 'Sheer White'),
      TerraceControl(id: 'seating', label: 'Seating', type: 'chip', options: ['Loveseat', 'Floor', 'Bistro'], defaultValue: 'Loveseat'),
      TerraceControl(id: 'flowers', label: 'Flowers', type: 'chip', options: ['Roses', 'Dried', 'Wild'], defaultValue: 'Roses'),
      TerraceControl(id: 'note', label: 'Notes', type: 'note'),
    ],
  ),

  // 14. BBQ Social Corner
  TerraceStyleCategory(
    id: 'bbq_social',
    title: 'BBQ Social Corner',
    description: 'Functional cooking and dining space for outdoor meals.',
    basePrompt: 'bbq social terrace, dining area, grill station',
    controls: [
      TerraceControl(id: 'grill', label: 'Grill Type', type: 'chip', options: ['Gas', 'Charcoal', 'Electric'], defaultValue: 'Gas'),
      TerraceControl(id: 'dining', label: 'Table Size', type: 'chip', options: ['4-Seater', '6-Seater', 'Bar'], defaultValue: '4-Seater'),
      TerraceControl(id: 'shade', label: 'Shade', type: 'chip', options: ['Umbrella', 'Awning', 'None'], defaultValue: 'Umbrella'),
      TerraceControl(id: 'lighting', label: 'Task Light', type: 'toggle', defaultValue: 'true'),
      TerraceControl(id: 'note', label: 'Notes', type: 'note'),
    ],
  ),

  // 15. Luxury Hotel Terrace
  TerraceStyleCategory(
    id: 'luxury_hotel',
    title: 'Luxury Hotel',
    description: 'High-end resort feel with premium materials and lighting.',
    basePrompt: 'luxury hotel terrace, resort style, premium materials',
    controls: [
      TerraceControl(id: 'vibe', label: 'Resort Type', type: 'chip', options: ['Bali', 'Miami', 'Santorini'], defaultValue: 'Bali'),
      TerraceControl(id: 'lounger', label: 'Loungers', type: 'stepper', min: 0, max: 4, defaultValue: '2'),
      TerraceControl(id: 'pool', label: 'Water Feature', type: 'toggle', defaultValue: 'false'),
      TerraceControl(id: 'lighting', label: 'Uplighting', type: 'toggle', defaultValue: 'true'),
      TerraceControl(id: 'note', label: 'Notes', type: 'note'),
    ],
  ),

  // 16. Plant Jungle Max
  TerraceStyleCategory(
    id: 'plant_jungle',
    title: 'Plant Jungle Max',
    description: 'Maximum greenery for the urban gardener.',
    basePrompt: 'plant jungle balcony, overgrown, botanical garden',
    controls: [
      TerraceControl(id: 'density', label: 'Density', type: 'slider', min: 50, max: 100, defaultValue: '90'),
      TerraceControl(id: 'layers', label: 'Layers', type: 'chip', options: ['Floor', 'Wall', 'Ceiling', 'All'], defaultValue: 'All'),
      TerraceControl(id: 'path', label: 'Path', type: 'chip', options: ['Stepping Stones', 'Wood', 'Dirt'], defaultValue: 'Stepping Stones'),
      TerraceControl(id: 'seating', label: 'Hidden Seat', type: 'toggle', defaultValue: 'true'),
      TerraceControl(id: 'note', label: 'Notes', type: 'note'),
    ],
  ),

  // 17. Kids-Safe Terrace
  TerraceStyleCategory(
    id: 'kids_safe',
    title: 'Kids-Safe Terrace',
    description: 'Secure and playful area designed for children.',
    basePrompt: 'kids safe terrace, playful, colorful accents',
    controls: [
      TerraceControl(id: 'safety', label: 'Safety Net', type: 'toggle', defaultValue: 'true'),
      TerraceControl(id: 'floor', label: 'Soft Floor', type: 'chip', options: ['Foam', 'Rubber', 'Grass'], defaultValue: 'Foam'),
      TerraceControl(id: 'play', label: 'Toy Storage', type: 'chip', options: ['Bin', 'Bench', 'Wall'], defaultValue: 'Bin'),
      TerraceControl(id: 'colors', label: 'Colors', type: 'chip', options: ['Primary', 'Pastel', 'Nature'], defaultValue: 'Pastel'),
      TerraceControl(id: 'note', label: 'Notes', type: 'note'),
    ],
  ),

  // 18. Rainy Season Cozy
  TerraceStyleCategory(
    id: 'rainy_cozy',
    title: 'Rainy Season Cozy',
    description: 'Sheltered space to enjoy the rain comfortably.',
    basePrompt: 'rainy season terrace, sheltered, cozy reading nook',
    controls: [
      TerraceControl(id: 'cover', label: 'Cover Type', type: 'chip', options: ['Glass', 'Canvas', 'Roof'], defaultValue: 'Glass'),
      TerraceControl(id: 'warmth', label: 'Heater', type: 'toggle', defaultValue: 'true'),
      TerraceControl(id: 'seating', label: 'Dry Seating', type: 'chip', options: ['Deep Armchair', 'Sofa', 'Swing'], defaultValue: 'Deep Armchair'),
      TerraceControl(id: 'vibe', label: 'Mood', type: 'chip', options: ['Melancholy', 'Bright', 'Warm'], defaultValue: 'Warm'),
      TerraceControl(id: 'note', label: 'Notes', type: 'note'),
    ],
  ),

  // Custom Advanced
  TerraceStyleCategory(
    id: 'custom_advanced',
    title: 'Custom Advanced',
    description: 'Full control over the prompt and design parameters.',
    basePrompt: '',
    controls: [
      TerraceControl(id: 'prompt', label: 'Your Vision', type: 'note', defaultValue: ''),
      TerraceControl(id: 'negative', label: 'Avoid (Negative)', type: 'note', defaultValue: ''),
      TerraceControl(id: 'strictness', label: 'Adherence', type: 'slider', min: 0, max: 100, defaultValue: '60'),
      TerraceControl(id: 'materials', label: 'Materials', type: 'chip', options: ['Wood', 'Stone', 'Metal', 'Glass'], defaultValue: 'Wood'),
      TerraceControl(id: 'lighting', label: 'Lighting', type: 'chip', options: ['Warm', 'Cool', 'Neon', 'Dark'], defaultValue: 'Warm'),
    ],
  ),
];
