// lib/data/guest_styles.dart
import '../model/guest_style_definition.dart';

// Common Controls
final _commonControls = [
  const StyleControl(id: 'room_size', label: 'Room Size', type: ControlType.chips, defaultValue: 'Medium', options: ['Small', 'Medium', 'Large']),
  const StyleControl(id: 'bed_type', label: 'Bed Type', type: ControlType.chips, defaultValue: 'Queen', options: ['Single', 'Queen', 'King', 'Sofa Bed', 'Daybed']),
  const StyleControl(id: 'bedding_tone', label: 'Bedding Tone', type: ControlType.chips, defaultValue: 'Crisp White', options: ['Crisp White', 'Warm Neutral', 'Patterned', 'Dark']),
  const StyleControl(id: 'lighting_warmth', label: 'Lighting Warmth', type: ControlType.slider, defaultValue: 65.0, min: 0, max: 100),
  const StyleControl(id: 'storage_amt', label: 'Storage', type: ControlType.chips, defaultValue: 'Medium', options: ['Minimal', 'Medium', 'Max']),
  const StyleControl(id: 'essentials', label: 'Guest Essentials', type: ControlType.chips, defaultValue: 'Towels', options: ['Towels', 'Luggage Rack', 'Charging Stn', 'Water']),
  const StyleControl(id: 'decor_level', label: 'Decor Level', type: ControlType.slider, defaultValue: 50.0, min: 0, max: 100),
  const StyleControl(id: 'user_note', label: 'Special Note', type: ControlType.text, defaultValue: ''),
];

List<String> _getTiles(int index) {
  // Rotate through 14 images to get 4 distinct ones
  final totalAssets = 14;
  return List.generate(4, (i) {
    final imgIndex = ((index * 4 + i) % totalAssets) + 1;
    return 'assets/examples/guest_example_$imgIndex.jpg';
  });
}

List<GuestStyleDefinition> getGuestStyles() {
  final styles = <GuestStyleDefinition>[
    // 1. Boutique Hotel Cozy
    GuestStyleDefinition(
      id: 'boutique_cozy',
      name: 'Boutique Hotel Cozy',
      description: 'Intimate, warm, and highly textured.',
      tileImages: _getTiles(0),
      tags: ['Luxury', 'Warm', 'Texture'],
      basePrompt: 'boutique hotel room, cozy atmosphere, layered textiles, warm brass accents',
      controls: [
        ..._commonControls,
        const StyleControl(id: 'accent_material', label: 'Accent Material', type: ControlType.chips, defaultValue: 'Brass', options: ['Brass', 'Wood', 'Chrome']),
        const StyleControl(id: 'layered_textiles', label: 'Layered Textiles', type: ControlType.toggle, defaultValue: true),
      ],
    ),
    // 2. Modern Minimal Guest
    GuestStyleDefinition(
      id: 'modern_minimal',
      name: 'Modern Minimal Guest',
      description: 'Clean lines, uncluttered, functional.',
      tileImages: _getTiles(1),
      tags: ['Clean', 'Minimal', 'Functional'],
      basePrompt: 'modern minimalist guest room, clean lines, sleek furniture, uncluttered',
      controls: _commonControls,
    ),
    // 3. Scandinavian Light
    GuestStyleDefinition(
      id: 'scandi_light',
      name: 'Scandinavian Light',
      description: 'Bright, airy, pale woods, hygge.',
      tileImages: _getTiles(2),
      tags: ['Bright', 'Wood', 'Hygge'],
      basePrompt: 'scandinavian style bedroom, light oak wood, bright airy, white walls',
      controls: _commonControls,
    ),
    // 4. Japandi Calm
    GuestStyleDefinition(
      id: 'japandi_calm',
      name: 'Japandi Calm',
      description: 'Fusion of Japanese rustic and Scandi functionality.',
      tileImages: _getTiles(3),
      tags: ['Zen', 'Rustic', 'Balance'],
      basePrompt: 'japandi interior, low platform bed, natural materials, beige and grey tones',
      controls: _commonControls,
    ),
    // 5. Warm Wood Suite
    GuestStyleDefinition(
      id: 'warm_wood',
      name: 'Warm Wood Suite',
      description: 'Rich timber tones, inviting and classic.',
      tileImages: _getTiles(4),
      tags: ['Classic', 'Wood', 'Rich'],
      basePrompt: 'warm wood paneled guest room, walnut furniture, rich textures',
      controls: _commonControls,
    ),
    // 6. Classic Elegant
    GuestStyleDefinition(
      id: 'classic_elegant',
      name: 'Classic Elegant',
      description: 'Timeless traditional moulding and symmetry.',
      tileImages: _getTiles(5),
      tags: ['Traditional', 'Symmetry', 'Formal'],
      basePrompt: 'classic elegant bedroom, wall mouldings, traditional furniture, symmetry',
      controls: _commonControls,
    ),
    // 7. Coastal Breeze
    GuestStyleDefinition(
      id: 'coastal_breeze',
      name: 'Coastal Breeze',
      description: 'Light blues, linens, beach house vibe.',
      tileImages: _getTiles(6),
      tags: ['Blue', 'Airy', 'Relaxed'],
      basePrompt: 'coastal guest bedroom, soft blue accents, linen textures, airy window',
      controls: _commonControls,
    ),
    // 8. Farmhouse Comfort
    GuestStyleDefinition(
      id: 'farmhouse_comfort',
      name: 'Farmhouse Comfort',
      description: 'Rustic beams, shiplap, cozy plaids.',
      tileImages: _getTiles(7),
      tags: ['Rustic', 'Cozy', 'Country'],
      basePrompt: 'modern farmhouse bedroom, shiplap walls, rustic wood beams, cozy plaid',
      controls: _commonControls,
    ),
    // 9. Mid-Century Guest
    GuestStyleDefinition(
      id: 'mid_century',
      name: 'Mid-Century Guest',
      description: 'Retro vibes, tapered legs, bold geometric art.',
      tileImages: _getTiles(8),
      tags: ['Retro', 'Geometric', 'Vintage'],
      basePrompt: 'mid-century modern bedroom, teak furniture, tapered legs, geometric art',
      controls: _commonControls,
    ),
    // 10. Industrial Soft
    GuestStyleDefinition(
      id: 'industrial_soft',
      name: 'Industrial Soft',
      description: 'Exposed elements softened with textiles.',
      tileImages: _getTiles(9),
      tags: ['Urban', 'Metal', 'Loft'],
      basePrompt: 'soft industrial bedroom, black metal frame bed, brick wall, soft bedding',
      controls: _commonControls,
    ),
    // 11. Parisian Chic
    GuestStyleDefinition(
      id: 'parisian_chic',
      name: 'Parisian Chic',
      description: 'Ornate mirrors, white walls, herringbone floor.',
      tileImages: _getTiles(10),
      tags: ['Romance', 'City', 'Elegant'],
      basePrompt: 'parisian apartment bedroom, herringbone floor, ornate mirror, white walls',
      controls: _commonControls,
    ),
    // 12. Korean Clean
    GuestStyleDefinition(
      id: 'korean_clean',
      name: 'Korean Clean',
      description: 'Ultra-organized, soft pastel, floor seating options.',
      tileImages: _getTiles(11),
      tags: ['Organized', 'Pastel', 'Soft'],
      basePrompt: 'korean aesthetic bedroom, minimal organization, soft pastel tones, clean',
      controls: _commonControls,
    ),
    // 13. Dark Accent Luxury
    GuestStyleDefinition(
      id: 'dark_accent',
      name: 'Dark Accent Luxury',
      description: 'Light base with dramatic dark walls or bedding.',
      tileImages: _getTiles(12),
      tags: ['Contrast', 'Drama', 'Bold'],
      basePrompt: 'luxury bedroom, high contrast, dark accent wall, gold details',
      controls: _commonControls,
    ),
    // 14. Boho Warmth
    GuestStyleDefinition(
      id: 'boho_warmth',
      name: 'Boho Warmth',
      description: 'Plants, rattan, macrame, earthy.',
      tileImages: _getTiles(13),
      tags: ['Plants', 'Earthy', 'Relaxed'],
      basePrompt: 'boho chic guest room, rattan furniture, plants, macrame, earthy tones',
      controls: _commonControls,
    ),
    // 15. Neutral Linen
    GuestStyleDefinition(
      id: 'neutral_linen',
      name: 'Neutral Linen Serenity',
      description: 'Monochromatic beiges and creams.',
      tileImages: _getTiles(14),
      tags: ['Calm', 'Monochrome', 'Soft'],
      basePrompt: 'neutral serenity bedroom, linen fabrics, beige and cream palette',
      controls: _commonControls,
    ),
    // 16. Tropical Subtle
    GuestStyleDefinition(
      id: 'tropical_subtle',
      name: 'Tropical Subtle',
      description: 'Leafy prints, wood fans, breeziness.',
      tileImages: _getTiles(15),
      tags: ['Green', 'Nature', 'Fresh'],
      basePrompt: 'subtle tropical bedroom, green accents, wooden ceiling fan, fresh',
      controls: _commonControls,
    ),
    // 17. Small Nook Hack
    GuestStyleDefinition(
      id: 'small_nook',
      name: 'Small Guest Nook',
      description: 'Optimized for tiny spaces.',
      tileImages: _getTiles(16),
      tags: ['Small', 'Smart', 'Compact'],
      basePrompt: 'tiny guest bedroom, space saving furniture, cozy nook, optimized layout',
      controls: [
        ..._commonControls,
        const StyleControl(id: 'space_saving', label: 'Space Saving', type: ControlType.chips, defaultValue: 'Vertical', options: ['Foldable', 'Vertical', 'Mirror']),
      ],
    ),
    // 18. Multi-Purpose Office
    GuestStyleDefinition(
      id: 'multi_purpose',
      name: 'Office + Guest',
      description: 'Productive workspace that sleeps guests.',
      tileImages: _getTiles(17),
      tags: ['Office', 'Dual', 'Smart'],
      basePrompt: 'home office guest room combo, desk setup, sofa bed, functional',
      controls: [
        ..._commonControls,
        const StyleControl(id: 'desk_size', label: 'Desk Size', type: ControlType.chips, defaultValue: 'Compact', options: ['Compact', 'Full']),
        const StyleControl(id: 'hide_work', label: 'Hide Work Setup', type: ControlType.toggle, defaultValue: false),
      ],
    ),
    // 19. Family Ready
    GuestStyleDefinition(
      id: 'family_ready',
      name: 'Family Ready',
      description: 'Space for parents + child/cot.',
      tileImages: _getTiles(18),
      tags: ['Family', 'Spacious', 'Safe'],
      basePrompt: 'family guest room, queen bed plus bunk or cot, kid friendly',
      controls: [
        ..._commonControls,
        const StyleControl(id: 'extra_sleep', label: 'Extra Sleep', type: ControlType.chips, defaultValue: 'Cot', options: ['Cot', 'Bunk', 'Trundle']),
      ],
    ),
    // 20. Minimal Storage Smart
    GuestStyleDefinition(
      id: 'minimal_storage',
      name: 'Minimal Storage Smart',
      description: 'Hidden storage solutions.',
      tileImages: _getTiles(19),
      tags: ['Storage', 'Clean', 'Hidden'],
      basePrompt: 'smart storage bedroom, built-in wardrobes, under bed storage, clean look',
      controls: _commonControls,
    ),
    // 21. Reading Corner
    GuestStyleDefinition(
      id: 'reading_corner',
      name: 'Reading Corner Guest',
      description: 'Focus on a cozy armchair and books.',
      tileImages: _getTiles(20),
      tags: ['Books', 'Cozy', 'Armchair'],
      basePrompt: 'guest room with reading corner, cozy armchair, bookshelf, floor lamp',
      controls: _commonControls,
    ),
    // 22. Spa-Like Calm
    GuestStyleDefinition(
      id: 'spa_like',
      name: 'Spa-Like Calm',
      description: 'White, stone textures, diffuser vibes.',
      tileImages: _getTiles(21),
      tags: ['Spa', 'Zen', 'White'],
      basePrompt: 'spa inspired bedroom, white tones, stone texture, calming atmosphere',
      controls: _commonControls,
    ),
    // 23. Hotel White Crisp
    GuestStyleDefinition(
      id: 'hotel_white',
      name: 'Hotel White Crisp',
      description: 'The classic 5-star white sheet look.',
      tileImages: _getTiles(22),
      tags: ['Clean', 'Classic', 'White'],
      basePrompt: 'luxury hotel room, crisp white bedding, perfectly made bed, bright',
      controls: [
        ..._commonControls,
        const StyleControl(id: 'crispness', label: 'Crispness', type: ControlType.slider, defaultValue: 90.0, min: 50, max: 100),
      ],
    ),
    // 24. Cozy Autumn
    GuestStyleDefinition(
      id: 'cozy_autumn',
      name: 'Cozy Autumn',
      description: 'Burnt orange, wool, warm light.',
      tileImages: _getTiles(23),
      tags: ['Warm', 'Orange', 'Seasonal'],
      basePrompt: 'autumn vibes bedroom, burnt orange accents, wool throw, warm lighting',
      controls: _commonControls,
    ),
    // 25. Summer Bright
    GuestStyleDefinition(
      id: 'summer_bright',
      name: 'Summer Bright',
      description: 'Yellows, cotton, sunlight.',
      tileImages: _getTiles(24),
      tags: ['Bright', 'Yellow', 'Fresh'],
      basePrompt: 'summer breeze bedroom, yellow accents, light cotton, sunlight',
      controls: _commonControls,
    ),
    // 26. Budget Friendly
    GuestStyleDefinition(
      id: 'budget_friendly',
      name: 'Budget Friendly',
      description: 'Simple updates, IKEA-hacks style.',
      tileImages: _getTiles(25),
      tags: ['Simple', 'DIY', 'Modern'],
      basePrompt: 'budget friendly guest room makeover, simple furniture, clean look, diy touches',
      controls: _commonControls,
    ),
    // 27. Statement Headboard
    GuestStyleDefinition(
      id: 'statement_headboard',
      name: 'Statement Headboard',
      description: 'Room focused on a bold bed frame.',
      tileImages: _getTiles(26),
      tags: ['Bold', 'Focus', 'Art'],
      basePrompt: 'bedroom with statement headboard, bold design, velvet or pattern headboard',
      controls: _commonControls,
    ),
    // 28. Rental Friendly
    GuestStyleDefinition(
      id: 'rental_friendly',
      name: 'Rental Friendly',
      description: 'No painting, temporary decor focus.',
      tileImages: _getTiles(27),
      tags: ['Temporary', 'Safe', 'Decor'],
      basePrompt: 'rental friendly guest room, peel and stick wallpaper, freestanding furniture',
      controls: _commonControls,
    ),
    // 29. Custom Advanced
    GuestStyleDefinition(
      id: 'custom_advanced',
      name: 'Custom (Advanced)',
      description: 'Create your own unique style prompt.',
      tileImages: _getTiles(28),
      tags: ['Custom', 'Pro', 'Free'],
      basePrompt: 'custom designed bedroom',
      controls: [
        const StyleControl(id: 'custom_prompt', label: 'Custom Prompt', type: ControlType.text, defaultValue: ''),
        const StyleControl(id: 'negative_prompt', label: 'Avoid (Negative)', type: ControlType.text, defaultValue: 'clutter, mess, blur'),
        const StyleControl(id: 'strictness', label: 'AI Strictness', type: ControlType.slider, defaultValue: 60.0, min: 0, max: 100),
      ],
    ),
  ];
  return styles;
}
