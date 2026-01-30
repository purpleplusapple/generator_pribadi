// lib/theme/design_tokens.dart
// Speakeasy Luxe Design Tokens
// "Home speakeasy + cocktail lounge + boutique bar"

import 'package:flutter/material.dart';

// =================== COLORS ===================

class MiniBarColors {
  MiniBarColors._();

  // Backgrounds
  static const bg0 = Color(0xFF08090D); // Deepest black
  static const bg1 = Color(0xFF0E111A); // Slightly lighter
  static const surface = Color(0xFF141A27); // Card surface
  static const surface2 = Color(0xFF1B2436); // Elevated surface

  // Ink (Text)
  static const ink0 = Color(0xFFF5F2ED); // Primary titles (Warm white)
  static const ink1 = Color(0xFFD9D4CD); // Body text (Warm gray)
  static const muted = Color(0xFFA8A19A); // Secondary text
  static const line = Color(0xFF2A3144); // Dividers

  // Accents
  static const primary = Color(0xFFF0B35A); // Amber Glow
  static const primarySoft = Color(0xFF2A2218); // Amber wash
  static const brass = Color(0xFFC9A45B); // Brass highlights
  static const emerald = Color(0xFF2FA37B); // Accent 2
  static const wine = Color(0xFFB85C7A); // Accent 3

  // States
  static const success = Color(0xFF2DBA8A);
  static const danger = Color(0xFFD14B4B);

  // Helper
  static Color primaryOpacity(double val) => primary.withValues(alpha: val);
  static Color surfaceOpacity(double val) => surface.withValues(alpha: val);
}

// =================== TYPOGRAPHY ===================

// Headings: Playfair Display (Art Deco Editorial)
// Body: Inter (Clean Modern)

class MiniBarFonts {
  MiniBarFonts._();

  static const headingFamily = 'Playfair Display';
  static const bodyFamily = 'Inter';
}
