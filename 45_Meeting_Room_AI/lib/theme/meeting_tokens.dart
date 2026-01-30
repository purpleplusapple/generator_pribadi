import 'package:flutter/material.dart';

class MeetingTokens {
  MeetingTokens._();

  // Color Palette (Executive Graphite)
  static const Color bg0 = Color(0xFF0A0C10);
  static const Color bg1 = Color(0xFF0F131B);
  static const Color surface = Color(0xFF151B28);
  static const Color surface2 = Color(0xFF1C2436);

  static const Color ink0 = Color(0xFFF4F2ED); // Titles
  static const Color ink1 = Color(0xFFD7D3CB); // Body
  static const Color muted = Color(0xFFA7A199);
  static const Color line = Color(0xFF2A3448);

  static const Color primary = Color(0xFFB9C3D1); // Brushed Steel
  static const Color primarySoft = Color(0xFF202734);
  static const Color accent = Color(0xFF3E7BFA); // Executive Blue
  static const Color accentTeal = Color(0xFF2EC8A6);
  static const Color accentGold = Color(0xFFD0A85C); // Tiny highlights

  static const Color success = Color(0xFF2DBA8A);
  static const Color danger = Color(0xFFD14B4B);

  // Spacing
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space48 = 48.0;

  // Radius
  static const double radiusXS = 8.0;
  static const double radiusSM = 14.0;
  static const double radiusMD = 18.0;
  static const double radiusLG = 22.0;
  static const double radiusXL = 32.0;

  // Glass
  static const double glassBlur = 20.0;
  static const double glassOpacity = 0.08;
  static const double glassBorderOpacity = 0.12;

  // Gradients
  static const LinearGradient metalGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE0E6ED), Color(0xFFB9C3D1)],
  );

  static const LinearGradient executiveGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surface, surface2],
  );
}
