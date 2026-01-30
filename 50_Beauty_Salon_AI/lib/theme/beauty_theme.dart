import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BeautyTheme {
  // Runway Rose Luxe Palette
  static const Color bg0 = Color(0xFFFFF7FB); // soft blush white
  static const Color bg1 = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surface2 = Color(0xFFF7EEF4);

  static const Color ink0 = Color(0xFF1B1020); // Titles
  static const Color ink1 = Color(0xFF3A2A40); // Body
  static const Color muted = Color(0xFF6C5A70);
  static const Color line = Color(0xFFE9DCE6);

  static const Color primary = Color(0xFFC24D7C); // Rose
  static const Color primarySoft = Color(0xFFF7D3E3);
  static const Color accent = Color(0xFF7A4EE6); // Orchid (small)
  static const Color accent2 = Color(0xFFD7B58A); // Champagne Gold
  static const Color accent3 = Color(0xFF2EC8A6); // Mint Glow

  static const Color success = Color(0xFF1C8B6A);
  static const Color danger = Color(0xFFC0392B);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bg0,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: Colors.white,
        secondary: accent2,
        onSecondary: ink0,
        error: danger,
        onError: Colors.white,
        background: bg0,
        onBackground: ink1,
        surface: surface,
        onSurface: ink1,
      ),
      typography: Typography.material2021(),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          color: ink0,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          color: ink0,
          fontWeight: FontWeight.w600,
        ),
        displaySmall: GoogleFonts.playfairDisplay(
          color: ink0,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: GoogleFonts.playfairDisplay(
          color: ink0,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          color: ink0,
          fontWeight: FontWeight.w500,
        ),
        headlineSmall: GoogleFonts.playfairDisplay(
          color: ink0,
          fontWeight: FontWeight.w500,
        ),
        titleLarge: GoogleFonts.inter(
          color: ink0,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.inter(
          color: ink1,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: GoogleFonts.inter(
          color: ink1,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: GoogleFonts.inter(
          color: ink1,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.inter(
          color: ink1,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        bodySmall: GoogleFonts.inter(
          color: muted,
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        labelLarge: GoogleFonts.inter(
          color: primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bg0.withOpacity(0.8),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: ink0,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: ink0),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
