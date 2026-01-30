// lib/model/study_ai_config.dart
import 'image_result_data.dart';

class StudyAIConfig {
  const StudyAIConfig({
    this.originalImagePath,
    this.selectedStyleId,
    this.controlValues = const {},
    this.userNote,
    this.resultData,
    required this.timestamp,
  });

  final String? originalImagePath;
  final String? selectedStyleId;
  final Map<String, dynamic> controlValues;
  final String? userNote;
  final ImageResultData? resultData;
  final DateTime timestamp;

  factory StudyAIConfig.empty() {
    return StudyAIConfig(
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'originalImagePath': originalImagePath,
      'selectedStyleId': selectedStyleId,
      'controlValues': controlValues,
      'userNote': userNote,
      'resultData': resultData?.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory StudyAIConfig.fromJson(Map<String, dynamic> json) {
    return StudyAIConfig(
      originalImagePath: json['originalImagePath'] as String?,
      selectedStyleId: json['selectedStyleId'] as String?,
      controlValues: Map<String, dynamic>.from(json['controlValues'] as Map? ?? {}),
      userNote: json['userNote'] as String?,
      resultData: json['resultData'] != null
          ? ImageResultData.fromJson(json['resultData'] as Map<String, dynamic>)
          : null,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  StudyAIConfig copyWith({
    String? originalImagePath,
    String? selectedStyleId,
    Map<String, dynamic>? controlValues,
    String? userNote,
    ImageResultData? resultData,
    DateTime? timestamp,
  }) {
    return StudyAIConfig(
      originalImagePath: originalImagePath ?? this.originalImagePath,
      selectedStyleId: selectedStyleId ?? this.selectedStyleId,
      controlValues: controlValues ?? this.controlValues,
      userNote: userNote ?? this.userNote,
      resultData: resultData ?? this.resultData,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  bool get hasOriginalImage => originalImagePath != null && originalImagePath!.isNotEmpty;
  bool get hasStyle => selectedStyleId != null;
  bool get isReadyForGeneration => hasOriginalImage && hasStyle;
}
