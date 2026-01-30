import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Road-Luxe Design Tokens for Camper Van Interior AI
class CamperTokens {
  CamperTokens._();

  // =================== COLORS ===================
  // Road-Luxe Midnight Palette

  static const Color bg0 = Color(0xFF0B0E12); // Deep graphite
  static const Color bg1 = Color(0xFF101520);
  static const Color surface = Color(0xFF171C2A);
  static const Color surface2 = Color(0xFF1E2538);

  static const Color ink0 = Color(0xFFF4F1EA); // Titles
  static const Color ink1 = Color(0xFFD8D3C8); // Body
  static const Color muted = Color(0xFFAAA397);
  static const Color line = Color(0xFF2C3246);

  // Primary Accents (Craft + Sunrise)
  static const Color primary = Color(0xFFD39B63); // Warm Wood
  static const Color primarySoft = Color(0xFF2A2119); // Wood tint surface
  static const Color accentForest = Color(0xFF2FA37B);
  static const Color accentAmber = Color(0xFFF0B35A);
  static const Color accentSky = Color(0xFF5B8CFF);

  static const Color success = Color(0xFF2DBA8A);
  static const Color danger = Color(0xFFD14B4B);

  // =================== SPACING ===================

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double base = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // =================== RADIUS ===================

  static const double rXs = 4.0;
  static const double rSm = 8.0;
  static const double rMd = 16.0; // Soft but sturdy
  static const double rLg = 20.0;
  static const double rXl = 26.0;

  // =================== TYPOGRAPHY ===================
  // Option A: Fraunces (Headings) + Inter (Body)

  static TextTheme getTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.fraunces(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: ink0,
      ),
      displayMedium: GoogleFonts.fraunces(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: ink0,
      ),
      displaySmall: GoogleFonts.fraunces(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: ink0,
      ),
      headlineMedium: GoogleFonts.fraunces(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: ink0,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: ink1,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: ink1,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: ink0,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        color: muted,
      ),
    );
  }
}
