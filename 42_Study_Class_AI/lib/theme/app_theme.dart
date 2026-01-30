// lib/theme/app_theme.dart
// Complete Design System for Study Class AI
// Premium Academia aesthetic: Midnight Navy, Brass, Serif fonts

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'study_tokens.dart';

// =================== COLOR PALETTE ===================

class StudyAIColors {
  StudyAIColors._();

  static const bg0 = StudyTokens.bg0;
  static const bg1 = StudyTokens.bg1;
  static const surface = StudyTokens.surface;
  static const surface2 = StudyTokens.surface2;

  static const ink0 = StudyTokens.ink0;
  static const ink1 = StudyTokens.ink1;
  static const muted = StudyTokens.muted;

  static const primary = StudyTokens.primary;
  static const primarySoft = StudyTokens.primarySoft;

  static const accentBlue = StudyTokens.accentBlue;
  static const accentEmerald = StudyTokens.accentEmerald;

  static const success = StudyTokens.success;
  static const danger = StudyTokens.danger;
  static const line = StudyTokens.line;
}

// =================== GRADIENTS ===================

class StudyAIGradients {
  StudyAIGradients._();

  static const background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [StudyTokens.bg0, StudyTokens.bg1],
  );

  static const primaryCta = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [StudyTokens.primary, Color(0xFFE5C585)], // Amber to lighter gold
  );

  static const darkSurface = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [StudyTokens.surface, StudyTokens.surface2],
  );

  static const glowOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x00000000), Color(0xCC0A0D14)],
  );
}

// =================== TYPOGRAPHY ===================

class StudyAIText {
  StudyAIText._();

  static final TextStyle _headingFont = GoogleFonts.dmSerifDisplay(
    color: StudyTokens.ink0,
  );

  static final TextStyle _bodyFont = GoogleFonts.inter(
    color: StudyTokens.ink1,
  );

  static final h1 = _headingFont.copyWith(
    fontSize: 32, fontWeight: FontWeight.w400, height: 1.2, letterSpacing: -0.5,
  );

  static final h2 = _headingFont.copyWith(
    fontSize: 26, fontWeight: FontWeight.w400, height: 1.3, letterSpacing: -0.3,
  );

  static final h3 = _headingFont.copyWith(
    fontSize: 22, fontWeight: FontWeight.w400, height: 1.4, letterSpacing: -0.2,
  );

  static final body = _bodyFont.copyWith(
    fontSize: 16, fontWeight: FontWeight.w400, height: 1.5,
  );

  static final bodyMedium = _bodyFont.copyWith(
    fontSize: 16, fontWeight: FontWeight.w500, height: 1.5,
  );

  static final bodySmall = _bodyFont.copyWith(
    fontSize: 14, fontWeight: FontWeight.w400, height: 1.4,
    color: StudyTokens.muted,
  );

  static final label = _bodyFont.copyWith(
    fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5,
    color: StudyTokens.muted,
  );

  static final button = _bodyFont.copyWith(
    fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.3,
    color: StudyTokens.bg0,
  );
}

// =================== SPACING ===================

class StudyAISpacing {
  StudyAISpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double section = 48;
}

// =================== RADIUS ===================

class StudyAIRadii {
  StudyAIRadii._();

  static const double chip = 12;
  static const double button = 16;
  static const double card = 16;
  static const double sheet = 26;

  static BorderRadius get chipRadius => BorderRadius.circular(chip);
  static BorderRadius get buttonRadius => BorderRadius.circular(button);
  static BorderRadius get cardRadius => BorderRadius.circular(card);
  static BorderRadius get sheetRadius => BorderRadius.vertical(top: Radius.circular(sheet));
}

// =================== SHADOWS ===================

class StudyAIShadows {
  StudyAIShadows._();

  static List<BoxShadow> get card => [
    BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 16, offset: const Offset(0, 4)),
    BoxShadow(color: StudyTokens.primary.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 0)), // Inner glow hint
  ];

  static List<BoxShadow> get elevated => [
    BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 24, offset: const Offset(0, 8)),
    BoxShadow(color: StudyTokens.primary.withValues(alpha: 0.08), blurRadius: 12, spreadRadius: 1), // Amber glow
  ];
}

// =================== THEME DATA ===================

final studyClassAITheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  colorScheme: ColorScheme.dark(
    primary: StudyTokens.primary,
    secondary: StudyTokens.accentBlue,
    tertiary: StudyTokens.muted,
    error: StudyTokens.danger,
    surface: StudyTokens.surface,
    onSurface: StudyTokens.ink0,
    onPrimary: StudyTokens.bg0,
    background: StudyTokens.bg0,
  ),

  scaffoldBackgroundColor: StudyTokens.bg0,

  appBarTheme: AppBarTheme(
    centerTitle: false,
    elevation: 0,
    backgroundColor: StudyTokens.bg0,
    foregroundColor: StudyTokens.ink0,
    titleTextStyle: StudyAIText.h2,
  ),

  textTheme: TextTheme(
    displayLarge: StudyAIText.h1,
    displayMedium: StudyAIText.h2,
    displaySmall: StudyAIText.h3,
    bodyLarge: StudyAIText.body,
    bodyMedium: StudyAIText.bodyMedium,
    bodySmall: StudyAIText.bodySmall,
    labelSmall: StudyAIText.label,
  ),

  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: StudyAIRadii.cardRadius),
    color: StudyTokens.surface,
    margin: EdgeInsets.zero,
  ),

  chipTheme: ChipThemeData(
    backgroundColor: StudyTokens.surface2,
    labelStyle: StudyAIText.bodySmall.copyWith(color: StudyTokens.ink1),
    shape: RoundedRectangleBorder(
      borderRadius: StudyAIRadii.chipRadius,
      side: const BorderSide(color: StudyTokens.line),
    ),
    selectedColor: StudyTokens.primarySoft,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: StudyTokens.primary,
      foregroundColor: StudyTokens.bg0,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: StudyAISpacing.xl, vertical: StudyAISpacing.base),
      shape: RoundedRectangleBorder(borderRadius: StudyAIRadii.buttonRadius),
      textStyle: StudyAIText.button,
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: StudyTokens.ink1,
      side: const BorderSide(color: StudyTokens.line),
      shape: RoundedRectangleBorder(borderRadius: StudyAIRadii.buttonRadius),
      textStyle: StudyAIText.bodyMedium,
    ),
  ),
);
