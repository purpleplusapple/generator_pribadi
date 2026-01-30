import 'package:flutter/material.dart';

class BeautyTokens {
  // Radius
  static const double radiusS = 8.0;
  static const double radiusM = 16.0;
  static const double radiusL = 24.0;
  static const double radiusXL = 32.0;

  // Spacing
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double spaceXL = 32.0;
  static const double space2XL = 48.0;

  // Shadows (Soft Bloom)
  static final List<BoxShadow> shadowSoft = [
    BoxShadow(
      color: const Color(0xFFC24D7C).withOpacity(0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
      spreadRadius: -4,
    ),
  ];

  static final List<BoxShadow> shadowFloat = [
    BoxShadow(
      color: const Color(0xFF1B1020).withOpacity(0.12),
      blurRadius: 24,
      offset: const Offset(0, 12),
      spreadRadius: -6,
    ),
  ];

  // Liquid Glass Decoration
  static BoxDecoration liquidGlass({
    Color tint = Colors.white,
    double opacity = 0.7,
    double radius = radiusL,
    bool border = true,
  }) {
    return BoxDecoration(
      color: tint.withOpacity(opacity),
      borderRadius: BorderRadius.circular(radius),
      border: border
          ? Border.all(color: Colors.white.withOpacity(0.6), width: 1.5)
          : null,
      boxShadow: [
        BoxShadow(
          color: Colors.white.withOpacity(0.5),
          blurRadius: 10,
          spreadRadius: 0,
          offset: const Offset(-2, -2), // Inner light
        ),
        ...shadowSoft,
      ],
    );
  }
}
