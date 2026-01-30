enum ControlType { chips, slider, toggle, stepper }

class StyleControl {
  final String id;
  final String label;
  final ControlType type;
  final List<String>? options; // For chips
  final double? min; // For slider
  final double? max; // For slider
  final dynamic defaultValue; // String or double or bool

  const StyleControl({
    required this.id,
    required this.label,
    required this.type,
    this.options,
    this.min,
    this.max,
    this.defaultValue,
  });
}

class CamperStyle {
  final String id;
  final String name;
  final String description;
  final String moodboardAsset;
  final String basePrompt;
  final List<String> tags;
  final List<StyleControl> controls;

  const CamperStyle({
    required this.id,
    required this.name,
    required this.description,
    required this.moodboardAsset,
    required this.basePrompt,
    required this.tags,
    required this.controls,
  });
}
