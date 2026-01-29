import '../model/style_definition.dart';
import '../model/style_control.dart';

class TerraceStyles {
  // Common Controls
  static const _sizeControl = StyleControl(
    id: 'size',
    label: 'Size Fit',
    type: ControlType.chips,
    defaultValue: 'Patio',
    options: ['Small', 'Narrow', 'Corner', 'Rooftop', 'Patio'],
  );

  static const _seatingControl = StyleControl(
    id: 'seating',
    label: 'Seating Capacity',
    type: ControlType.slider,
    defaultValue: 4.0,
    min: 2,
    max: 12,
    divisions: 10,
    suffix: ' ppl',
  );

  static const _greeneryControl = StyleControl(
    id: 'greenery',
    label: 'Greenery Level',
    type: ControlType.chips,
    defaultValue: 'Medium',
    options: ['Low', 'Medium', 'Jungle'],
  );

  static const _lightingControl = StyleControl(
    id: 'lighting',
    label: 'Lighting Type',
    type: ControlType.chips,
    defaultValue: 'Lantern',
    options: ['String', 'Lantern', 'Hidden LED', 'Candle', 'Fire Pit'],
  );

  static const _privacyControl = StyleControl(
    id: 'privacy',
    label: 'Privacy Screen',
    type: ControlType.chips,
    defaultValue: 'None',
    options: ['None', 'Bamboo', 'Fabric', 'Glass', 'Plants'],
  );

  static const _noteControl = StyleControl(
    id: 'note',
    label: 'Extra Note',
    type: ControlType.text,
    defaultValue: '',
  );

  static final List<StyleDefinition> styles = [
    // 1. Cozy Lantern Lounge
    StyleDefinition(
      id: 'cozy_lantern',
      title: 'Cozy Lantern Lounge',
      description: 'Warm, inviting space with abundant soft lighting.',
      imagePath: 'assets/style_thumbs/style_cozy_lantern.svg',
      tags: ['Cozy', 'Warm', 'Romantic'],
      basePrompt: 'cozy lantern lounge with warm string lights and soft textiles',
      controls: [
        _sizeControl,
        StyleControl(id: 'warmth', label: 'Warmth', type: ControlType.slider, defaultValue: 70.0, min: 0, max: 100),
        StyleControl(id: 'textiles', label: 'Textiles', type: ControlType.toggle, defaultValue: true),
        _seatingControl,
        _lightingControl,
        _noteControl,
      ],
    ),

    // 2. Modern Minimal Night
    StyleDefinition(
      id: 'modern_minimal',
      title: 'Modern Minimal Night',
      description: 'Clean lines, monochromatic palette, sophisticated.',
      imagePath: 'assets/style_thumbs/style_modern_minimal.svg',
      tags: ['Modern', 'Sleek', 'Dark'],
      basePrompt: 'modern minimal outdoor terrace at night, sleek concrete and black wood',
      controls: [
        _sizeControl,
        StyleControl(id: 'palette', label: 'Palette', type: ControlType.chips, defaultValue: 'Charcoal', options: ['Charcoal', 'Black Wood', 'Concrete']),
        StyleControl(id: 'clutter', label: 'Clutter', type: ControlType.slider, defaultValue: 10.0, min: 0, max: 100),
        _seatingControl,
        _greeneryControl,
        _noteControl,
      ],
    ),

    // 3. Tropical Night Garden
    StyleDefinition(
      id: 'tropical_garden',
      title: 'Tropical Night Garden',
      description: 'Lush exotic plants and resort vibes.',
      imagePath: 'assets/style_thumbs/style_tropical_garden.svg',
      tags: ['Lush', 'Exotic', 'Resort'],
      basePrompt: 'tropical night garden balcony with lush ferns and palms',
      controls: [
        _sizeControl,
        StyleControl(id: 'plant_type', label: 'Plant Type', type: ControlType.chips, defaultValue: 'Mixed', options: ['Broadleaf', 'Fern', 'Mixed']),
        StyleControl(id: 'planter_style', label: 'Planter Style', type: ControlType.chips, defaultValue: 'Clay', options: ['Clay', 'Concrete', 'Hanging']),
        _seatingControl,
        _lightingControl,
        _noteControl,
      ],
    ),

    // 4. Boho Rattan Glow
    StyleDefinition(
      id: 'boho_rattan',
      title: 'Boho Rattan Glow',
      description: 'Eclectic bohemian style with natural textures.',
      imagePath: 'assets/style_thumbs/style_boho_rattan.svg',
      tags: ['Boho', 'Eclectic', 'Natural'],
      basePrompt: 'bohemian rattan terrace with macrame and warm glow',
      controls: [_sizeControl, _seatingControl, _greeneryControl, _lightingControl, _noteControl],
    ),

    // 5. Rooftop Party Lights
    StyleDefinition(
      id: 'rooftop_party',
      title: 'Rooftop Party Lights',
      description: 'Vibrant space ready for entertainment.',
      imagePath: 'assets/style_thumbs/style_rooftop_party.svg',
      tags: ['Party', 'Vibrant', 'Social'],
      basePrompt: 'rooftop party lounge with festive lighting and bar setup',
      controls: [
        _sizeControl,
        StyleControl(id: 'intensity', label: 'Light Intensity', type: ControlType.slider, defaultValue: 80.0, min: 0, max: 100),
        StyleControl(id: 'bar_setup', label: 'Bar Setup', type: ControlType.chips, defaultValue: 'Cart', options: ['Mini Bar', 'Cart', 'None']),
        StyleControl(id: 'accent_color', label: 'Accent Color', type: ControlType.chips, defaultValue: 'Violet', options: ['Violet', 'Teal', 'Amber']),
        _seatingControl,
        _noteControl,
      ],
    ),

    // 6. Japandi Outdoor Calm
    StyleDefinition(
      id: 'japandi_calm',
      title: 'Japandi Outdoor Calm',
      description: 'Fusion of Japanese and Scandinavian minimalism.',
      imagePath: 'assets/style_thumbs/style_japandi_calm.svg',
      tags: ['Zen', 'Wood', 'Minimal'],
      basePrompt: 'japandi outdoor balcony, wood slats and bonsai, peaceful night',
      controls: [_sizeControl, _seatingControl, _greeneryControl, _lightingControl, _noteControl],
    ),

    // 7. Mediterranean Patio Night
    StyleDefinition(
      id: 'mediterranean',
      title: 'Mediterranean Patio',
      description: 'Warm terracotta, tiles, and olive trees.',
      imagePath: 'assets/style_thumbs/style_mediterranean.svg',
      tags: ['Rustic', 'Warm', 'Tiles'],
      basePrompt: 'mediterranean patio at night, terracotta tiles and olive trees',
      controls: [_sizeControl, _seatingControl, _greeneryControl, _lightingControl, _noteControl],
    ),

    // 8. Urban Industrial Terrace
    StyleDefinition(
      id: 'urban_industrial',
      title: 'Urban Industrial',
      description: 'Raw metal, brick, and edison bulbs.',
      imagePath: 'assets/style_thumbs/style_urban_industrial.svg',
      tags: ['Raw', 'Edgy', 'City'],
      basePrompt: 'urban industrial terrace, brick walls and metal furniture, edison bulbs',
      controls: [_sizeControl, _seatingControl, _greeneryControl, _lightingControl, _noteControl],
    ),

    // 9. Zen Garden Balcony
    StyleDefinition(
      id: 'zen_garden',
      title: 'Zen Garden Balcony',
      description: 'Peaceful rock garden and bamboo.',
      imagePath: 'assets/style_thumbs/style_zen_garden.svg',
      tags: ['Peaceful', 'Rocks', 'Bamboo'],
      basePrompt: 'zen garden balcony with rocks and bamboo screen',
      controls: [_sizeControl, _seatingControl, _greeneryControl, _privacyControl, _noteControl],
    ),

    // 10. Scandinavian Outdoor Soft
    StyleDefinition(
      id: 'scandi_soft',
      title: 'Scandi Outdoor Soft',
      description: 'Light woods, white textiles, hygge.',
      imagePath: 'assets/style_thumbs/style_scandi_soft.svg',
      tags: ['Hygge', 'Light', 'Cozy'],
      basePrompt: 'scandinavian balcony, hygge style with blankets and candles',
      controls: [_sizeControl, _seatingControl, _greeneryControl, _lightingControl, _noteControl],
    ),

    // 11. Romantic Candle Terrace
    StyleDefinition(
      id: 'romantic_candle',
      title: 'Romantic Candle Terrace',
      description: 'Intimate setting with many candles.',
      imagePath: 'assets/style_thumbs/style_romantic_candle.svg',
      tags: ['Romantic', 'Intimate', 'Soft'],
      basePrompt: 'romantic terrace with hundreds of candles and rose petals',
      controls: [_sizeControl, _seatingControl, _greeneryControl, _privacyControl, _noteControl],
    ),

    // 12. BBQ Social Corner
    StyleDefinition(
      id: 'bbq_social',
      title: 'BBQ Social Corner',
      description: 'Functional cooking and dining space.',
      imagePath: 'assets/style_thumbs/style_bbq_social.svg',
      tags: ['Cooking', 'Dining', 'Family'],
      basePrompt: 'outdoor bbq corner with dining table and grill',
      controls: [_sizeControl, _seatingControl, _lightingControl, _noteControl],
    ),

    // 13. Compact Narrow Balcony Hack
    StyleDefinition(
      id: 'compact_narrow',
      title: 'Compact Narrow Hack',
      description: 'Clever solutions for tight spaces.',
      imagePath: 'assets/style_thumbs/style_compact_narrow.svg',
      tags: ['Small', 'Clever', 'Functional'],
      basePrompt: 'compact narrow balcony with foldable furniture and vertical garden',
      controls: [
        StyleControl(id: 'width', label: 'Balcony Width', type: ControlType.slider, defaultValue: 1.0, min: 0.5, max: 3.0, suffix: 'm'),
        StyleControl(id: 'layout', label: 'Layout', type: ControlType.chips, defaultValue: 'Linear', options: ['Linear', 'Corner L', 'Foldable']),
        StyleControl(id: 'storage', label: 'Storage', type: ControlType.chips, defaultValue: 'Vertical', options: ['Vertical', 'Under-seat']),
        _lightingControl,
        _noteControl,
      ],
    ),

    // 14. Luxury Hotel Terrace
    StyleDefinition(
      id: 'luxury_hotel',
      title: 'Luxury Hotel Terrace',
      description: 'High-end furniture and sophisticated ambiance.',
      imagePath: 'assets/style_thumbs/style_luxury_hotel.svg',
      tags: ['Premium', 'Expensive', 'Formal'],
      basePrompt: 'luxury hotel terrace suite, premium furniture and champagne',
      controls: [_sizeControl, _seatingControl, _greeneryControl, _lightingControl, _noteControl],
    ),

    // 15. Pet-Friendly Terrace
    StyleDefinition(
      id: 'pet_friendly',
      title: 'Pet-Friendly Terrace',
      description: 'Safe and fun for furry friends.',
      imagePath: 'assets/style_thumbs/style_pet_friendly.svg',
      tags: ['Pets', 'Safe', 'Fun'],
      basePrompt: 'pet friendly balcony with safety netting and pet grass',
      controls: [
        StyleControl(id: 'pet_type', label: 'Pet Type', type: ControlType.chips, defaultValue: 'Cat', options: ['Cat', 'Small Dog', 'Large Dog']),
        StyleControl(id: 'flooring', label: 'Flooring', type: ControlType.chips, defaultValue: 'Deck', options: ['Anti-slip', 'Deck', 'Tile']),
        StyleControl(id: 'safe_plants', label: 'Pet-safe Plants', type: ControlType.toggle, defaultValue: true),
        _sizeControl,
        _noteControl,
      ],
    ),

    // 16. Plant Jungle Max
    StyleDefinition(
      id: 'plant_jungle',
      title: 'Plant Jungle Max',
      description: 'Immersive greenery everywhere.',
      imagePath: 'assets/style_thumbs/style_plant_jungle.svg',
      tags: ['Green', 'Wild', 'Nature'],
      basePrompt: 'overgrown balcony jungle, plants everywhere, immersive nature',
      controls: [_sizeControl, _seatingControl, _lightingControl, _noteControl],
    ),

    // 17. Rainy Season Cozy
    StyleDefinition(
      id: 'rainy_cozy',
      title: 'Rainy Season Cozy',
      description: 'Protected space for enjoying the rain.',
      imagePath: 'assets/style_thumbs/style_rainy_cozy.svg',
      tags: ['Rain', 'Shelter', 'Mood'],
      basePrompt: 'rainy night on balcony, sheltered, wet glass, cozy inside',
      controls: [_sizeControl, _seatingControl, _lightingControl, _noteControl],
    ),

    // 18. Minimal Green Balcony
    StyleDefinition(
      id: 'minimal_green',
      title: 'Minimal Green Balcony',
      description: 'Few statement plants, clean look.',
      imagePath: 'assets/style_thumbs/style_minimal_green.svg',
      tags: ['Clean', 'Plants', 'Modern'],
      basePrompt: 'minimalist balcony with one large statement tree',
      controls: [_sizeControl, _seatingControl, _lightingControl, _noteControl],
    ),

    // 19. Wabi-Sabi Terrace
    StyleDefinition(
      id: 'wabi_sabi',
      title: 'Wabi-Sabi Terrace',
      description: 'Beauty in imperfection, aged materials.',
      imagePath: 'assets/style_thumbs/style_wabi_sabi.svg',
      tags: ['Aged', 'Imperfect', 'Deep'],
      basePrompt: 'wabi-sabi terrace, aged wood and stone, imperfection',
      controls: [_sizeControl, _seatingControl, _greeneryControl, _lightingControl, _noteControl],
    ),

    // 20. Moroccan Lantern Patio
    StyleDefinition(
      id: 'moroccan',
      title: 'Moroccan Lantern Patio',
      description: 'Intricate patterns and colorful lanterns.',
      imagePath: 'assets/style_thumbs/style_moroccan.svg',
      tags: ['Pattern', 'Color', 'Exotic'],
      basePrompt: 'moroccan patio with mosaic tiles and colorful lanterns',
      controls: [_sizeControl, _seatingControl, _greeneryControl, _lightingControl, _noteControl],
    ),

    // 21. Korean Minimal Terrace
    StyleDefinition(
      id: 'korean_minimal',
      title: 'Korean Minimal Terrace',
      description: 'Soft neutrals, low furniture, aesthetics.',
      imagePath: 'assets/style_thumbs/style_korean_minimal.svg',
      tags: ['Soft', 'Neutral', 'Aesthetic'],
      basePrompt: 'korean aesthetic cafe terrace, beige and cream tones',
      controls: [_sizeControl, _seatingControl, _greeneryControl, _lightingControl, _noteControl],
    ),

    // 22. Bistro Paris Balcony
    StyleDefinition(
      id: 'bistro_paris',
      title: 'Bistro Paris Balcony',
      description: 'Classic cafe chair and small table.',
      imagePath: 'assets/style_thumbs/style_bistro_paris.svg',
      tags: ['Classic', 'Paris', 'Cafe'],
      basePrompt: 'parisian balcony with bistro chair and coffee table',
      controls: [_sizeControl, _seatingControl, _greeneryControl, _lightingControl, _noteControl],
    ),

    // 23. Beachy Coastal Terrace
    StyleDefinition(
      id: 'beachy_coastal',
      title: 'Beachy Coastal Terrace',
      description: 'Driftwood, white linen, airy breeze.',
      imagePath: 'assets/style_thumbs/style_beachy_coastal.svg',
      tags: ['Airy', 'Coastal', 'White'],
      basePrompt: 'coastal beach house terrace, driftwood and white linen',
      controls: [_sizeControl, _seatingControl, _greeneryControl, _lightingControl, _noteControl],
    ),

    // 24. Fire Pit Lounge
    StyleDefinition(
      id: 'fire_pit',
      title: 'Fire Pit Lounge',
      description: 'Centered around a warm fire element.',
      imagePath: 'assets/style_thumbs/style_fire_pit.svg',
      tags: ['Fire', 'Warm', 'Gathering'],
      basePrompt: 'outdoor lounge centered around a modern fire pit',
      controls: [_sizeControl, _seatingControl, _greeneryControl, _privacyControl, _noteControl],
    ),

    // Custom Style
    StyleDefinition(
      id: 'custom_advanced',
      title: 'Custom (Advanced)',
      description: 'Create your own prompt from scratch.',
      imagePath: 'assets/style_thumbs/style_modern_minimal.svg', // Fallback or special icon
      tags: ['Advanced', 'Pro', 'Custom'],
      basePrompt: '', // Empty base for custom
      controls: [
        StyleControl(id: 'custom_prompt', label: 'Your Prompt', type: ControlType.text, defaultValue: ''),
        StyleControl(id: 'negative_prompt', label: 'Avoid (Negative)', type: ControlType.text, defaultValue: 'neon, clutter, plastic, blurry'),
        StyleControl(id: 'strictness', label: 'Strictness', type: ControlType.slider, defaultValue: 60.0, min: 0, max: 100),
        _sizeControl,
        _lightingControl,
      ],
    ),
  ];

  static StyleDefinition getById(String id) {
    return styles.firstWhere(
      (s) => s.id == id,
      orElse: () => styles.first,
    );
  }
}
