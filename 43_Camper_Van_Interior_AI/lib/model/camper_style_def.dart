// lib/model/camper_style_def.dart

enum ControlType { chips, slider, toggle, stepper, text }

class StyleControl {
  final String id;
  final String label;
  final ControlType type;
  final List<String>? options; // For chips
  final double? min; // For slider
  final double? max; // For slider
  final int? defaultInt;
  final double? defaultDouble;
  final bool? defaultBool;
  final String? defaultString;

  const StyleControl({
    required this.id,
    required this.label,
    required this.type,
    this.options,
    this.min,
    this.max,
    this.defaultInt,
    this.defaultDouble,
    this.defaultBool,
    this.defaultString,
  });
}

class CamperStyle {
  final String id;
  final String name;
  final String description;
  final String moodboardImage; // Asset path (SVG)
  final List<String> tags; // For filtering
  final List<StyleControl> controls;

  const CamperStyle({
    required this.id,
    required this.name,
    required this.description,
    required this.moodboardImage,
    required this.tags,
    required this.controls,
  });
}
