// lib/model/shoe_ai_config.dart
// Master configuration model containing all wizard data

import 'image_result_data.dart';

class ShoeAIConfig {
  const ShoeAIConfig({
    this.originalImagePath,
    this.styleSelections = const {},
    this.reviewNotes,
    this.resultData,
    required this.timestamp,
  });

  final String? originalImagePath;
  final Map<String, String> styleSelections;
  final String? reviewNotes;
  final ImageResultData? resultData;
  final DateTime timestamp;

  // Factory constructor for creating a new empty config
  factory ShoeAIConfig.empty() {
    return ShoeAIConfig(
      timestamp: DateTime.now(),
    );
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'originalImagePath': originalImagePath,
      'styleSelections': styleSelections,
      'reviewNotes': reviewNotes,
      'resultData': resultData?.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ShoeAIConfig.fromJson(Map<String, dynamic> json) {
    return ShoeAIConfig(
      originalImagePath: json['originalImagePath'] as String?,
      styleSelections: Map<String, String>.from(
        json['styleSelections'] as Map? ?? {},
      ),
      reviewNotes: json['reviewNotes'] as String?,
      resultData: json['resultData'] != null
          ? ImageResultData.fromJson(json['resultData'] as Map<String, dynamic>)
          : null,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  // copyWith for immutable updates
  ShoeAIConfig copyWith({
    String? originalImagePath,
    Map<String, String>? styleSelections,
    String? reviewNotes,
    ImageResultData? resultData,
    DateTime? timestamp,
  }) {
    return ShoeAIConfig(
      originalImagePath: originalImagePath ?? this.originalImagePath,
      styleSelections: styleSelections ?? this.styleSelections,
      reviewNotes: reviewNotes ?? this.reviewNotes,
      resultData: resultData ?? this.resultData,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  // Helper method to add a style selection
  ShoeAIConfig addStyleSelection(String category, String value) {
    final newSelections = Map<String, String>.from(styleSelections);
    newSelections[category] = value;
    return copyWith(styleSelections: newSelections);
  }

  // Helper method to remove a style selection
  ShoeAIConfig removeStyleSelection(String category) {
    final newSelections = Map<String, String>.from(styleSelections);
    newSelections.remove(category);
    return copyWith(styleSelections: newSelections);
  }

  // Validation helpers
  bool get hasOriginalImage => 
      originalImagePath != null && originalImagePath!.isNotEmpty;
  
  bool get hasMinimumStyleSelections => styleSelections.length >= 2;
  
  bool get isReadyForGeneration => 
      hasOriginalImage && hasMinimumStyleSelections;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShoeAIConfig &&
        other.originalImagePath == originalImagePath &&
        _mapsEqual(other.styleSelections, styleSelections) &&
        other.reviewNotes == reviewNotes &&
        other.resultData == resultData &&
        other.timestamp == timestamp;
  }

  bool _mapsEqual(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (a[key] != b[key]) return false;
    }
    return true;
  }

  @override
  int get hashCode {
    return Object.hash(
      originalImagePath,
      Object.hashAll(styleSelections.entries.map((e) => Object.hash(e.key, e.value))),
      reviewNotes,
      resultData,
      timestamp,
    );
  }

  @override
  String toString() {
    return 'ShoeAIConfig(originalImage: $originalImagePath, '
        'selections: ${styleSelections.length}, '
        'timestamp: $timestamp)';
  }
}
