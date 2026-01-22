// lib/model/image_result_data.dart
// Generated result data model

enum GenerationStatus {
  pending,
  processing,
  completed,
  failed,
}

class ImageResultData {
  const ImageResultData({
    this.generatedImagePath,
    required this.prompt,
    required this.generatedAt,
    required this.modelVersion,
    required this.status,
  });

  final String? generatedImagePath;
  final String prompt;
  final DateTime generatedAt;
  final String modelVersion;
  final GenerationStatus status;

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'generatedImagePath': generatedImagePath,
      'prompt': prompt,
      'generatedAt': generatedAt.toIso8601String(),
      'modelVersion': modelVersion,
      'status': status.name,
    };
  }

  factory ImageResultData.fromJson(Map<String, dynamic> json) {
    return ImageResultData(
      generatedImagePath: json['generatedImagePath'] as String?,
      prompt: json['prompt'] as String,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      modelVersion: json['modelVersion'] as String,
      status: GenerationStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => GenerationStatus.pending,
      ),
    );
  }

  // copyWith for updates
  ImageResultData copyWith({
    String? generatedImagePath,
    String? prompt,
    DateTime? generatedAt,
    String? modelVersion,
    GenerationStatus? status,
  }) {
    return ImageResultData(
      generatedImagePath: generatedImagePath ?? this.generatedImagePath,
      prompt: prompt ?? this.prompt,
      generatedAt: generatedAt ?? this.generatedAt,
      modelVersion: modelVersion ?? this.modelVersion,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ImageResultData &&
        other.generatedImagePath == generatedImagePath &&
        other.prompt == prompt &&
        other.generatedAt == generatedAt &&
        other.modelVersion == modelVersion &&
        other.status == status;
  }

  @override
  int get hashCode {
    return Object.hash(
      generatedImagePath,
      prompt,
      generatedAt,
      modelVersion,
      status,
    );
  }
}
