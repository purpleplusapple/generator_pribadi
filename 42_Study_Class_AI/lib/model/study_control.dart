// lib/model/study_control.dart

enum StudyControlType {
  chips,
  slider,
  toggle,
  stepper,
  multiSelect,
  text,
}

class StudyControl {
  final String id;
  final String label;
  final StudyControlType type;
  final dynamic defaultValue;
  final List<String>? options; // For chips
  final double? min; // For slider
  final double? max; // For slider
  final int? divisions; // For slider
  final String? suffix; // For slider display (e.g. "%")

  const StudyControl({
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

class StudyControlValue {
  final String controlId;
  final dynamic value;

  const StudyControlValue({
    required this.controlId,
    required this.value,
  });

  Map<String, dynamic> toJson() => {
    'controlId': controlId,
    'value': value,
  };

  factory StudyControlValue.fromJson(Map<String, dynamic> json) {
    return StudyControlValue(
      controlId: json['controlId'],
      value: json['value'],
    );
  }
}
