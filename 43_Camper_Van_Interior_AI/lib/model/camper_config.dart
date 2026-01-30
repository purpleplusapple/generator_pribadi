// lib/model/camper_config.dart
// Master configuration model containing all wizard data for Camper Van AI

import 'image_result_data.dart';

class CamperConfig {
  const CamperConfig({
    this.originalImagePath,
    this.selectedStyleId,
    this.styleParams = const {},
    this.reviewNotes,
    this.resultData,
    required this.timestamp,
  });

  final String? originalImagePath;
  final String? selectedStyleId;
  final Map<String, dynamic> styleParams;
  final String? reviewNotes;
  final ImageResultData? resultData;
  final DateTime timestamp;

  factory CamperConfig.empty() {
    return CamperConfig(
      timestamp: DateTime.now(),
    );
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'originalImagePath': originalImagePath,
      'selectedStyleId': selectedStyleId,
      'styleParams': styleParams,
      'reviewNotes': reviewNotes,
      'resultData': resultData?.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory CamperConfig.fromJson(Map<String, dynamic> json) {
    return CamperConfig(
      originalImagePath: json['originalImagePath'] as String?,
      selectedStyleId: json['selectedStyleId'] as String?,
      styleParams: Map<String, dynamic>.from(json['styleParams'] as Map? ?? {}),
      reviewNotes: json['reviewNotes'] as String?,
      resultData: json['resultData'] != null
          ? ImageResultData.fromJson(json['resultData'] as Map<String, dynamic>)
          : null,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  CamperConfig copyWith({
    String? originalImagePath,
    String? selectedStyleId,
    Map<String, dynamic>? styleParams,
    String? reviewNotes,
    ImageResultData? resultData,
    DateTime? timestamp,
  }) {
    return CamperConfig(
      originalImagePath: originalImagePath ?? this.originalImagePath,
      selectedStyleId: selectedStyleId ?? this.selectedStyleId,
      styleParams: styleParams ?? this.styleParams,
      reviewNotes: reviewNotes ?? this.reviewNotes,
      resultData: resultData ?? this.resultData,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  // Helper method to update a style param
  CamperConfig updateStyleParam(String key, dynamic value) {
    final newParams = Map<String, dynamic>.from(styleParams);
    newParams[key] = value;
    return copyWith(styleParams: newParams);
  }

  bool get hasOriginalImage =>
      originalImagePath != null && originalImagePath!.isNotEmpty;

  bool get hasStyleSelected => selectedStyleId != null;

  bool get isReadyForGeneration =>
      hasOriginalImage && hasStyleSelected;
}
