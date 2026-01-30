import 'package:flutter/material.dart';

enum ControlType {
  chip,
  slider,
  toggle,
  stepper,
  text,
}

class StyleControlDef {
  final String id;
  final String label;
  final ControlType type;
  final List<String>? options; // For chips
  final double? min; // For slider
  final double? max; // For slider
  final int? divisions; // For slider
  final dynamic defaultValue;

  const StyleControlDef({
    required this.id,
    required this.label,
    required this.type,
    this.options,
    this.min,
    this.max,
    this.divisions,
    required this.defaultValue,
  });
}

class MiniBarStyle {
  final String id;
  final String name;
  final String description;
  final String moodboardImage;
  final List<StyleControlDef> controls;
  final String promptModifier;

  const MiniBarStyle({
    required this.id,
    required this.name,
    required this.description,
    required this.moodboardImage,
    required this.controls,
    required this.promptModifier,
  });
}

// Global accessor for styles
final List<MiniBarStyle> kMiniBarStyles = [
  // 1. Speakeasy Noir Bar
  MiniBarStyle(
    id: 'speakeasy_noir',
    name: 'Speakeasy Noir',
    description: 'Dark, smoky, hidden luxury with velvet and brass.',
    moodboardImage: 'assets/style_moodboards/style_1.svg',
    promptModifier: 'speakeasy style, dark noir atmosphere, velvet textures, brass accents, dim moody lighting, hidden bar aesthetic',
    controls: _commonControls,
  ),
  // 2. Modern Marble Bar
  MiniBarStyle(
    id: 'modern_marble',
    name: 'Modern Marble',
    description: 'Clean lines, heavy stone usage, cool lighting.',
    moodboardImage: 'assets/style_moodboards/style_2.svg',
    promptModifier: 'modern luxury bar, carrera marble counter, cool white lighting, minimalist geometric shelves',
    controls: _commonControls,
  ),
  // ... (I will implement the rest dynamically or mapped to generic controls for brevity in this file, but list them all)
  ..._generateRemainingStyles(),

  // Custom
  MiniBarStyle(
    id: 'custom_advanced',
    name: 'Custom (Advanced)',
    description: 'Build your own unique bar style from scratch.',
    moodboardImage: 'assets/style_moodboards/style_29.svg',
    promptModifier: 'custom design',
    controls: [
      ..._commonControls,
      const StyleControlDef(id: 'custom_prompt', label: 'Custom Prompt', type: ControlType.text, defaultValue: ''),
      const StyleControlDef(id: 'negative_prompt', label: 'Avoid (Negative)', type: ControlType.text, defaultValue: ''),
      const StyleControlDef(id: 'creativity', label: 'Creativity Level', type: ControlType.slider, min: 0, max: 100, divisions: 10, defaultValue: 60.0),
    ],
  ),
];

// Helper to generate the 28 required styles with standard controls
List<MiniBarStyle> _generateRemainingStyles() {
  final List<String> names = [
    "Japandi Mini Bar", "Scandinavian Light",
    "Tropical Tiki Corner", "Industrial Pipe Shelf Bar", "Luxury Hotel Mini Bar", "Art Deco Glam Bar",
    "Mid-Century Bar Cart", "Wine Cellar Wall Mini", "Coffee + Bar Hybrid", "Zero-Proof Mocktail Bar",
    "Compact Pantry Bar", "Outdoor Balcony Mini Bar", "Neon-Subtle Lounge Bar", "Warm Wood Craft Bar",
    "Black & Brass Bar", "Concrete Minimal Bar", "Boho Rattan Bar", "Coastal Breeze Bar",
    "Retro Diner Bar", "Futuristic Clean Bar", "Budget DIY Bar Corner", "Premium Custom Cabinetry Bar",
    "Hidden Fold-Out Bar", "Corner Shelf Bar", "Sink + Ice Station Bar", "Bottle Showcase Gallery",
  ];

  return List.generate(names.length, (index) {
    final name = names[index];
    final id = name.toLowerCase().replaceAll(' ', '_').replaceAll('&', 'and').replaceAll('+', 'plus');
    // Offset index by 2 because we manually defined the first 2
    final imgIndex = index + 3;

    // Add specific controls for some styles as requested
    List<StyleControlDef> specificControls = [..._commonControls];

    if (name.contains("Wine Cellar")) {
       specificControls.addAll([
         const StyleControlDef(id: 'cooling', label: 'Cooling Unit', type: ControlType.toggle, defaultValue: true),
         const StyleControlDef(id: 'capacity', label: 'Bottle Capacity', type: ControlType.chip, options: ['Small', 'Medium', 'Large'], defaultValue: 'Medium'),
       ]);
    } else if (name.contains("Sink")) {
       specificControls.add(const StyleControlDef(id: 'sink_size', label: 'Sink Size', type: ControlType.chip, options: ['Compact', 'Full', 'Double'], defaultValue: 'Compact'));
    }

    return MiniBarStyle(
      id: id,
      name: name,
      description: 'Premium $name design with bespoke details.',
      moodboardImage: 'assets/style_moodboards/style_$imgIndex.svg',
      promptModifier: '$name design, photorealistic interior, 8k resolution',
      controls: specificControls,
    );
  });
}

const List<StyleControlDef> _commonControls = [
  StyleControlDef(
    id: 'size',
    label: 'Bar Size',
    type: ControlType.chip,
    options: ['Compact', 'Medium', 'Full Wall'],
    defaultValue: 'Medium',
  ),
  StyleControlDef(
    id: 'material',
    label: 'Counter Material',
    type: ControlType.chip,
    options: ['Marble', 'Wood', 'Concrete', 'Metal', 'Glass'],
    defaultValue: 'Marble',
  ),
  StyleControlDef(
    id: 'lighting',
    label: 'Lighting',
    type: ControlType.chip,
    options: ['Under-shelf', 'Warm Pendant', 'Neon Subtle', 'Candle'],
    defaultValue: 'Under-shelf',
  ),
  StyleControlDef(
    id: 'storage',
    label: 'Storage Level',
    type: ControlType.slider,
    min: 0,
    max: 100,
    divisions: 4,
    defaultValue: 50.0,
  ),
  StyleControlDef(
    id: 'note',
    label: 'Special Note',
    type: ControlType.text,
    defaultValue: '',
  ),
];
