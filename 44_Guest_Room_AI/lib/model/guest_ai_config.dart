// lib/model/guest_ai_config.dart
// Master configuration model containing all wizard data

import 'image_result_data.dart';

class GuestAIConfig {
  const GuestAIConfig({
    this.originalImagePath,
    this.selectedStyleId,
    this.controlValues = const {},
    this.resultData,
    required this.timestamp,
  });

  final String? originalImagePath;
  final String? selectedStyleId;
  final Map<String, dynamic> controlValues; // Map of control_id -> value
  final ImageResultData? resultData;
  final DateTime timestamp;

  // Factory constructor for creating a new empty config
  factory GuestAIConfig.empty() {
    return GuestAIConfig(
      timestamp: DateTime.now(),
    );
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'originalImagePath': originalImagePath,
      'selectedStyleId': selectedStyleId,
      'controlValues': controlValues,
      'resultData': resultData?.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory GuestAIConfig.fromJson(Map<String, dynamic> json) {
    return GuestAIConfig(
      originalImagePath: json['originalImagePath'] as String?,
      selectedStyleId: json['selectedStyleId'] as String?,
      controlValues: Map<String, dynamic>.from(json['controlValues'] as Map? ?? {}),
      resultData: json['resultData'] != null
          ? ImageResultData.fromJson(json['resultData'] as Map<String, dynamic>)
          : null,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  // copyWith for immutable updates
  GuestAIConfig copyWith({
    String? originalImagePath,
    String? selectedStyleId,
    Map<String, dynamic>? controlValues,
    ImageResultData? resultData,
    DateTime? timestamp,
  }) {
    return GuestAIConfig(
      originalImagePath: originalImagePath ?? this.originalImagePath,
      selectedStyleId: selectedStyleId ?? this.selectedStyleId,
      controlValues: controlValues ?? this.controlValues,
      resultData: resultData ?? this.resultData,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  // Helpers
  bool get hasOriginalImage => originalImagePath != null && originalImagePath!.isNotEmpty;
  bool get hasStyle => selectedStyleId != null;
  bool get isReady => hasOriginalImage && hasStyle;

  dynamic getControlValue(String key) => controlValues[key];

  GuestAIConfig setControlValue(String key, dynamic value) {
    final newControls = Map<String, dynamic>.from(controlValues);
    newControls[key] = value;
    return copyWith(controlValues: newControls);
  }
}
