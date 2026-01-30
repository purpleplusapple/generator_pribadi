// lib/model/camper_ai_config.dart
import 'image_result_data.dart';

class CamperAIConfig {
  const CamperAIConfig({
    this.originalImagePath,
    this.selectedStyleId,
    this.styleControlValues = const {},
    this.reviewNotes,
    this.resultData,
    required this.timestamp,
  });

  final String? originalImagePath;
  final String? selectedStyleId;
  final Map<String, dynamic> styleControlValues;
  final String? reviewNotes;
  final ImageResultData? resultData;
  final DateTime timestamp;

  factory CamperAIConfig.empty() {
    return CamperAIConfig(
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'originalImagePath': originalImagePath,
      'selectedStyleId': selectedStyleId,
      'styleControlValues': styleControlValues,
      'reviewNotes': reviewNotes,
      'resultData': resultData?.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory CamperAIConfig.fromJson(Map<String, dynamic> json) {
    return CamperAIConfig(
      originalImagePath: json['originalImagePath'],
      selectedStyleId: json['selectedStyleId'],
      styleControlValues: json['styleControlValues'] ?? {},
      reviewNotes: json['reviewNotes'],
      resultData: json['resultData'] != null ? ImageResultData.fromJson(json['resultData']) : null,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  // copyWith for immutable updates
  CamperAIConfig copyWith({
    String? originalImagePath,
    String? selectedStyleId,
    Map<String, dynamic>? styleControlValues,
    String? reviewNotes,
    ImageResultData? resultData,
    DateTime? timestamp,
  }) {
    return CamperAIConfig(
      originalImagePath: originalImagePath ?? this.originalImagePath,
      selectedStyleId: selectedStyleId ?? this.selectedStyleId,
      styleControlValues: styleControlValues ?? this.styleControlValues,
      reviewNotes: reviewNotes ?? this.reviewNotes,
      resultData: resultData ?? this.resultData,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  // Validation helpers
  bool get hasOriginalImage =>
      originalImagePath != null && originalImagePath!.isNotEmpty;

  bool get hasStyleSelected => selectedStyleId != null;
}
