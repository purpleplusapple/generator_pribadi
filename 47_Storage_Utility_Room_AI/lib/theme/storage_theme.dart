import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StorageColors {
  static const Color bg0 = Color(0xFF0A0C0F);
  static const Color bg1 = Color(0xFF0F141B);
  static const Color surface = Color(0xFF141B25);
  static const Color surface2 = Color(0xFF1B2533);

  static const Color ink0 = Color(0xFFF4F2ED);
  static const Color ink1 = Color(0xFFD7D3CB);
  static const Color muted = Color(0xFFA7A199);
  static const Color line = Color(0xFF2A3448);

  // Accents
  static const Color primaryLime = Color(0xFFB7F34A);
  static const Color primarySoft = Color(0xFF1F2A12);
  static const Color accentAmber = Color(0xFFF0B35A);
  static const Color accentTeal = Color(0xFF2EC8A6);
  static const Color accentSteel = Color(0xFFB9C3D1); // Buttons/Borders

  static const Color success = Color(0xFF2DBA8A);
  static const Color danger = Color(0xFFD14B4B);
}

class StorageTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: StorageColors.bg0,
      primaryColor: StorageColors.primaryLime,
      colorScheme: const ColorScheme.dark(
        primary: StorageColors.primaryLime,
        secondary: StorageColors.accentAmber,
        surface: StorageColors.surface,
        background: StorageColors.bg0,
        error: StorageColors.danger,
        onPrimary: Colors.black, // Lime is bright
        onSurface: StorageColors.ink0,
      ),

      textTheme: TextTheme(
        displayLarge: GoogleFonts.sora(
          fontSize: 32, fontWeight: FontWeight.bold, color: StorageColors.ink0, letterSpacing: -0.5),
        displayMedium: GoogleFonts.sora(
          fontSize: 28, fontWeight: FontWeight.bold, color: StorageColors.ink0, letterSpacing: -0.5),
        displaySmall: GoogleFonts.sora(
          fontSize: 24, fontWeight: FontWeight.w600, color: StorageColors.ink0),

        headlineLarge: GoogleFonts.sora(
          fontSize: 20, fontWeight: FontWeight.w600, color: StorageColors.ink0),
        headlineMedium: GoogleFonts.sora(
          fontSize: 18, fontWeight: FontWeight.w600, color: StorageColors.ink0),

        bodyLarge: GoogleFonts.inter(
          fontSize: 16, color: StorageColors.ink1, height: 1.5),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14, color: StorageColors.ink1, height: 1.5),
        bodySmall: GoogleFonts.inter(
          fontSize: 12, color: StorageColors.muted, height: 1.4),

        labelLarge: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w600, color: StorageColors.ink0),
      ),

      cardTheme: CardTheme(
        color: StorageColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: StorageColors.line, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: StorageColors.primaryLime,
          foregroundColor: Colors.black,
          elevation: 0,
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: StorageColors.ink0,
          side: const BorderSide(color: StorageColors.line),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: StorageColors.line,
        thickness: 1,
      ),
    );
  }
}
