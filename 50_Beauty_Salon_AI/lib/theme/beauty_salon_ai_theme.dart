// lib/theme/beauty_salon_ai_theme.dart
// Complete Design System for Beauty Salon AI
// Aesthetic: Clean luxury, glossy, editorial, soft glass

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// =================== COLOR PALETTE ===================

/// High Contrast Beauty Salon color palette
class BeautyAIColors {
  BeautyAIColors._();

  // Prompt Specs
  static const bg0 = Color(0xFFFFF7FB);
  static const bg1 = Color(0xFFFFFFFF);
  static const surface = Color(0xFFFFFFFF);

  // Updated to strictly dark neutral colors as requested
  static const ink0 = Color(0xFF111111); // Main Titles (Black)
  static const ink1 = Color(0xFF333333); // Body Text (Dark Grey)
  static const muted = Color(0xFF666666); // Secondary Text (Medium Grey)

  static const primary = Color(0xFFC24D7C); // Rose
  static const primarySoft = Color(0xFFF7D3E3); // Chips/Surfaces
  static const accent = Color(0xFF7A4EE6); // Orchid Highlight
  static const line = Color(0xFFE9DCE6);

  // Mappings for semantic usage
  static const mainBackground = bg0;
  static const textMain = ink0;
  static const textBody = ink1;
  static const textMuted = muted;

  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFC107);
  static const error = Color(0xFFE53935);

  // Helper Opacities
  static Color primaryWithOpacity(double opacity) => primary.withValues(alpha: opacity);
  static Color inkWithOpacity(double opacity) => ink0.withValues(alpha: opacity);
}

// =================== GRADIENTS ===================

class BeautyAIGradients {
  BeautyAIGradients._();

  static const background = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [BeautyAIColors.bg0, BeautyAIColors.bg1],
  );

  static const glassOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xCCFFFFFF), // White 80%
      Color(0x99FFFFFF), // White 60%
    ],
  );

  static const primaryRose = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [BeautyAIColors.primary, Color(0xFFA03D65)],
  );

  static const accentOrchid = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [BeautyAIColors.accent, Color(0xFF6236C5)],
  );
}

// =================== TYPOGRAPHY ===================

class BeautyAIText {
  BeautyAIText._();

  // Headings: Playfair Display
  static final TextStyle _headingStyle = GoogleFonts.playfairDisplay(
    color: BeautyAIColors.ink0,
  );

  // Body: Inter
  static final TextStyle _bodyStyle = GoogleFonts.inter(
    color: BeautyAIColors.ink1,
  );

  static final h1 = _headingStyle.copyWith(
    fontSize: 32, fontWeight: FontWeight.w700, height: 1.1, letterSpacing: -0.5,
  );

  static final h2 = _headingStyle.copyWith(
    fontSize: 24, fontWeight: FontWeight.w600, height: 1.2, letterSpacing: -0.3,
  );

  static final h3 = _headingStyle.copyWith(
    fontSize: 20, fontWeight: FontWeight.w600, height: 1.3, letterSpacing: -0.2,
  );

  static final body = _bodyStyle.copyWith(
    fontSize: 16, fontWeight: FontWeight.w400, height: 1.5,
  );

  static final bodyMedium = _bodyStyle.copyWith(
    fontSize: 16, fontWeight: FontWeight.w500, height: 1.5,
  );

  static final bodySmall = _bodyStyle.copyWith(
    fontSize: 14, fontWeight: FontWeight.w400, height: 1.4,
  );

  static final caption = _bodyStyle.copyWith(
    fontSize: 12, fontWeight: FontWeight.w500, height: 1.4,
    color: BeautyAIColors.muted,
  );

  static final button = _bodyStyle.copyWith(
    fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.2,
  );
}

// =================== SPACING ===================

class BeautyAISpacing {
  BeautyAISpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double huge = 48;
}

// =================== RADIUS ===================

class BeautyAIRadii {
  BeautyAIRadii._();

  static const double sm = 12;
  static const double md = 18; // Primary shape
  static const double lg = 24;
  static const double full = 999;

  static BorderRadius get smRadius => BorderRadius.circular(sm);
  static BorderRadius get mdRadius => BorderRadius.circular(md);
  static BorderRadius get lgRadius => BorderRadius.circular(lg);
  static BorderRadius get fullRadius => BorderRadius.circular(full);
}

// =================== SHADOWS ===================

class BeautyAIShadows {
  BeautyAIShadows._();

  // Soft, diffuse shadows (low opacity)
  static List<BoxShadow> get soft => [
    BoxShadow(color: BeautyAIColors.ink0.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
  ];

  static List<BoxShadow> get floating => [
    BoxShadow(color: BeautyAIColors.ink0.withValues(alpha: 0.08), blurRadius: 24, offset: const Offset(0, 12)),
    BoxShadow(color: BeautyAIColors.primary.withValues(alpha: 0.05), blurRadius: 16, offset: const Offset(0, 4)),
  ];

  static List<BoxShadow> get glass => [
     BoxShadow(color: Colors.white.withValues(alpha: 0.5), blurRadius: 0, spreadRadius: 1), // Inner highlight feeling
     BoxShadow(color: BeautyAIColors.ink0.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4)),
  ];

  // Keep goldGlow for compatibility if needed, or map to new style
  static List<BoxShadow> goldGlow({double opacity = 0.45}) => [
    BoxShadow(color: BeautyAIColors.accent.withValues(alpha: opacity), blurRadius: 32, spreadRadius: 2),
  ];
}

// =================== GLASS FORMULA ===================

class BeautyAIGlass {
  BeautyAIGlass._();

  static const double blurSigma = 16;
  static const double opacity = 0.82; // 82% white
  static const Color borderColor = BeautyAIColors.line;
}

// =================== MOTION ===================

class BeautyAIMotion {
  BeautyAIMotion._();

  static const Duration fast = Duration(milliseconds: 200);
  static const Duration standard = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 600);

  static const Curve easeOut = Curves.easeOutCubic;
}

// =================== THEME DATA ===================

final beautySalonAITheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  colorScheme: ColorScheme.light(
    primary: BeautyAIColors.primary,
    secondary: BeautyAIColors.accent,
    tertiary: BeautyAIColors.muted,
    surface: BeautyAIColors.bg0,
    onSurface: BeautyAIColors.ink0,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    outline: BeautyAIColors.line,
  ),

  scaffoldBackgroundColor: BeautyAIColors.bg0,

  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: BeautyAIColors.ink0,
    titleTextStyle: BeautyAIText.h3,
    iconTheme: IconThemeData(color: BeautyAIColors.ink0),
  ),

  textTheme: TextTheme(
    displayLarge: BeautyAIText.h1,
    displayMedium: BeautyAIText.h2,
    displaySmall: BeautyAIText.h3,
    bodyLarge: BeautyAIText.body,
    bodyMedium: BeautyAIText.bodyMedium,
    bodySmall: BeautyAIText.caption,
    labelLarge: BeautyAIText.button,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: BeautyAIColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BeautyAIRadii.fullRadius),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      textStyle: BeautyAIText.button,
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: BeautyAIColors.surface,
    border: OutlineInputBorder(
      borderRadius: BeautyAIRadii.mdRadius,
      borderSide: BorderSide(color: BeautyAIColors.line),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BeautyAIRadii.mdRadius,
      borderSide: BorderSide(color: BeautyAIColors.line),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BeautyAIRadii.mdRadius,
      borderSide: const BorderSide(color: BeautyAIColors.primary, width: 1.5),
    ),
  ),
);
