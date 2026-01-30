// lib/data/study_styles_data.dart
import '../model/study_control.dart';
import '../model/study_style.dart';

// ================= COMMON CONTROLS =================

final _commonControls = [
  const StudyControl(
    id: 'room_subtype',
    label: 'Room Type',
    type: StudyControlType.chips,
    defaultValue: 'Study Room',
    options: ['Study Room', 'Class Corner', 'Desk-Only'],
  ),
  const StudyControl(
    id: 'desk_size',
    label: 'Desk Size',
    type: StudyControlType.chips,
    defaultValue: 'Medium',
    options: ['Small', 'Medium', 'Large'],
  ),
  const StudyControl(
    id: 'seating',
    label: 'Seating',
    type: StudyControlType.chips,
    defaultValue: 'Ergonomic',
    options: ['Ergonomic', 'Minimal', 'Soft'],
  ),
  const StudyControl(
    id: 'lighting',
    label: 'Lighting Mood',
    type: StudyControlType.chips,
    defaultValue: 'Balanced',
    options: ['Task Lamp', 'Daylight', 'Warm', 'Night'],
  ),
  const StudyControl(
    id: 'storage_level',
    label: 'Storage',
    type: StudyControlType.slider,
    defaultValue: 50.0,
    min: 0,
    max: 100,
    divisions: 2, // Low, Med, Max
    suffix: '%',
  ),
  const StudyControl(
    id: 'wall_feature',
    label: 'Wall Feature',
    type: StudyControlType.chips,
    defaultValue: 'Bookshelf',
    options: ['Bookshelf', 'Whiteboard', 'Art', 'None'],
  ),
  const StudyControl(
    id: 'color_intensity',
    label: 'Color Intensity',
    type: StudyControlType.slider,
    defaultValue: 50.0,
    min: 0,
    max: 100,
    divisions: 10,
  ),
  const StudyControl(
    id: 'user_note',
    label: 'Extra Note',
    type: StudyControlType.text,
    defaultValue: '',
  ),
];

// ================= STYLES =================

const List<StudyStyle> studyStyles = [
  // 1. Dark Academia
  StudyStyle(
    id: 'dark_academia',
    name: 'Dark Academia',
    description: 'Moody, vintage aesthetic with rich woods and leather.',
    moodboardAsset: 'assets/style_moodboards/dark_academia.svg',
    tileAsset: 'assets/style_tiles/dark_academia.svg',
    chips: ['Focus', 'Vintage', 'Moody'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'material', label: 'Material', type: StudyControlType.chips, defaultValue: 'Walnut', options: ['Walnut', 'Dark Oak', 'Leather']),
      StudyControl(id: 'antique_details', label: 'Antique Details', type: StudyControlType.toggle, defaultValue: true),
      StudyControl(id: 'warmth', label: 'Warmth', type: StudyControlType.slider, defaultValue: 65.0, min: 0, max: 100),
      StudyControl(id: 'decor', label: 'Decor', type: StudyControlType.multiSelect, defaultValue: [], options: ['Globe', 'Framed Art', 'Desk Lamp']),
    ],
  ),

  // 2. Modern Minimal
  StudyStyle(
    id: 'modern_minimal',
    name: 'Modern Minimal',
    description: 'Clean lines, neutral colors, and zero clutter.',
    moodboardAsset: 'assets/style_moodboards/modern_minimal.svg',
    tileAsset: 'assets/style_tiles/modern_minimal.svg',
    chips: ['Clean', 'Focus', 'Bright'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'simplicity', label: 'Simplicity', type: StudyControlType.slider, defaultValue: 80.0, min: 0, max: 100),
      StudyControl(id: 'monochrome', label: 'Monochrome', type: StudyControlType.toggle, defaultValue: true),
    ],
  ),

  // 3. Scandinavian Bright
  StudyStyle(
    id: 'scandi_bright',
    name: 'Scandinavian Bright',
    description: 'Airy, light woods, and cozy textures.',
    moodboardAsset: 'assets/style_moodboards/scandi_bright.svg',
    tileAsset: 'assets/style_tiles/scandi_bright.svg',
    chips: ['Cozy', 'Bright', 'Wood'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'hygge', label: 'Hygge Factor', type: StudyControlType.slider, defaultValue: 70.0, min: 0, max: 100),
      StudyControl(id: 'plant_life', label: 'Plants', type: StudyControlType.chips, defaultValue: 'Some', options: ['None', 'Some', 'Jungle']),
    ],
  ),

  // 4. Japandi Calm
  StudyStyle(
    id: 'japandi_calm',
    name: 'Japandi Calm',
    description: 'Fusion of Japanese rustic minimalism and Scandinavian functionality.',
    moodboardAsset: 'assets/style_moodboards/japandi_calm.svg',
    tileAsset: 'assets/style_tiles/japandi_calm.svg',
    chips: ['Zen', 'Minimal', 'Warm'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'texture', label: 'Texture', type: StudyControlType.chips, defaultValue: 'Wood & Stone', options: ['Wood', 'Stone', 'Bamboo']),
    ],
  ),

  // 5. Industrial Loft
  StudyStyle(
    id: 'industrial_loft',
    name: 'Industrial Loft',
    description: 'Raw materials, exposed pipes, and metal accents.',
    moodboardAsset: 'assets/style_moodboards/industrial_loft.svg',
    tileAsset: 'assets/style_tiles/industrial_loft.svg',
    chips: ['Raw', 'Urban', 'Cool'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'metal_finish', label: 'Metal Finish', type: StudyControlType.chips, defaultValue: 'Black Steel', options: ['Black Steel', 'Copper', 'Chrome']),
    ],
  ),

  // 6. Cozy Lamp Corner
  StudyStyle(
    id: 'cozy_lamp',
    name: 'Cozy Lamp Corner',
    description: 'Warm, intimate lighting focus for night reading.',
    moodboardAsset: 'assets/style_moodboards/cozy_lamp.svg',
    tileAsset: 'assets/style_tiles/cozy_lamp.svg',
    chips: ['Warm', 'Night', 'Reading'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'lamp_count', label: 'Lamps', type: StudyControlType.stepper, defaultValue: 2, min: 1, max: 5),
    ],
  ),

  // 7. Library Wall
  StudyStyle(
    id: 'library_wall',
    name: 'Library Wall',
    description: 'Floor-to-ceiling bookshelves and academic vibe.',
    moodboardAsset: 'assets/style_moodboards/library_wall.svg',
    tileAsset: 'assets/style_tiles/library_wall.svg',
    chips: ['Books', 'Storage', 'Classic'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'shelf_height', label: 'Shelf Height', type: StudyControlType.chips, defaultValue: 'Full Wall', options: ['Half', 'Full Wall', 'Floating']),
    ],
  ),

  // 8. Whiteboard Pro
  StudyStyle(
    id: 'whiteboard_pro',
    name: 'Whiteboard Pro',
    description: 'Active learning space with large writing surfaces.',
    moodboardAsset: 'assets/style_moodboards/whiteboard_pro.svg',
    tileAsset: 'assets/style_tiles/whiteboard_pro.svg',
    chips: ['Active', 'Creative', 'Bright'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'board_size', label: 'Board Size', type: StudyControlType.chips, defaultValue: 'Large', options: ['Small', 'Medium', 'Large']),
      StudyControl(id: 'marker_storage', label: 'Marker Storage', type: StudyControlType.toggle, defaultValue: true),
    ],
  ),

  // 9. Student Dorm
  StudyStyle(
    id: 'student_dorm',
    name: 'Student Dorm',
    description: 'Compact, efficient usage of small spaces.',
    moodboardAsset: 'assets/style_moodboards/student_dorm.svg',
    tileAsset: 'assets/style_tiles/student_dorm.svg',
    chips: ['Compact', 'Budget', 'Efficient'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'foldable', label: 'Foldable Desk', type: StudyControlType.toggle, defaultValue: false),
      StudyControl(id: 'cable_management', label: 'Hide Cables', type: StudyControlType.toggle, defaultValue: true),
    ],
  ),

  // 10. Small Desk Hack
  StudyStyle(
    id: 'small_desk_hack',
    name: 'Small Desk Hack',
    description: 'Clever solutions for tiny corners.',
    moodboardAsset: 'assets/style_moodboards/small_desk_hack.svg',
    tileAsset: 'assets/style_tiles/small_desk_hack.svg',
    chips: ['Tiny', 'Clever', 'Minimal'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'floating', label: 'Floating Desk', type: StudyControlType.toggle, defaultValue: true),
    ],
  ),

  // 11. Gaming Hybrid
  StudyStyle(
    id: 'gaming_hybrid',
    name: 'Gaming-Study',
    description: 'Dual purpose setup with controlled RGB.',
    moodboardAsset: 'assets/style_moodboards/gaming_hybrid.svg',
    tileAsset: 'assets/style_tiles/gaming_hybrid.svg',
    chips: ['RGB', 'Tech', 'Dual'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'led_level', label: 'LED Level', type: StudyControlType.chips, defaultValue: 'Low', options: ['Off', 'Low', 'Med']),
      StudyControl(id: 'monitors', label: 'Monitors', type: StudyControlType.stepper, defaultValue: 2, min: 1, max: 4),
    ],
  ),

  // 12. Creative Art
  StudyStyle(
    id: 'creative_art',
    name: 'Creative Studio',
    description: 'Space for messy creativity and supplies.',
    moodboardAsset: 'assets/style_moodboards/creative_art.svg',
    tileAsset: 'assets/style_tiles/creative_art.svg',
    chips: ['Art', 'Messy', 'Bright'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'easel', label: 'Easel Space', type: StudyControlType.toggle, defaultValue: true),
    ],
  ),

  // 13. Minimal Monochrome
  StudyStyle(
    id: 'minimal_mono',
    name: 'Minimal Mono',
    description: 'Strict black and white palette.',
    moodboardAsset: 'assets/style_moodboards/minimal_mono.svg',
    tileAsset: 'assets/style_tiles/minimal_mono.svg',
    chips: ['B&W', 'Strict', 'Clean'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'contrast', label: 'Contrast', type: StudyControlType.slider, defaultValue: 80.0, min: 0, max: 100),
    ],
  ),

  // 14. Warm Wood
  StudyStyle(
    id: 'warm_wood',
    name: 'Warm Wood',
    description: 'Natural timber tones everywhere.',
    moodboardAsset: 'assets/style_moodboards/warm_wood.svg',
    tileAsset: 'assets/style_tiles/warm_wood.svg',
    chips: ['Natural', 'Warm', 'Organic'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'wood_type', label: 'Wood', type: StudyControlType.chips, defaultValue: 'Oak', options: ['Oak', 'Pine', 'Teak']),
    ],
  ),

  // 15. Korean Clean
  StudyStyle(
    id: 'korean_clean',
    name: 'Korean Clean',
    description: 'Soft whites, pastel accents, grid organizers.',
    moodboardAsset: 'assets/style_moodboards/korean_clean.svg',
    tileAsset: 'assets/style_tiles/korean_clean.svg',
    chips: ['Soft', 'Tidy', 'Cute'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'grid_wall', label: 'Grid Wall', type: StudyControlType.toggle, defaultValue: true),
    ],
  ),

  // 16. Parisian Nook
  StudyStyle(
    id: 'parisian_nook',
    name: 'Parisian Nook',
    description: 'Elegant, ornate details, window view.',
    moodboardAsset: 'assets/style_moodboards/parisian_nook.svg',
    tileAsset: 'assets/style_tiles/parisian_nook.svg',
    chips: ['Chic', 'Elegant', 'Bright'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'molding', label: 'Wall Molding', type: StudyControlType.toggle, defaultValue: true),
    ],
  ),

  // 17. Mid-Century
  StudyStyle(
    id: 'mid_century',
    name: 'Mid-Century',
    description: 'Retro modern 50s aesthetic.',
    moodboardAsset: 'assets/style_moodboards/mid_century.svg',
    tileAsset: 'assets/style_tiles/mid_century.svg',
    chips: ['Retro', 'Stylish', 'Classic'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'legs', label: 'Leg Style', type: StudyControlType.chips, defaultValue: 'Tapered', options: ['Tapered', 'Hairpin']),
    ],
  ),

  // 18. Futuristic Pod
  StudyStyle(
    id: 'futuristic_pod',
    name: 'Futuristic Pod',
    description: 'Sleek curves and high-tech vibe.',
    moodboardAsset: 'assets/style_moodboards/futuristic_pod.svg',
    tileAsset: 'assets/style_tiles/futuristic_pod.svg',
    chips: ['Tech', 'Sleek', 'Future'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'curves', label: 'Curvature', type: StudyControlType.slider, defaultValue: 70.0, min: 0, max: 100),
    ],
  ),

  // 19. Botanical Calm
  StudyStyle(
    id: 'botanical_calm',
    name: 'Botanical Calm',
    description: 'Surrounded by nature and greenery.',
    moodboardAsset: 'assets/style_moodboards/botanical_calm.svg',
    tileAsset: 'assets/style_tiles/botanical_calm.svg',
    chips: ['Green', 'Nature', 'Fresh'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'plant_density', label: 'Plant Density', type: StudyControlType.slider, defaultValue: 60.0, min: 0, max: 100),
    ],
  ),

  // 20. High Contrast
  StudyStyle(
    id: 'high_contrast',
    name: 'High Contrast',
    description: 'Bold black and brass accents.',
    moodboardAsset: 'assets/style_moodboards/high_contrast.svg',
    tileAsset: 'assets/style_tiles/high_contrast.svg',
    chips: ['Bold', 'Premium', 'Dark'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'brass_accents', label: 'Brass Accents', type: StudyControlType.toggle, defaultValue: true),
    ],
  ),

  // 21. Soft Pastel
  StudyStyle(
    id: 'soft_pastel',
    name: 'Soft Pastel',
    description: 'Gentle colors for a relaxed study.',
    moodboardAsset: 'assets/style_moodboards/soft_pastel.svg',
    tileAsset: 'assets/style_tiles/soft_pastel.svg',
    chips: ['Soft', 'Color', 'Relaxed'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'pastel_hue', label: 'Main Hue', type: StudyControlType.chips, defaultValue: 'Blue', options: ['Blue', 'Pink', 'Sage', 'Lavender']),
    ],
  ),

  // 22. Tech Workspace
  StudyStyle(
    id: 'tech_workspace',
    name: 'Tech Pro',
    description: 'Optimized for multiple screens and gadgets.',
    moodboardAsset: 'assets/style_moodboards/tech_workspace.svg',
    tileAsset: 'assets/style_tiles/tech_workspace.svg',
    chips: ['Pro', 'Tech', 'Clean'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'monitor_arm', label: 'Monitor Arm', type: StudyControlType.toggle, defaultValue: true),
    ],
  ),

  // 23. Montessori Kids
  StudyStyle(
    id: 'montessori_kids',
    name: 'Montessori',
    description: 'Child-safe, accessible, and organized.',
    moodboardAsset: 'assets/style_moodboards/montessori_kids.svg',
    tileAsset: 'assets/style_tiles/montessori_kids.svg',
    chips: ['Kids', 'Safe', 'Learn'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'height', label: 'Desk Height', type: StudyControlType.chips, defaultValue: 'Low', options: ['Low', 'Adjustable']),
    ],
  ),

  // 24. Exam Focus
  StudyStyle(
    id: 'exam_focus',
    name: 'Exam Focus',
    description: 'Zero distractions, pure productivity.',
    moodboardAsset: 'assets/style_moodboards/exam_focus.svg',
    tileAsset: 'assets/style_tiles/exam_focus.svg',
    chips: ['Focus', 'Strict', 'Silent'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'distractions', label: 'Distractions', type: StudyControlType.chips, defaultValue: 'Low', options: ['None', 'Low']),
    ],
  ),

  // 25. Night Owl
  StudyStyle(
    id: 'night_owl',
    name: 'Night Owl',
    description: 'Optimized for late night sessions.',
    moodboardAsset: 'assets/style_moodboards/night_owl.svg',
    tileAsset: 'assets/style_tiles/night_owl.svg',
    chips: ['Dark', 'Night', 'Warm'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'blue_light', label: 'Blue Light Filter', type: StudyControlType.toggle, defaultValue: true),
    ],
  ),

  // 26. Daylight Prod
  StudyStyle(
    id: 'daylight_prod',
    name: 'Daylight Prod',
    description: 'Maximizing natural light.',
    moodboardAsset: 'assets/style_moodboards/daylight_prod.svg',
    tileAsset: 'assets/style_tiles/daylight_prod.svg',
    chips: ['Bright', 'Day', 'Energy'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'window_pos', label: 'Window', type: StudyControlType.chips, defaultValue: 'Front', options: ['Front', 'Side']),
    ],
  ),

  // 27. Storage Max
  StudyStyle(
    id: 'storage_max',
    name: 'Storage Max',
    description: 'Everything in its place.',
    moodboardAsset: 'assets/style_moodboards/storage_max.svg',
    tileAsset: 'assets/style_tiles/storage_max.svg',
    chips: ['Storage', 'Organized', 'Full'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'storage_type', label: 'Type', type: StudyControlType.chips, defaultValue: 'Mixed', options: ['Closed', 'Open', 'Mixed']),
    ],
  ),

  // 28. Silent Zen
  StudyStyle(
    id: 'silent_zen',
    name: 'Silent Zen',
    description: 'Peaceful, meditative study space.',
    moodboardAsset: 'assets/style_moodboards/silent_zen.svg',
    tileAsset: 'assets/style_tiles/silent_zen.svg',
    chips: ['Zen', 'Quiet', 'Minimal'],
    controls: [
      ..._commonControls,
      StudyControl(id: 'cushion', label: 'Floor Cushion', type: StudyControlType.toggle, defaultValue: true),
    ],
  ),

  // Custom Advanced
  StudyStyle(
    id: 'custom_adv',
    name: 'Custom (Advanced)',
    description: 'Build your own prompt from scratch.',
    moodboardAsset: 'assets/style_moodboards/custom_adv.svg',
    tileAsset: 'assets/style_tiles/custom_adv.svg',
    chips: ['Pro', 'Custom', 'Free'],
    controls: [
      StudyControl(id: 'custom_prompt', label: 'Prompt', type: StudyControlType.text, defaultValue: ''),
      StudyControl(id: 'negative_prompt', label: 'Avoid', type: StudyControlType.text, defaultValue: ''),
      StudyControl(id: 'strictness', label: 'Strictness', type: StudyControlType.slider, defaultValue: 60.0, min: 0, max: 100),
      ..._commonControls,
    ],
  ),
];
