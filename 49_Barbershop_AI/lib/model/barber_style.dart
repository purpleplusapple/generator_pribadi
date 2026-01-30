enum ControlType { toggle, slider, stepper, chips, text }

class BarberControl {
  final String id;
  final String label;
  final ControlType type;
  final dynamic defaultValue;
  final dynamic min; // For slider/stepper
  final dynamic max; // For slider/stepper
  final List<String>? options; // For chips

  const BarberControl({
    required this.id,
    required this.label,
    required this.type,
    required this.defaultValue,
    this.min,
    this.max,
    this.options,
  });
}

class BarberStyle {
  final String id;
  final String name;
  final String description;
  final String moodboardAsset; // Path to SVG in assets/style_moodboards/
  final List<BarberControl> controls;
  final String promptModifier; // The text added to the AI prompt

  const BarberStyle({
    required this.id,
    required this.name,
    required this.description,
    required this.moodboardAsset,
    required this.controls,
    required this.promptModifier,
  });
}
