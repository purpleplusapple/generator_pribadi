// lib/model/barber_config.dart
// Master configuration for Barbershop AI

import 'image_result_data.dart';

class BarberConfig {
  const BarberConfig({
    this.originalImagePath,
    this.selectedStyleId,
    this.controlValues = const {},
    this.resultData,
    required this.timestamp,
  });

  final String? originalImagePath;
  final String? selectedStyleId;
  final Map<String, dynamic> controlValues;
  final ImageResultData? resultData;
  final DateTime timestamp;

  factory BarberConfig.empty() {
    return BarberConfig(
      timestamp: DateTime.now(),
    );
  }

  factory BarberConfig.fromJson(Map<String, dynamic> json) {
    return BarberConfig(
      originalImagePath: json['originalImagePath'] as String?,
      selectedStyleId: json['selectedStyleId'] as String?,
      controlValues: Map<String, dynamic>.from(json['controlValues'] as Map? ?? {}),
      resultData: json['resultData'] != null
          ? ImageResultData.fromJson(json['resultData'] as Map<String, dynamic>)
          : null,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'originalImagePath': originalImagePath,
      'selectedStyleId': selectedStyleId,
      'controlValues': controlValues,
      'resultData': resultData?.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  BarberConfig copyWith({
    String? originalImagePath,
    String? selectedStyleId,
    Map<String, dynamic>? controlValues,
    ImageResultData? resultData,
    DateTime? timestamp,
  }) {
    return BarberConfig(
      originalImagePath: originalImagePath ?? this.originalImagePath,
      selectedStyleId: selectedStyleId ?? this.selectedStyleId,
      controlValues: controlValues ?? this.controlValues,
      resultData: resultData ?? this.resultData,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  // Update a single control value
  BarberConfig updateControl(String key, dynamic value) {
    final newControls = Map<String, dynamic>.from(controlValues);
    newControls[key] = value;
    return copyWith(controlValues: newControls);
  }

  bool get isReadyForGeneration =>
      originalImagePath != null &&
      selectedStyleId != null;
}
