import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BarberTheme {
  // --- Colors ---
  static const Color bg0 = Color(0xFF07080B);
  static const Color bg1 = Color(0xFF0D1018);
  static const Color surface = Color(0xFF141A27);
  static const Color surface2 = Color(0xFF1C2436);
  static const Color line = Color(0xFF2A3144);

  static const Color ink0 = Color(0xFFF5F2ED); // Titles
  static const Color ink1 = Color(0xFFD9D4CD); // Body
  static const Color muted = Color(0xFFA8A19A);

  static const Color primary = Color(0xFFD0A85C); // Warm Gold
  static const Color primarySoft = Color(0xFF2A2417);
  static const Color accentRed = Color(0xFFD64B4B);
  static const Color accentBlue = Color(0xFF3E7BFA);
  static const Color accentMint = Color(0xFF2EC8A6);

  static const Color success = Color(0xFF2DBA8A);
  static const Color danger = Color(0xFFD14B4B);

  // --- Theme Data ---
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg0,
      primaryColor: primary,

      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: primarySoft,
        surface: surface,
        background: bg0,
        onPrimary: bg0,
        onSurface: ink0,
        outline: line,
      ),

      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          color: ink0,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          color: ink0,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        displaySmall: GoogleFonts.playfairDisplay(
          color: ink0,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: GoogleFonts.playfairDisplay(
          color: ink0,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          color: ink0,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: GoogleFonts.inter(
          color: ink0,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.inter(
          color: ink0,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: GoogleFonts.inter(
          color: ink1,
          fontSize: 16,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          color: ink1,
          fontSize: 14,
          height: 1.5,
        ),
        labelLarge: GoogleFonts.inter(
          color: ink0,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        labelMedium: GoogleFonts.inter(
          color: muted,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      cardTheme: CardTheme(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: line, width: 1),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: line,
        thickness: 1,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: bg0,
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary, width: 1.5),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
           shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bg1,
        hintStyle: GoogleFonts.inter(color: muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary),
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surface,
        modalBackgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }
}
