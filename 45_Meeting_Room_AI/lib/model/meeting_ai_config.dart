// lib/model/meeting_ai_config.dart
// Master configuration model containing all wizard data

import 'image_result_data.dart';
import 'meeting_style.dart';

class MeetingAIConfig {
  const MeetingAIConfig({
    this.originalImagePath,
    this.styleSelection,
    this.reviewNotes,
    this.resultData,
    required this.timestamp,
  });

  final String? originalImagePath;
  final MeetingStyleSelection? styleSelection;
  final String? reviewNotes;
  final ImageResultData? resultData;
  final DateTime timestamp;

  // Factory constructor for creating a new empty config
  factory MeetingAIConfig.empty() {
    return MeetingAIConfig(
      timestamp: DateTime.now(),
    );
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'originalImagePath': originalImagePath,
      'styleSelection': styleSelection?.toJson(),
      'reviewNotes': reviewNotes,
      'resultData': resultData?.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory MeetingAIConfig.fromJson(Map<String, dynamic> json) {
    return MeetingAIConfig(
      originalImagePath: json['originalImagePath'] as String?,
      styleSelection: json['styleSelection'] != null
          ? MeetingStyleSelection.fromJson(json['styleSelection'] as Map<String, dynamic>)
          : null,
      reviewNotes: json['reviewNotes'] as String?,
      resultData: json['resultData'] != null
          ? ImageResultData.fromJson(json['resultData'] as Map<String, dynamic>)
          : null,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  // copyWith for immutable updates
  MeetingAIConfig copyWith({
    String? originalImagePath,
    MeetingStyleSelection? styleSelection,
    String? reviewNotes,
    ImageResultData? resultData,
    DateTime? timestamp,
  }) {
    return MeetingAIConfig(
      originalImagePath: originalImagePath ?? this.originalImagePath,
      styleSelection: styleSelection ?? this.styleSelection,
      reviewNotes: reviewNotes ?? this.reviewNotes,
      resultData: resultData ?? this.resultData,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  // Helper method to set style
  MeetingAIConfig setStyle(String styleId, {Map<String, dynamic>? controls}) {
    return copyWith(
      styleSelection: MeetingStyleSelection(
        styleId: styleId,
        controlValues: controls ?? {},
      ),
    );
  }

  // Helper to update control
  MeetingAIConfig updateControl(String key, dynamic value) {
    if (styleSelection == null) return this;
    final newControls = Map<String, dynamic>.from(styleSelection!.controlValues);
    newControls[key] = value;
    return copyWith(
      styleSelection: styleSelection!.copyWith(controlValues: newControls),
    );
  }

  // Validation helpers
  bool get hasOriginalImage =>
      originalImagePath != null && originalImagePath!.isNotEmpty;

  bool get hasStyleSelection => styleSelection != null;

  bool get isReadyForGeneration =>
      hasOriginalImage && hasStyleSelection;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MeetingAIConfig &&
        other.originalImagePath == originalImagePath &&
        other.styleSelection?.styleId == styleSelection?.styleId &&
        other.reviewNotes == reviewNotes &&
        other.resultData == resultData &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return Object.hash(
      originalImagePath,
      styleSelection?.styleId,
      reviewNotes,
      resultData,
      timestamp,
    );
  }

  @override
  String toString() {
    return 'MeetingAIConfig(originalImage: $originalImagePath, '
        'style: ${styleSelection?.styleId}, '
        'timestamp: $timestamp)';
  }
}
