
import 'dart:ui';
import 'package:flutter/material.dart';

class DesignTokens {
  DesignTokens._();

  // ================= COLORS =================

  // Backgrounds
  static const Color bg0 = Color(0xFF070B0A); // Main background
  static const Color bg1 = Color(0xFF0B1110); // Slightly lighter background

  // Surfaces
  static const Color surface = Color(0xFF101A18); // Cards, sheets
  static const Color surface2 = Color(0xFF142220); // Higher elevation

  // Ink / Text
  static const Color ink0 = Color(0xFFF2F3EE); // Titles, high emphasis
  static const Color ink1 = Color(0xFFD2D7CF); // Body text (DO NOT USE DARKER)
  static const Color muted = Color(0xFFA3ACA2); // Secondary text, placeholders

  // Lines / Borders
  static const Color line = Color(0xFF263332);

  // Brand Colors
  static const Color primary = Color(0xFF2FA37B); // Emerald
  static const Color primarySoft = Color(0xFF182A23); // Background for primary icons

  static const Color accent = Color(0xFFE7A35A); // Lantern Amber
  static const Color accentSoft = Color(0xFF2A2218); // Warm glow background

  static const Color accent2 = Color(0xFF6F7CFF); // Violet (use sparingly)

  // Functional
  static const Color success = Color(0xFF2DBA8A);
  static const Color danger = Color(0xFFD14B4B);

  // ================= RADIUS =================

  static const double radiusSmall = 12.0;
  static const double radiusMedium = 18.0;
  static const double radiusLarge = 24.0;
  static const double radiusXLarge = 30.0;

  static BorderRadius get rSmall => BorderRadius.circular(radiusSmall);
  static BorderRadius get rMedium => BorderRadius.circular(radiusMedium);
  static BorderRadius get rLarge => BorderRadius.circular(radiusLarge);
  static BorderRadius get rXLarge => BorderRadius.circular(radiusXLarge);

  // ================= SPACING =================

  static const double s4 = 4.0;
  static const double s8 = 8.0;
  static const double s12 = 12.0;
  static const double s16 = 16.0;
  static const double s20 = 20.0;
  static const double s24 = 24.0;
  static const double s32 = 32.0;
  static const double s48 = 48.0;

  // ================= SHADOWS =================

  static List<BoxShadow> get shadowSoft => [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get shadowGlowAmber => [
    BoxShadow(
      color: accent.withOpacity(0.15),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];
}
