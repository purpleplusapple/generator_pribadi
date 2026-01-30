// lib/theme/mini_bar_theme.dart
// Speakeasy Luxe Theme Implementation

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'design_tokens.dart';

// =================== TEXT STYLES ===================

class MiniBarText {
  MiniBarText._();

  static TextStyle get _headingBase => GoogleFonts.playfairDisplay(
    color: MiniBarColors.ink0,
  );

  static TextStyle get _bodyBase => GoogleFonts.inter(
    color: MiniBarColors.ink1,
  );

  // Headings
  static final h1 = _headingBase.copyWith(
    fontSize: 32, fontWeight: FontWeight.w700, height: 1.2, letterSpacing: -0.5,
  );

  static final h2 = _headingBase.copyWith(
    fontSize: 26, fontWeight: FontWeight.w600, height: 1.3, letterSpacing: -0.3,
  );

  static final h3 = _headingBase.copyWith(
    fontSize: 22, fontWeight: FontWeight.w600, height: 1.4, letterSpacing: -0.2,
  );

  static final h4 = _headingBase.copyWith(
    fontSize: 18, fontWeight: FontWeight.w600, height: 1.4, letterSpacing: 0,
  );

  // Body
  static final body = _bodyBase.copyWith(
    fontSize: 16, fontWeight: FontWeight.w400, height: 1.5,
  );

  static final bodyMedium = _bodyBase.copyWith(
    fontSize: 15, fontWeight: FontWeight.w500, height: 1.5,
  );

  static final small = _bodyBase.copyWith(
    fontSize: 13, fontWeight: FontWeight.w400, height: 1.4,
    color: MiniBarColors.muted,
  );

  // UI Elements
  static final button = _bodyBase.copyWith(
    fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.5,
    color: MiniBarColors.bg0, // Dark text on amber button
  );

  static final chip = _bodyBase.copyWith(
    fontSize: 13, fontWeight: FontWeight.w500,
  );
}

// =================== SPACING & RADII ===================

class MiniBarSpacing {
  MiniBarSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 20;
  static const double xl = 32;
  static const double xxl = 48;
}

class MiniBarRadii {
  MiniBarRadii._();
  static const double k12 = 12;
  static const double k18 = 18; // Soft Lounge
  static const double k24 = 24;
  static const double k30 = 30; // Pill
}

// =================== SHADOWS & GLASS ===================

class MiniBarShadows {
  MiniBarShadows._();

  static List<BoxShadow> get softAmber => [
    BoxShadow(color: MiniBarColors.primary.withValues(alpha: 0.1), blurRadius: 20, spreadRadius: 0, offset: const Offset(0, 4)),
  ];

  static List<BoxShadow> get deep => [
    BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 30, spreadRadius: 5),
  ];
}

class MiniBarGlass {
  MiniBarGlass._();
  static const double blurSigma = 10;
  static final Color wash = MiniBarColors.surface2.withValues(alpha: 0.7);
  static final Color border = MiniBarColors.line.withValues(alpha: 0.5);
}

// =================== THEME DATA ===================

final miniBarTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  scaffoldBackgroundColor: MiniBarColors.bg0,

  colorScheme: ColorScheme.dark(
    primary: MiniBarColors.primary,
    secondary: MiniBarColors.brass,
    surface: MiniBarColors.surface,
    onSurface: MiniBarColors.ink0,
    background: MiniBarColors.bg0,
    onBackground: MiniBarColors.ink0,
    error: MiniBarColors.danger,
  ),

  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: MiniBarText.h3,
    iconTheme: const IconThemeData(color: MiniBarColors.ink0),
  ),

  cardTheme: CardThemeData(
    color: MiniBarColors.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(MiniBarRadii.k18),
      side: BorderSide(color: MiniBarColors.line, width: 1),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: MiniBarColors.primary,
      foregroundColor: MiniBarColors.bg0,
      elevation: 0,
      textStyle: MiniBarText.button,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MiniBarRadii.k30)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: MiniBarColors.ink0,
      side: const BorderSide(color: MiniBarColors.line),
      textStyle: MiniBarText.button.copyWith(color: MiniBarColors.ink0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MiniBarRadii.k30)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: MiniBarColors.bg1,
    hintStyle: MiniBarText.small.copyWith(color: MiniBarColors.muted),
    contentPadding: const EdgeInsets.all(16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(MiniBarRadii.k12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(MiniBarRadii.k12),
      borderSide: const BorderSide(color: MiniBarColors.primary),
    ),
  ),

  dividerTheme: const DividerThemeData(
    color: MiniBarColors.line,
    thickness: 1,
  ),
);
