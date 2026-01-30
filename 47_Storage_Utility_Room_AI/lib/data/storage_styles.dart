// lib/data/storage_styles.dart

class StorageStyle {
  final String id;
  final String name;
  final String description;
  final List<String> tileImages; // 4 assets for moodboard
  final List<StyleControl> controls;

  const StorageStyle({
    required this.id,
    required this.name,
    required this.description,
    required this.tileImages,
    required this.controls,
  });
}

enum ControlType { select, toggle, slider, chips }

class StyleControl {
  final String id;
  final String label;
  final ControlType type;
  final List<String> options;
  final dynamic defaultValue;
  final String? helperText;

  const StyleControl({
    required this.id,
    required this.label,
    required this.type,
    this.options = const [],
    required this.defaultValue,
    this.helperText,
  });
}

// Common Controls
final _baseControls = [
  const StyleControl(id: 'room_size', label: 'Room Size', type: ControlType.select, options: ['Small (Closet)', 'Medium (Room)', 'Large (Garage/Basement)'], defaultValue: 'Medium (Room)'),
  const StyleControl(id: 'lighting', label: 'Lighting', type: ControlType.chips, options: ['Bright White', 'Warm Soft', 'Industrial Cool', 'Natural'], defaultValue: 'Bright White'),
  const StyleControl(id: 'floor', label: 'Floor Type', type: ControlType.chips, options: ['Tile', 'Concrete', 'Vinyl', 'Wood'], defaultValue: 'Tile'),
  const StyleControl(id: 'budget', label: 'Budget Level', type: ControlType.slider, defaultValue: 0.5, helperText: "Low (DIY) to High (Custom)"),
  const StyleControl(id: 'note', label: 'Special Notes', type: ControlType.select, options: ['None', 'Pet Friendly', 'Kid Safe', 'Accessibility'], defaultValue: 'None'),
];

// Tiles Pool
const _tiles = [
  'assets/style_tiles/tile_wood.jpg',
  'assets/style_tiles/tile_metal.jpg',
  'assets/style_tiles/tile_white.jpg',
  'assets/style_tiles/tile_concrete.jpg',
  'assets/style_tiles/tile_basket.jpg',
  'assets/style_tiles/tile_shelf.jpg',
];

List<String> _getTiles(int offset) {
  // Rotates tiles to give variety
  return [
    _tiles[offset % _tiles.length],
    _tiles[(offset + 1) % _tiles.length],
    _tiles[(offset + 2) % _tiles.length],
    _tiles[(offset + 3) % _tiles.length],
  ];
}

final List<StorageStyle> storageStyles = [
  // 1. Clean White Utility
  StorageStyle(
    id: 'clean_white',
    name: 'Clean White Utility',
    description: 'Bright, hidden storage with minimal visual clutter.',
    tileImages: _getTiles(2),
    controls: [
      ..._baseControls,
      const StyleControl(id: 'cabinet_finish', label: 'Cabinet Finish', type: ControlType.chips, options: ['Matte', 'Gloss', 'Satin'], defaultValue: 'Matte'),
      const StyleControl(id: 'handle_style', label: 'Handles', type: ControlType.select, options: ['Push-to-open', 'Integrated', 'Black Pulls'], defaultValue: 'Integrated'),
    ],
  ),
  // 2. Matte Charcoal Modular
  StorageStyle(
    id: 'matte_charcoal',
    name: 'Matte Charcoal Modular',
    description: 'Sophisticated dark tones with modular flexibility.',
    tileImages: _getTiles(1),
    controls: [
      ..._baseControls,
      const StyleControl(id: 'modularity', label: 'Modularity', type: ControlType.slider, defaultValue: 0.8),
      const StyleControl(id: 'accent_color', label: 'Accent', type: ControlType.chips, options: ['None', 'Brass', 'Wood'], defaultValue: 'None'),
    ],
  ),
  // 3. Industrial Pegboard Pro
  StorageStyle(
    id: 'pegboard_pro',
    name: 'Industrial Pegboard Pro',
    description: 'Maximum wall utilization for tools and loose items.',
    tileImages: _getTiles(0),
    controls: [
      ..._baseControls,
      const StyleControl(id: 'peg_coverage', label: 'Pegboard Coverage', type: ControlType.slider, defaultValue: 0.7),
      const StyleControl(id: 'hook_type', label: 'Hook Material', type: ControlType.chips, options: ['Steel', 'Black', 'Plastic'], defaultValue: 'Steel'),
      const StyleControl(id: 'tool_outline', label: 'Shadow Outlines', type: ControlType.toggle, defaultValue: true),
    ],
  ),
  // 4. Minimal Hidden Cabinets
  StorageStyle(
    id: 'minimal_hidden',
    name: 'Minimal Hidden Cabinets',
    description: 'Everything behind doors for a seamless look.',
    tileImages: _getTiles(3),
    controls: [
      ..._baseControls,
      const StyleControl(id: 'door_style', label: 'Door Style', type: ControlType.select, options: ['Flat', 'Shaker', 'Slatted'], defaultValue: 'Flat'),
    ],
  ),
  // 5. Open Shelf Pantry Overflow
  StorageStyle(
    id: 'open_pantry',
    name: 'Open Shelf Pantry',
    description: 'Accessible storage for bulk food and appliances.',
    tileImages: _getTiles(4),
    controls: [
      ..._baseControls,
      const StyleControl(id: 'shelf_depth', label: 'Shelf Depth', type: ControlType.chips, options: ['Shallow', 'Deep'], defaultValue: 'Deep'),
      const StyleControl(id: 'jar_display', label: 'Jar Display', type: ControlType.toggle, defaultValue: true),
    ],
  ),
  // 6. Laundry Utility Combo
  StorageStyle(
    id: 'laundry_combo',
    name: 'Laundry Utility Combo',
    description: 'Integrated washing station with folding space.',
    tileImages: _getTiles(5),
    controls: [
      ..._baseControls,
      const StyleControl(id: 'stacking', label: 'Machines', type: ControlType.chips, options: ['Stacked', 'Side-by-Side'], defaultValue: 'Side-by-Side'),
      const StyleControl(id: 'hanging_rod', label: 'Hanging Rod', type: ControlType.toggle, defaultValue: true),
    ],
  ),
  // 7. Workshop Tool Wall
  StorageStyle(
    id: 'workshop_wall',
    name: 'Workshop Tool Wall',
    description: 'Heavy duty organization for serious makers.',
    tileImages: _getTiles(0),
    controls: [
      ..._baseControls,
      const StyleControl(id: 'bench_material', label: 'Workbench', type: ControlType.select, options: ['Butcher Block', 'Steel', 'Plywood'], defaultValue: 'Butcher Block'),
    ],
  ),
  // 8. Garage-Grade Utility
  StorageStyle(
    id: 'garage_grade',
    name: 'Garage-Grade Utility',
    description: 'Rugged materials built to withstand dirt and impact.',
    tileImages: _getTiles(1),
    controls: [
      ..._baseControls,
      const StyleControl(id: 'rack_capacity', label: 'Rack Load', type: ControlType.chips, options: ['Standard', 'Heavy Duty'], defaultValue: 'Heavy Duty'),
    ],
  ),
  // 9. Small Closet Hack
  StorageStyle(
    id: 'closet_hack',
    name: 'Small Closet Hack',
    description: 'Maximize every cubic inch in tight spaces.',
    tileImages: _getTiles(2),
    controls: [
      ..._baseControls,
      const StyleControl(id: 'door_storage', label: 'Over-door Storage', type: ControlType.toggle, defaultValue: true),
    ],
  ),
  // 10. Narrow Corridor Storage
  StorageStyle(
    id: 'narrow_corridor',
    name: 'Narrow Corridor',
    description: 'Slim profiles for hallway or passage storage.',
    tileImages: _getTiles(3),
    controls: [
      ..._baseControls,
      const StyleControl(id: 'profile_depth', label: 'Depth', type: ControlType.chips, options: ['Ultra Slim (6")', 'Slim (12")'], defaultValue: 'Slim (12")'),
    ],
  ),
  // 11. Ceiling Rack Seasonal
  StorageStyle(
    id: 'ceiling_rack',
    name: 'Ceiling Rack Seasonal',
    description: 'Overhead storage for bins and seldom-used items.',
    tileImages: _getTiles(4),
    controls: [
      ..._baseControls,
      const StyleControl(id: 'rack_drop', label: 'Drop Height', type: ControlType.slider, defaultValue: 0.3),
      const StyleControl(id: 'ladder_access', label: 'Ladder Required', type: ControlType.toggle, defaultValue: true),
    ],
  ),
  // 12. Heavy-Duty Metal Shelves
  StorageStyle(
    id: 'metal_shelves',
    name: 'Heavy-Duty Metal',
    description: 'Classic wire or slotted angle shelving.',
    tileImages: _getTiles(5),
    controls: [
      ..._baseControls,
      const StyleControl(id: 'color', label: 'Finish', type: ControlType.chips, options: ['Chrome', 'Black', 'Zinc'], defaultValue: 'Chrome'),
    ],
  ),
  // 13. Warm Wood Utility
  StorageStyle(
    id: 'warm_wood',
    name: 'Warm Wood Utility',
    description: 'Soften the utility feel with natural timber.',
    tileImages: _getTiles(0),
    controls: [
      ..._baseControls,
      const StyleControl(id: 'wood_tone', label: 'Wood Tone', type: ControlType.chips, options: ['Oak', 'Walnut', 'Pine'], defaultValue: 'Oak'),
    ],
  ),
  // 14. Scandinavian Clean
  StorageStyle(
    id: 'scandi_clean',
    name: 'Scandinavian Clean',
    description: 'White and wood mix, airy and functional.',
    tileImages: _getTiles(2),
    controls: [..._baseControls],
  ),
  // 15. Japandi Utility Calm
  StorageStyle(
    id: 'japandi_calm',
    name: 'Japandi Utility',
    description: 'Zen-like organization with natural textures.',
    tileImages: _getTiles(3),
    controls: [..._baseControls],
  ),
  // 16. Label-First System
  StorageStyle(
    id: 'label_first',
    name: 'Label-First System',
    description: 'Focus on clear categorization and typography.',
    tileImages: _getTiles(4),
    controls: [
      ..._baseControls,
      const StyleControl(id: 'label_size', label: 'Label Size', type: ControlType.chips, options: ['Standard', 'Large Bold'], defaultValue: 'Large Bold'),
      const StyleControl(id: 'qr_codes', label: 'QR Integration', type: ControlType.toggle, defaultValue: true),
    ],
  ),
  // 17. Bin & Basket Harmony
  StorageStyle(
    id: 'bin_harmony',
    name: 'Bin & Basket Harmony',
    description: 'Uniform containers for a cohesive look.',
    tileImages: _getTiles(5),
    controls: [
      ..._baseControls,
      const StyleControl(id: 'container_type', label: 'Material', type: ControlType.chips, options: ['Plastic', 'Wicker', 'Fabric'], defaultValue: 'Plastic'),
    ],
  ),
  // 18. Cleaning Station Pro
  StorageStyle(
    id: 'cleaning_station',
    name: 'Cleaning Station Pro',
    description: 'Dedicated broom, mop, and vacuum storage.',
    tileImages: _getTiles(1),
    controls: [..._baseControls],
  ),
  // 19. Mop/Broom Vertical
  StorageStyle(
    id: 'vertical_mop',
    name: 'Vertical Cleaning',
    description: 'Wall-mounted grips for long-handled tools.',
    tileImages: _getTiles(0),
    controls: [..._baseControls],
  ),
  // 20. Pet Supplies Storage
  StorageStyle(
    id: 'pet_storage',
    name: 'Pet Supplies',
    description: 'Food bins, leash hooks, and wash station.',
    tileImages: _getTiles(2),
    controls: [
      ..._baseControls,
      const StyleControl(id: 'food_bin_size', label: 'Food Bin', type: ControlType.select, options: ['Small', 'Large (50lb)'], defaultValue: 'Large (50lb)'),
    ],
  ),
  // 21-30 Simplified for brevity but distinct in ID/Name
  StorageStyle(id: 'kids_safe', name: 'Kids-Safe Utility', description: 'Rounded edges and high locks.', tileImages: _getTiles(3), controls: _baseControls),
  StorageStyle(id: 'eco_friendly', name: 'Eco-Friendly Storage', description: 'Bamboo and recycled materials.', tileImages: _getTiles(4), controls: _baseControls),
  StorageStyle(id: 'budget_diy', name: 'Budget DIY Racks', description: 'PVC and lumber solutions.', tileImages: _getTiles(5), controls: _baseControls),
  StorageStyle(id: 'premium_custom', name: 'Premium Custom Cabinetry', description: 'Built-in floor to ceiling.', tileImages: _getTiles(0), controls: _baseControls),
  StorageStyle(id: 'mudroom_hybrid', name: 'Mudroom Utility Hybrid', description: 'Bench seating meets laundry.', tileImages: _getTiles(1), controls: _baseControls),
  StorageStyle(id: 'smart_lighting', name: 'Smart Lighting Utility', description: 'In-cabinet LEDs and motion sensors.', tileImages: _getTiles(2), controls: _baseControls),
  StorageStyle(id: 'waterproof_setup', name: 'Waterproof Utility', description: 'For wet zones and basements.', tileImages: _getTiles(3), controls: _baseControls),
  StorageStyle(id: 'compact_apartment', name: 'Compact Apartment', description: 'Hidden in a closet.', tileImages: _getTiles(4), controls: _baseControls),
  StorageStyle(id: 'minimal_monochrome', name: 'Minimal Monochrome', description: 'One color everywhere.', tileImages: _getTiles(5), controls: _baseControls),
  StorageStyle(id: 'showroom_organizer', name: 'Pro "Showroom"', description: 'The influencer aesthetic.', tileImages: _getTiles(0), controls: _baseControls),

  // Custom
  StorageStyle(
    id: 'custom_advanced',
    name: 'Custom (Advanced)',
    description: 'Full control via prompt engineering.',
    tileImages: _getTiles(1),
    controls: [
      ..._baseControls,
      const StyleControl(id: 'strictness', label: 'AI Strictness', type: ControlType.slider, defaultValue: 0.6),
    ],
  ),
];
