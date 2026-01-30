// lib/model/mini_bar_config.dart
// Master configuration model for Mini Bar AI

import 'image_result_data.dart';

class MiniBarConfig {
  const MiniBarConfig({
    this.originalImagePath,
    this.selectedStyleId,
    this.controlValues = const {},
    this.resultData,
    required this.timestamp,
  });

  final String? originalImagePath;
  final String? selectedStyleId;
  final Map<String, dynamic> controlValues; // Stores values keyed by control ID
  final ImageResultData? resultData;
  final DateTime timestamp;

  // Factory constructor for creating a new empty config
  factory MiniBarConfig.empty() {
    return MiniBarConfig(
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

  factory MiniBarConfig.fromJson(Map<String, dynamic> json) {
    return MiniBarConfig(
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
  MiniBarConfig copyWith({
    String? originalImagePath,
    String? selectedStyleId,
    Map<String, dynamic>? controlValues,
    ImageResultData? resultData,
    DateTime? timestamp,
  }) {
    return MiniBarConfig(
      originalImagePath: originalImagePath ?? this.originalImagePath,
      selectedStyleId: selectedStyleId ?? this.selectedStyleId,
      controlValues: controlValues ?? this.controlValues,
      resultData: resultData ?? this.resultData,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  // Helpers
  MiniBarConfig updateControl(String key, dynamic value) {
    final newControls = Map<String, dynamic>.from(controlValues);
    newControls[key] = value;
    return copyWith(controlValues: newControls);
  }

  bool get isReadyForGeneration =>
      originalImagePath != null && selectedStyleId != null;
}
