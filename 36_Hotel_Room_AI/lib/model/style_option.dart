// lib/model/style_option.dart
// Style option model for categorical selections

import 'package:flutter/material.dart';

class StyleOption {
  const StyleOption({
    required this.id,
    required this.category,
    required this.value,
    required this.label,
    this.icon,
  });

  final String id;
  final String category;
  final String value;
  final String label;
  final IconData? icon;

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'value': value,
      'label': label,
      // Note: IconData cannot be serialized directly
      // Will be reconstructed from predefined mapping if needed
    };
  }

  factory StyleOption.fromJson(Map<String, dynamic> json) {
    return StyleOption(
      id: json['id'] as String,
      category: json['category'] as String,
      value: json['value'] as String,
      label: json['label'] as String,
      // Icon will need to be set separately based on category
      icon: null,
    );
  }

  // copyWith for updates
  StyleOption copyWith({
    String? id,
    String? category,
    String? value,
    String? label,
    IconData? icon,
  }) {
    return StyleOption(
      id: id ?? this.id,
      category: category ?? this.category,
      value: value ?? this.value,
      label: label ?? this.label,
      icon: icon ?? this.icon,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StyleOption &&
        other.id == id &&
        other.category == category &&
        other.value == value &&
        other.label == label;
  }

  @override
  int get hashCode {
    return Object.hash(id, category, value, label);
  }

  @override
  String toString() {
    return 'StyleOption(id: $id, category: $category, value: $value, label: $label)';
  }
}
