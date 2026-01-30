// lib/model/beauty_config.dart

import 'image_result_data.dart';

// -----------------------------------------------------------------------------
// ENUMS & TYPES
// -----------------------------------------------------------------------------

enum ControlType { slider, stepper, toggle, chips }

class ControlDefinition {
  final String id;
  final String label;
  final ControlType type;
  final dynamic defaultValue;
  final List<String>? options; // For chips
  final double? min; // For slider
  final double? max; // For slider
  final int? minInt; // For stepper
  final int? maxInt; // For stepper

  const ControlDefinition({
    required this.id,
    required this.label,
    required this.type,
    this.defaultValue,
    this.options,
    this.min,
    this.max,
    this.minInt,
    this.maxInt,
  });
}

class BeautyStyle {
  final String id;
  final String name;
  final String moodboardImage;
  final String description; // Used for prompt
  final List<ControlDefinition> controls;

  const BeautyStyle({
    required this.id,
    required this.name,
    required this.moodboardImage,
    required this.description,
    required this.controls,
  });
}

// -----------------------------------------------------------------------------
// CONSTANTS & PRESETS
// -----------------------------------------------------------------------------

// Common controls used across many styles
const _baseControls = [
  ControlDefinition(
    id: 'salon_size',
    label: 'Salon Size',
    type: ControlType.chips,
    options: ['Small', 'Medium', 'Large'],
    defaultValue: 'Medium',
  ),
  ControlDefinition(
    id: 'zone_focus',
    label: 'Zone Focus',
    type: ControlType.chips,
    options: ['Nails', 'Hair', 'Makeup', 'Spa', 'Mixed'],
    defaultValue: 'Hair',
  ),
  ControlDefinition(
    id: 'station_count',
    label: 'Stations',
    type: ControlType.stepper,
    minInt: 1,
    maxInt: 12,
    defaultValue: 3,
  ),
  ControlDefinition(
    id: 'lighting',
    label: 'Lighting Vibe',
    type: ControlType.chips,
    options: ['Daylight', 'Glam Bulbs', 'Warm Lounge', 'LED Subtle'],
    defaultValue: 'Daylight',
  ),
  ControlDefinition(
    id: 'materials',
    label: 'Key Material',
    type: ControlType.chips,
    options: ['Marble', 'Wood', 'Glass', 'Metal', 'Velvet'],
    defaultValue: 'Marble',
  ),
  ControlDefinition(
    id: 'hygiene',
    label: 'Hygiene Storage',
    type: ControlType.chips,
    options: ['Minimal', 'Hidden', 'Cabinets'],
    defaultValue: 'Hidden',
  ),
  ControlDefinition(
    id: 'budget',
    label: 'Look Budget',
    type: ControlType.slider,
    min: 0.0,
    max: 100.0,
    defaultValue: 50.0,
  ),
];

// Special specific controls
const _hollywoodControls = [
  ControlDefinition(
    id: 'bulb_brightness',
    label: 'Bulb Brightness',
    type: ControlType.slider,
    min: 10,
    max: 100,
    defaultValue: 80,
  ),
  ControlDefinition(
    id: 'spotlight_glow',
    label: 'Spotlight Glow Effect',
    type: ControlType.toggle,
    defaultValue: true,
  ),
];

const _nailBarControls = [
  ControlDefinition(
    id: 'ventilation',
    label: 'Visible Ventilation',
    type: ControlType.toggle,
    defaultValue: false,
  ),
  ControlDefinition(
    id: 'color_bar',
    label: 'Color Wall Display',
    type: ControlType.toggle,
    defaultValue: true,
  ),
];

class BeautyStylePresets {
  static const String assetPrefix = 'assets/style_moodboards/style_';

  static List<BeautyStyle> get all => [
    _style('runway_rose_luxe', 'Runway Rose Luxe', 'pink rose luxury high-end fashion runway aesthetic, glossy surfaces'),
    _style('minimal_white_glam', 'Minimal White Glam', 'all white minimalistic luxury, clean lines, bright airy'),
    _style('dark_chic_salon', 'Dark Chic Salon', 'dark interior, moody lighting, gold accents, luxury noir'),
    _style('korean_clean_beauty', 'Korean Clean Beauty', 'korean aesthetic, soft pastels, clean wood, minimal clutter'),
    _style('japandi_calm_beauty', 'Japandi Calm Beauty', 'japanese scandi fusion, natural wood, zen atmosphere, plants'),
    _style('scandinavian_soft_beauty', 'Scandinavian Soft', 'scandinavian design, light wood, white walls, functional beauty'),
    _style('hollywood_mirror_glam', 'Hollywood Mirror', 'hollywood vanity mirrors with bulbs, glamorous, star dressing room', extra: _hollywoodControls),
    _style('parisian_chic_salon', 'Parisian Chic', 'parisian apartment style, moldings, chandelier, elegant classic'),
    _style('modern_marble_beauty', 'Modern Marble', 'heavy marble usage, white and grey stone, expensive look'),
    _style('rose_gold_boutique', 'Rose Gold Boutique', 'rose gold metal accents, blush tones, feminine luxury'),
    _style('orchid_neon-subtle_studio', 'Orchid Neon', 'orchid purple accents, subtle neon strips, modern vibe'),
    _style('spa_serenity_corner', 'Spa Serenity', 'calm spa atmosphere, stone textures, dim lighting, candles'),
    _style('clinic-clean_aesthetic', 'Clinic Clean', 'medical beauty aesthetic, sterile but white luxury, glass'),
    _style('nail_bar_focus', 'Nail Bar Focus', 'dedicated nail salon setup, manicure tables', extra: _nailBarControls),
    _style('hair_studio_focus', 'Hair Studio Focus', 'hair salon emphasis, shampoo bowls, cutting chairs'),
    _style('makeup_station_pro', 'Makeup Station Pro', 'professional makeup artist studio, high CRI lighting'),
    _style('reception-first_boutique', 'Reception Boutique', 'grand reception desk focus, retail products upfront'),
    _style('retail_product_wall_showcase', 'Retail Showcase', 'product shelves focus, merchandising beauty store'),
    _style('cozy_warm_lounge_salon', 'Cozy Warm Lounge', 'comfortable seating, warm tones, living room vibe'),
    _style('luxury_hotel_salon_suite', 'Luxury Hotel Suite', '5-star hotel salon, exclusive, private feel'),
    _style('industrial_beauty_loft', 'Industrial Loft', 'exposed brick, black metal, loft style salon'),
    _style('tropical_beauty_studio', 'Tropical Studio', 'plants, green walls, natural light, fresh vibe'),
    _style('boho_soft_beauty', 'Boho Soft', 'rattan, macrame, beige tones, relaxed bohemian'),
    _style('pastel_candy_beauty', 'Pastel Candy', 'pop pastel colors, playful, instagrammable'),
    _style('premium_black_and_champagne', 'Black & Champagne', 'black walls, champagne gold fixtures, premium contrast'),
    _style('budget_practical_salon', 'Budget Practical', 'efficient layout, simple materials, realistic start-up'),
    _style('small_salon_space_hack', 'Small Space Hack', 'clever storage, mirrors to expand space, tiny salon'),
    _style('high_capacity_multi-station', 'High Capacity', 'row of stations, busy salon layout, efficient'),
    _style('content-creator_friendly_salon', 'Content Creator', 'selfie spots, ring lights, aesthetic corners'),
    _style('bridal_beauty_suite', 'Bridal Suite', 'wedding prep area, large mirrors, seating for bridesmaids'),
    _style('mens_grooming_corner', 'Men\'s Grooming', 'barbershop details, leather chairs, masculine luxury'),
    _style('eco-friendly_natural_beauty', 'Eco-Friendly', 'sustainable materials, reclaimed wood, greenery, non-toxic vibe'),
  ];

  static BeautyStyle _style(String id, String name, String prompt, {List<ControlDefinition>? extra}) {
    return BeautyStyle(
      id: id,
      name: name,
      moodboardImage: '$assetPrefix$id.svg',
      description: prompt,
      controls: [..._baseControls, ...?extra],
    );
  }

  static BeautyStyle? getById(String id) {
    if (id == 'custom') return customStyle;
    try {
      return all.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  static const customStyle = BeautyStyle(
    id: 'custom',
    name: 'Custom (Advanced)',
    moodboardImage: 'assets/style_moodboards/style_minimal_white_glam.svg', // Fallback
    description: 'custom',
    controls: [
       ControlDefinition(
        id: 'custom_prompt',
        label: 'Your Vision',
        type: ControlType.chips, // Actually processed as text in UI
        defaultValue: '',
      ),
      ..._baseControls,
    ],
  );
}

// -----------------------------------------------------------------------------
// CONFIG MODEL
// -----------------------------------------------------------------------------

class BeautyAIConfig {
  const BeautyAIConfig({
    this.originalImagePath,
    this.selectedStyleId,
    this.controlValues = const {},
    this.customPrompt,
    this.negativePrompt,
    this.userNote,
    this.resultData,
    required this.timestamp,
  });

  final String? originalImagePath;
  final String? selectedStyleId;
  final Map<String, dynamic> controlValues;
  final String? customPrompt;
  final String? negativePrompt;
  final String? userNote;
  final ImageResultData? resultData;
  final DateTime timestamp;

  // Factory constructor for creating a new empty config
  factory BeautyAIConfig.empty() {
    return BeautyAIConfig(
      timestamp: DateTime.now(),
    );
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'originalImagePath': originalImagePath,
      'selectedStyleId': selectedStyleId,
      'controlValues': controlValues,
      'customPrompt': customPrompt,
      'negativePrompt': negativePrompt,
      'userNote': userNote,
      'resultData': resultData?.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory BeautyAIConfig.fromJson(Map<String, dynamic> json) {
    return BeautyAIConfig(
      originalImagePath: json['originalImagePath'] as String?,
      selectedStyleId: json['selectedStyleId'] as String?,
      controlValues: Map<String, dynamic>.from(json['controlValues'] ?? {}),
      customPrompt: json['customPrompt'] as String?,
      negativePrompt: json['negativePrompt'] as String?,
      userNote: json['userNote'] as String?,
      resultData: json['resultData'] != null
          ? ImageResultData.fromJson(json['resultData'] as Map<String, dynamic>)
          : null,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  // copyWith for immutable updates
  BeautyAIConfig copyWith({
    String? originalImagePath,
    String? selectedStyleId,
    Map<String, dynamic>? controlValues,
    String? customPrompt,
    String? negativePrompt,
    String? userNote,
    ImageResultData? resultData,
    DateTime? timestamp,
  }) {
    return BeautyAIConfig(
      originalImagePath: originalImagePath ?? this.originalImagePath,
      selectedStyleId: selectedStyleId ?? this.selectedStyleId,
      controlValues: controlValues ?? this.controlValues,
      customPrompt: customPrompt ?? this.customPrompt,
      negativePrompt: negativePrompt ?? this.negativePrompt,
      userNote: userNote ?? this.userNote,
      resultData: resultData ?? this.resultData,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  // Helper method to set a control value
  BeautyAIConfig setControl(String key, dynamic value) {
    final newControls = Map<String, dynamic>.from(controlValues);
    newControls[key] = value;
    return copyWith(controlValues: newControls);
  }

  // Validation helpers
  bool get hasOriginalImage =>
      originalImagePath != null && originalImagePath!.isNotEmpty;

  bool get hasStyle => selectedStyleId != null;

  bool get isReadyForGeneration =>
      hasOriginalImage && hasStyle;

  // PROMPT GENERATION LOGIC
  String buildPositivePrompt() {
    if (selectedStyleId == 'custom') {
      return _buildCustomPrompt();
    }

    final style = BeautyStylePresets.getById(selectedStyleId ?? '');
    if (style == null) return "beauty salon interior";

    final sb = StringBuffer();

    // 1. Base
    sb.write("beauty salon interior redesign, luxury clean aesthetic, realistic station spacing, flattering lighting, 8k resolution, architectural photography. ");

    // 2. Style
    sb.write("${style.description}. ");

    // 3. Controls
    controlValues.forEach((key, value) {
      if (key == 'salon_size') sb.write("$value salon size, ");
      if (key == 'zone_focus') sb.write("focus area: $value station, ");
      if (key == 'station_count') sb.write("$value styling stations visible, ");
      if (key == 'lighting') sb.write("$value lighting, ");
      if (key == 'materials') sb.write("$value surfaces, ");
      if (key == 'hygiene') sb.write("$value hygiene storage solutions, ");
      if (key == 'bulb_brightness') sb.write("bright vanity bulbs, ");
      if (key == 'spotlight_glow' && value == true) sb.write("soft spotlight glow, ");
      if (key == 'ventilation' && value == true) sb.write("visible clean ventilation, ");
    });

    // 4. Note
    if (userNote != null && userNote!.isNotEmpty) {
      sb.write("Note: $userNote. ");
    }

    return sb.toString();
  }

  String _buildCustomPrompt() {
    final sb = StringBuffer();
    sb.write("beauty salon interior redesign. ");
    if (customPrompt != null) sb.write("$customPrompt. ");

    controlValues.forEach((key, value) {
       // Add basic controls to custom prompt too if they are set
       if (key == 'station_count') sb.write("$value stations, ");
       if (key == 'lighting') sb.write("$value lighting, ");
    });

    return sb.toString();
  }

  String buildNegativePrompt() {
    final sb = StringBuffer();
    sb.write("distorted mirrors, blurry reflection, messy cables, trash, construction site, dark shadows, scary, ugly, low resolution, watermark, text, logo. ");
    if (negativePrompt != null) sb.write("$negativePrompt");
    return sb.toString();
  }
}
