
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'design_tokens.dart';

// The main theme data
final terraceTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: DesignTokens.bg0,

  // Color Scheme
  colorScheme: const ColorScheme.dark(
    primary: DesignTokens.primary,
    onPrimary: DesignTokens.bg0, // Text on primary button
    secondary: DesignTokens.accent,
    onSecondary: DesignTokens.bg0,
    surface: DesignTokens.surface,
    onSurface: DesignTokens.ink1,
    error: DesignTokens.danger,
    onError: DesignTokens.ink0,
    outline: DesignTokens.line,
  ),

  // Typography
  textTheme: TextTheme(
    displayLarge: GoogleFonts.fraunces(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: DesignTokens.ink0,
      height: 1.2,
    ),
    displayMedium: GoogleFonts.fraunces(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: DesignTokens.ink0,
      height: 1.3,
    ),
    displaySmall: GoogleFonts.fraunces(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: DesignTokens.ink0,
      height: 1.4,
    ),
    headlineMedium: GoogleFonts.fraunces(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: DesignTokens.ink0,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: DesignTokens.ink1,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: DesignTokens.ink1,
      height: 1.5,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: DesignTokens.muted,
      height: 1.4,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: DesignTokens.bg0,
      letterSpacing: 0.5,
    ),
  ),

  // Component Themes
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: GoogleFonts.fraunces(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: DesignTokens.ink0,
    ),
    iconTheme: const IconThemeData(color: DesignTokens.ink0),
  ),

  cardTheme: CardTheme(
    color: DesignTokens.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: DesignTokens.rMedium,
      side: const BorderSide(color: DesignTokens.line, width: 1),
    ),
    margin: EdgeInsets.zero,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: DesignTokens.primary,
      foregroundColor: DesignTokens.bg0,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: DesignTokens.rMedium),
      textStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: DesignTokens.ink0,
      side: const BorderSide(color: DesignTokens.line),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: DesignTokens.rMedium),
      textStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),

  iconTheme: const IconThemeData(
    color: DesignTokens.ink0,
    size: 24,
  ),

  dividerTheme: const DividerThemeData(
    color: DesignTokens.line,
    thickness: 1,
    space: 1,
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: DesignTokens.surface2,
    hintStyle: GoogleFonts.inter(color: DesignTokens.muted),
    border: OutlineInputBorder(
      borderRadius: DesignTokens.rSmall,
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: DesignTokens.rSmall,
      borderSide: const BorderSide(color: DesignTokens.line),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: DesignTokens.rSmall,
      borderSide: const BorderSide(color: DesignTokens.primary),
    ),
    contentPadding: const EdgeInsets.all(DesignTokens.s16),
  ),
);
