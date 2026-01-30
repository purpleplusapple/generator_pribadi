import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CamperTokens {
  // Road-Luxe Midnight Palette
  static const Color bg0 = Color(0xFF0B0E12); // Deep graphite
  static const Color bg1 = Color(0xFF101520);
  static const Color surface = Color(0xFF171C2A);
  static const Color surface2 = Color(0xFF1E2538);

  static const Color ink0 = Color(0xFFF4F1EA); // Titles
  static const Color ink1 = Color(0xFFD8D3C8); // Body
  static const Color muted = Color(0xFFAAA397);
  static const Color line = Color(0xFF2C3246);

  static const Color primary = Color(0xFFD39B63); // Warm Wood
  static const Color primarySoft = Color(0xFF2A2119); // Wood tint surface

  static const Color accentForest = Color(0xFF2FA37B);
  static const Color accentSunrise = Color(0xFFF0B35A);
  static const Color accentSky = Color(0xFF5B8CFF);

  static const Color success = Color(0xFF2DBA8A);
  static const Color danger = Color(0xFFD14B4B);

  // Radius
  static const double radiusS = 8.0;
  static const double radiusM = 16.0;
  static const double radiusL = 26.0; // "Soft but sturdy"

  // Spacing
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double spaceXL = 32.0;

  // Typography - Road-Luxe (Fraunces + Inter)
  static TextTheme textTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: GoogleFonts.fraunces(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: ink0,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.fraunces(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: ink0,
        letterSpacing: -0.5,
      ),
      displaySmall: GoogleFonts.fraunces(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: ink0,
      ),
      headlineMedium: GoogleFonts.fraunces(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: ink0,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: ink0,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: ink0,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: ink1,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: ink1,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: muted,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: ink0,
        letterSpacing: 0.5,
      ),
    );
  }
}
