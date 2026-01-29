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
  final double? min; // For slider
  final double? max; // For slider
  final int? divisions; // For slider
  final String? suffix; // For slider display (e.g., "%")

  const StyleControl({
    required this.id,
    required this.label,
    required this.type,
    this.defaultValue,
    this.options,
    this.min,
    this.max,
    this.divisions,
    this.suffix,
  });
}
