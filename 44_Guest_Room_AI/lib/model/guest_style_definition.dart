// lib/model/guest_style_definition.dart

enum ControlType {
  slider,
  toggle,
  chips,
  text,
}

class StyleControl {
  final String id;
  final String label;
  final ControlType type;
  final dynamic defaultValue;
  final List<String>? options; // For chips
  final double? min;
  final double? max;

  const StyleControl({
    required this.id,
    required this.label,
    required this.type,
    required this.defaultValue,
    this.options,
    this.min,
    this.max,
  });
}

class GuestStyleDefinition {
  final String id;
  final String name;
  final String description;
  final List<String> tileImages; // List of 4 asset paths
  final List<String> tags;
  final List<StyleControl> controls;
  final String basePrompt;

  const GuestStyleDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.tileImages,
    required this.tags,
    required this.controls,
    required this.basePrompt,
  });
}
