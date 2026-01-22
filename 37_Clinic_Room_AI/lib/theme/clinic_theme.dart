// lib/theme/clinic_theme.dart
// Complete Design System for Clinic Room AI
// Medical Clean, Trustworthy, Professional

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// =================== COLOR PALETTE ===================

/// Clinic Medical Clean color palette
class ClinicColors {
  ClinicColors._();

  // Backgrounds
  static const bg0 = Color(0xFFF6FAFB); // Cool White (Scaffold)
  static const bg1 = Color(0xFFFFFFFF); // Surface White (Cards)
  static const surface = Color(0xFFFFFFFF);

  // Ink (Text)
  static const ink0 = Color(0xFF0F1A1C); // Titles (Darkest)
  static const ink1 = Color(0xFF223437); // Body (Dark Grey)
  static const ink2 = Color(0xFF556B70); // Muted/Secondary

  // Primary Branding
  static const primary = Color(0xFF138A8A); // Medical Teal
  static const primarySoft = Color(0xFFD7F1F0); // Light Teal bg
  static const accent = Color(0xFF2B6DE5); // Clinical Blue
  static const line = Color(0xFFE2EEF0); // Dividers/Borders

  // State Colors
  static const success = Color(0xFF1C8B6A);
  static const warning = Color(0xFFF1C40F);
  static const danger = Color(0xFFC0392B); // Professional Red

  // Opacity variants (Helpers)
  static Color primaryWithOpacity(double opacity) => primary.withValues(alpha: opacity);
  static Color inkWithOpacity(double opacity) => ink0.withValues(alpha: opacity);

  // Legacy Aliases (to be refactored)
  static const soleBlack = ink0;
  static const canvasWhite = bg1;
  static const leatherTan = primary;
  static const metallicGold = accent;
  static const laceGray = ink2;
  static const richBrown = bg0;
}

// =================== GRADIENTS ===================

class ClinicGradients {
  ClinicGradients._();

  static const background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [ClinicColors.bg0, ClinicColors.bg1],
  );

  static const primaryCta = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [ClinicColors.primary, Color(0xFF1AA1A1)], // Subtle teal gradient
  );

  static const blueAccent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ClinicColors.accent, Color(0xFF4B85EA)],
  );
}

// =================== TYPOGRAPHY ===================

class ClinicText {
  ClinicText._();

  static final TextStyle _headingStyle = GoogleFonts.sora(
    color: ClinicColors.ink0,
  );

  static final TextStyle _bodyStyle = GoogleFonts.inter(
    color: ClinicColors.ink1,
  );

  static final h1 = _headingStyle.copyWith(
    fontSize: 28, fontWeight: FontWeight.w700, height: 1.2, letterSpacing: -0.5,
  );

  static final h2 = _headingStyle.copyWith(
    fontSize: 24, fontWeight: FontWeight.w600, height: 1.3, letterSpacing: -0.3,
  );

  static final h3 = _headingStyle.copyWith(
    fontSize: 20, fontWeight: FontWeight.w600, height: 1.4, letterSpacing: -0.2,
  );

  static final body = _bodyStyle.copyWith(
    fontSize: 16, fontWeight: FontWeight.w400, height: 1.5,
  );

  static final bodyMedium = _bodyStyle.copyWith(
    fontSize: 16, fontWeight: FontWeight.w500, height: 1.5,
  );

  static final bodySemiBold = _bodyStyle.copyWith(
    fontSize: 16, fontWeight: FontWeight.w600, height: 1.5,
  );

  static final caption = _bodyStyle.copyWith(
    fontSize: 14, fontWeight: FontWeight.w400, height: 1.4,
    color: ClinicColors.ink2,
  );

  static final captionMedium = _bodyStyle.copyWith(
    fontSize: 14, fontWeight: FontWeight.w500, height: 1.4,
    color: ClinicColors.ink2,
  );

  static final button = _bodyStyle.copyWith(
    fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.2,
    color: Colors.white,
  );

  static final small = _bodyStyle.copyWith(
    fontSize: 12, fontWeight: FontWeight.w500, height: 1.3,
    color: ClinicColors.ink2,
  );
}

// =================== SPACING ===================

class ClinicSpacing {
  ClinicSpacing._();

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

class ClinicRadius {
  ClinicRadius._();

  static const double small = 8;
  static const double medium = 14;    // Professional, not too bubbly
  static const double large = 18;
  static const double modal = 24;

  static BorderRadius get smallRadius => BorderRadius.circular(small);
  static BorderRadius get mediumRadius => BorderRadius.circular(medium);
  static BorderRadius get largeRadius => BorderRadius.circular(large);
  static BorderRadius get modalRadius => BorderRadius.circular(modal);
}

// =================== SHADOWS ===================

class ClinicShadows {
  ClinicShadows._();

  // Soft, clean shadows for white-on-white depth
  static List<BoxShadow> get card => [
    BoxShadow(color: Color(0xFF0F1A1C).withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4)),
    BoxShadow(color: Color(0xFF0F1A1C).withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2)),
  ];

  static List<BoxShadow> get cardHover => [
    BoxShadow(color: Color(0xFF0F1A1C).withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 8)),
  ];

  static List<BoxShadow> get floating => [
    BoxShadow(color: Color(0xFF138A8A).withValues(alpha: 0.2), blurRadius: 24, offset: const Offset(0, 8)),
  ];
}

// =================== GLASS REPLACEMENT (MINIMAL) ===================

class ClinicGlass {
  ClinicGlass._();

  static const double cardBlurSigma = 0; // No blur for clinic
  static const double modalBlurSigma = 4;
  static const double fillOpacity = 1.0; // Solid
  static const double borderOpacity = 1.0;
  static const double borderWidth = 1.0;
}

// =================== MOTION ===================

class ClinicMotion {
  ClinicMotion._();

  static const Duration fast = Duration(milliseconds: 200);
  static const Duration standard = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  static const Curve standardEasing = Curves.easeInOut;
  static const Curve emphasizedEasing = Curves.easeOutCubic;

  static const double buttonPressScale = 0.98;
}

// =================== THEME DATA ===================

final clinicTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  colorScheme: ColorScheme.light(
    primary: ClinicColors.primary,
    secondary: ClinicColors.accent,
    tertiary: ClinicColors.muted,
    error: ClinicColors.danger,
    surface: ClinicColors.bg1,
    onSurface: ClinicColors.ink1,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    outline: ClinicColors.line,
  ),

  scaffoldBackgroundColor: ClinicColors.bg0,

  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: ClinicColors.bg0,
    foregroundColor: ClinicColors.ink0,
    titleTextStyle: ClinicText.h3,
    iconTheme: IconThemeData(color: ClinicColors.ink0),
  ),

  textTheme: TextTheme(
    displayLarge: ClinicText.h1,
    displayMedium: ClinicText.h2,
    displaySmall: ClinicText.h3,
    bodyLarge: ClinicText.body,
    bodyMedium: ClinicText.bodyMedium,
    bodySmall: ClinicText.caption,
    labelLarge: ClinicText.button,
  ),

  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: ClinicRadius.mediumRadius,
      side: BorderSide(color: ClinicColors.line, width: 1),
    ),
    color: ClinicColors.bg1,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: ClinicColors.primary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: ClinicSpacing.xl, vertical: ClinicSpacing.base),
      shape: RoundedRectangleBorder(borderRadius: ClinicRadius.mediumRadius),
      textStyle: ClinicText.button,
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: ClinicColors.primary,
      side: BorderSide(color: ClinicColors.primary.withValues(alpha: 0.5)),
      padding: const EdgeInsets.symmetric(horizontal: ClinicSpacing.xl, vertical: ClinicSpacing.base),
      shape: RoundedRectangleBorder(borderRadius: ClinicRadius.mediumRadius),
      textStyle: ClinicText.button.copyWith(color: ClinicColors.primary),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: ClinicRadius.mediumRadius,
      borderSide: BorderSide(color: ClinicColors.line),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: ClinicRadius.mediumRadius,
      borderSide: BorderSide(color: ClinicColors.line),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: ClinicRadius.mediumRadius,
      borderSide: BorderSide(color: ClinicColors.primary, width: 2),
    ),
    hintStyle: ClinicText.caption,
  ),
);
