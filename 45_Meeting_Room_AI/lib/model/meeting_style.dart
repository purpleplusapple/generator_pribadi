import 'package:flutter/material.dart';

enum ControlType {
  stepper,
  chips,
  slider,
  toggle,
  text,
}

class StyleControl {
  final String id;
  final String label;
  final ControlType type;
  final List<String>? options; // For chips
  final double? min;
  final double? max;
  final int? step; // For stepper
  final dynamic defaultValue;

  const StyleControl({
    required this.id,
    required this.label,
    required this.type,
    this.options,
    this.min,
    this.max,
    this.step,
    required this.defaultValue,
  });
}

class MeetingStyle {
  final String id;
  final String name;
  final String description;
  final List<String> moodboardImages; // Paths to 4 images
  final List<StyleControl> controls;

  // Base prompt for AI generation
  final String basePrompt;

  const MeetingStyle({
    required this.id,
    required this.name,
    required this.description,
    required this.moodboardImages,
    required this.controls,
    required this.basePrompt,
  });
}

class MeetingStyleSelection {
  final String styleId;
  final Map<String, dynamic> controlValues;

  const MeetingStyleSelection({
    required this.styleId,
    required this.controlValues,
  });

  Map<String, dynamic> toJson() => {
    'styleId': styleId,
    'controlValues': controlValues,
  };

  factory MeetingStyleSelection.fromJson(Map<String, dynamic> json) {
    return MeetingStyleSelection(
      styleId: json['styleId'] as String,
      controlValues: Map<String, dynamic>.from(json['controlValues'] as Map),
    );
  }

  MeetingStyleSelection copyWith({
    String? styleId,
    Map<String, dynamic>? controlValues,
  }) {
    return MeetingStyleSelection(
      styleId: styleId ?? this.styleId,
      controlValues: controlValues ?? this.controlValues,
    );
  }
}
