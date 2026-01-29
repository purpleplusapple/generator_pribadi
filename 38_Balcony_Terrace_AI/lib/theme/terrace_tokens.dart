import 'package:flutter/material.dart';

/// Design Tokens for Balcony Terrace AI
/// Theme: Cinematic Outdoor (Night Garden + Lantern)
class TerraceTokens {
  TerraceTokens._();

  // ================= COLORS =================

  // Backgrounds (Dark Night)
  static const Color bg0 = Color(0xFF070B0A); // Deepest black-green
  static const Color bg1 = Color(0xFF0B1110); // Slightly lighter

  // Surfaces (Glass/Panels)
  static const Color surface = Color(0xFF101A18);
  static const Color surface2 = Color(0xFF142220);

  // Typography (Ink)
  static const Color ink0 = Color(0xFFF2F3EE); // Titles
  static const Color ink1 = Color(0xFFD2D7CF); // Body
  static const Color muted = Color(0xFFA3ACA2); // Secondary

  // Brand Colors
  static const Color primaryEmerald = Color(0xFF2FA37B);
  static const Color accentAmber = Color(0xFFE7A35A);
  static const Color accentViolet = Color(0xFF6F7CFF);

  // Functional
  static const Color line = Color(0xFF263332);
  static const Color success = Color(0xFF2DBA8A);
  static const Color danger = Color(0xFFD14B4B);

  // ================= RADIUS =================

  static const double radiusSmall = 12.0;
  static const double radiusMedium = 18.0;
  static const double radiusLarge = 24.0;
  static const double radiusXLarge = 30.0;

  // ================= SPACING =================

  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 24.0;
  static const double spaceXl = 32.0;
  static const double spaceXxl = 48.0;

  // ================= SHADOWS =================

  static List<BoxShadow> get shadowSoft => [
    BoxShadow(
      color: accentAmber.withValues(alpha: 0.05),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.4),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get shadowGlow => [
    BoxShadow(
      color: accentAmber.withValues(alpha: 0.15),
      blurRadius: 30,
      spreadRadius: 2,
    ),
  ];
}
