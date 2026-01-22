import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DesignTokens {
  static const Color bg0 = Color(0xFF0B0E14);
  static const Color bg1 = Color(0xFF0F1420);
  static const Color surface = Color(0xFF141A2A);
  static const Color surface2 = Color(0xFF1A2236);

  static const Color ink0 = Color(0xFFF4F1EC);
  static const Color ink1 = Color(0xFFD6D2CC);
  static const Color muted = Color(0xFFA39E96);

  static const Color primary = Color(0xFFC8A56A);
  static const Color primarySoft = Color(0xFF2A2318);

  static const Color accent = Color(0xFF7B5CFF);
  static const Color accent2 = Color(0xFF2DD4BF);
  static const Color line = Color(0xFF2A3144);

  static const Color danger = Color(0xFFD14B4B);
  static const Color success = Color(0xFF2DBA8A);

  static const double radiusS = 12.0;
  static const double radiusM = 18.0;
  static const double radiusL = 28.0;
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: DesignTokens.bg0,
      primaryColor: DesignTokens.primary,
      colorScheme: const ColorScheme.dark(
        primary: DesignTokens.primary,
        secondary: DesignTokens.accent,
        surface: DesignTokens.surface,
        background: DesignTokens.bg0,
        error: DesignTokens.danger,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: DesignTokens.ink0,
        onBackground: DesignTokens.ink0,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.dmSerifDisplay(
          fontSize: 32,
          color: DesignTokens.ink0,
        ),
        displayMedium: GoogleFonts.dmSerifDisplay(
          fontSize: 28,
          color: DesignTokens.ink0,
        ),
        displaySmall: GoogleFonts.dmSerifDisplay(
          fontSize: 24,
          color: DesignTokens.ink0,
        ),
        headlineLarge: GoogleFonts.dmSerifDisplay(
          fontSize: 22,
          color: DesignTokens.ink0,
        ),
        headlineMedium: GoogleFonts.dmSerifDisplay(
          fontSize: 20,
          color: DesignTokens.ink0,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: DesignTokens.ink0,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: DesignTokens.ink1,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: DesignTokens.ink1,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: DesignTokens.ink0,
        ),
      ),
      cardTheme: CardTheme(
        color: DesignTokens.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          side: const BorderSide(color: DesignTokens.line, width: 1),
        ),
        elevation: 0,
      ),
      iconTheme: const IconThemeData(
        color: DesignTokens.ink0,
      ),
    );
  }
}
