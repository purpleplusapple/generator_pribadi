import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'apartment_tokens.dart';

// Shim for backward compatibility during refactor, mapped to new tokens
class DesignTokens {
  static const Color bg0 = ApartmentTokens.bg0;
  static const Color bg1 = ApartmentTokens.bg1;
  static const Color surface = ApartmentTokens.surface;
  static const Color surface2 = ApartmentTokens.surface; // Map to surface in light mode

  static const Color ink0 = ApartmentTokens.ink0;
  static const Color ink1 = ApartmentTokens.ink1;
  static const Color muted = ApartmentTokens.muted;

  static const Color primary = ApartmentTokens.primary;
  static const Color primarySoft = ApartmentTokens.primarySoft;

  static const Color accent = ApartmentTokens.accent;
  static const Color accent2 = ApartmentTokens.accent2;
  static const Color line = ApartmentTokens.line;

  static const Color danger = ApartmentTokens.danger;
  static const Color success = ApartmentTokens.success;

  static const double radiusS = 12.0;
  static const double radiusM = ApartmentTokens.r16;
  static const double radiusL = ApartmentTokens.r22;
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: ApartmentTokens.bg0,
      primaryColor: ApartmentTokens.primary,
      colorScheme: const ColorScheme.light(
        primary: ApartmentTokens.primary,
        secondary: ApartmentTokens.accent,
        surface: ApartmentTokens.surface,
        background: ApartmentTokens.bg0,
        error: ApartmentTokens.danger,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: ApartmentTokens.ink0,
        onBackground: ApartmentTokens.ink0,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.sora(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: ApartmentTokens.ink0,
        ),
        displayMedium: GoogleFonts.sora(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: ApartmentTokens.ink0,
        ),
        displaySmall: GoogleFonts.sora(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: ApartmentTokens.ink0,
        ),
        headlineLarge: GoogleFonts.sora(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: ApartmentTokens.ink0,
        ),
        headlineMedium: GoogleFonts.sora(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ApartmentTokens.ink0,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: ApartmentTokens.ink0,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: ApartmentTokens.ink1,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: ApartmentTokens.ink1,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: ApartmentTokens.ink0,
        ),
      ),
      cardTheme: CardTheme(
        color: ApartmentTokens.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ApartmentTokens.r16),
          side: const BorderSide(color: ApartmentTokens.line, width: 1),
        ),
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      iconTheme: const IconThemeData(
        color: ApartmentTokens.ink0,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ApartmentTokens.bg0,
        elevation: 0,
        iconTheme: IconThemeData(color: ApartmentTokens.ink0),
        titleTextStyle: TextStyle(color: ApartmentTokens.ink0, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Keep getter for legacy calls, but return new theme
  static ThemeData get darkTheme => theme;
}
