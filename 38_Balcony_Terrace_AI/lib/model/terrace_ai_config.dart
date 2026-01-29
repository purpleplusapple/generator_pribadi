// lib/model/terrace_ai_config.dart
import 'image_result_data.dart';

class TerraceAIConfig {
  const TerraceAIConfig({
    this.originalImagePath,
    this.selectedStyleId,
    this.controlValues = const {},
    // Legacy support (optional)
    this.styleSelections = const {},
    this.reviewNotes,
    this.resultData,
    required this.timestamp,
  });

  final String? originalImagePath;
  final String? selectedStyleId;
  final Map<String, dynamic> controlValues;
  final Map<String, String> styleSelections; // Keep for safety or reuse
  final String? reviewNotes;
  final ImageResultData? resultData;
  final DateTime timestamp;

  factory TerraceAIConfig.empty() {
    return TerraceAIConfig(
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'originalImagePath': originalImagePath,
      'selectedStyleId': selectedStyleId,
      'controlValues': controlValues,
      'styleSelections': styleSelections,
      'reviewNotes': reviewNotes,
      'resultData': resultData?.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory TerraceAIConfig.fromJson(Map<String, dynamic> json) {
    return TerraceAIConfig(
      originalImagePath: json['originalImagePath'] as String?,
      selectedStyleId: json['selectedStyleId'] as String?,
      controlValues: Map<String, dynamic>.from(json['controlValues'] as Map? ?? {}),
      styleSelections: Map<String, String>.from(json['styleSelections'] as Map? ?? {}),
      reviewNotes: json['reviewNotes'] as String?,
      resultData: json['resultData'] != null
          ? ImageResultData.fromJson(json['resultData'] as Map<String, dynamic>)
          : null,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  TerraceAIConfig copyWith({
    String? originalImagePath,
    String? selectedStyleId,
    Map<String, dynamic>? controlValues,
    Map<String, String>? styleSelections,
    String? reviewNotes,
    ImageResultData? resultData,
    DateTime? timestamp,
  }) {
    return TerraceAIConfig(
      originalImagePath: originalImagePath ?? this.originalImagePath,
      selectedStyleId: selectedStyleId ?? this.selectedStyleId,
      controlValues: controlValues ?? this.controlValues,
      styleSelections: styleSelections ?? this.styleSelections,
      reviewNotes: reviewNotes ?? this.reviewNotes,
      resultData: resultData ?? this.resultData,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  bool get hasOriginalImage => originalImagePath != null && originalImagePath!.isNotEmpty;
  bool get hasStyle => selectedStyleId != null;
  bool get isReadyForGeneration => hasOriginalImage && hasStyle;
}
