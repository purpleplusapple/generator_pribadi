// lib/theme/beauty_salon_ai_theme.dart
// Complete Design System for Beauty Salon AI
// Elegant beauty salon aesthetic: soft pinks, gold, cream, marble

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// =================== COLOR PALETTE ===================

/// Elegant Beauty Salon color palette
class BeautyAIColors {
  BeautyAIColors._();

  // Base Colors (soft, elegant)
  static const creamWhite = Color(0xFFFDFBF7);
  static const softRose = Color(0xFFF3E5F5); // Very light purple/pink
  static const charcoal = Color(0xFF333333);

  // Accent Colors (luxury & beauty)
  static const roseGold = Color(0xFFB76E79);
  static const metallicGold = Color(0xFFD4AF37);
  static const sageGreen = Color(0xFF8FA79A); // Calming accent

  // State Colors
  static const success = Color(0xFF81C784);
  static const warning = metallicGold;
  static const error = Color(0xFFE57373);

  // Opacity variants
  static Color roseGoldWithOpacity(double opacity) => roseGold.withValues(alpha: opacity);
  static Color goldWithOpacity(double opacity) => metallicGold.withValues(alpha: opacity);
  static Color creamWithOpacity(double opacity) => creamWhite.withValues(alpha: opacity);

  // Mappings
  static const mainBackground = creamWhite;
  static const textMain = charcoal;
  static const textMuted = Color(0xFF757575);
}

// =================== GRADIENTS ===================

class BeautyAIGradients {
  BeautyAIGradients._();

  static const background = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [BeautyAIColors.creamWhite, Color(0xFFF8F0F2)], // Subtle gradient
  );

  static const primaryCta = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [BeautyAIColors.roseGold, BeautyAIColors.metallicGold],
  );

  static const accentHighlight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [BeautyAIColors.metallicGold, BeautyAIColors.creamWhite],
  );

  static const readabilityScrim = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x40FFFFFF), Color(0x00FFFFFF)],
  );
}

// =================== TYPOGRAPHY ===================

class BeautyAIText {
  BeautyAIText._();

  // Using Lato or Playfair Display could be nice, but stick to GoogleFonts
  static final TextStyle _baseStyle = GoogleFonts.lato(
    color: BeautyAIColors.charcoal,
  );

  static final TextStyle _headingStyle = GoogleFonts.playfairDisplay(
    color: BeautyAIColors.charcoal,
  );

  static final h1 = _headingStyle.copyWith(
    fontSize: 32, fontWeight: FontWeight.w700, height: 1.2, letterSpacing: -0.5,
  );

  static final h2 = _headingStyle.copyWith(
    fontSize: 24, fontWeight: FontWeight.w600, height: 1.3, letterSpacing: -0.3,
  );

  static final h3 = _headingStyle.copyWith(
    fontSize: 20, fontWeight: FontWeight.w600, height: 1.4, letterSpacing: -0.2,
  );

  static final body = _baseStyle.copyWith(
    fontSize: 16, fontWeight: FontWeight.w400, height: 1.5,
  );

  static final bodyMedium = _baseStyle.copyWith(
    fontSize: 16, fontWeight: FontWeight.w500, height: 1.5,
  );

  static final bodySemiBold = _baseStyle.copyWith(
    fontSize: 16, fontWeight: FontWeight.w600, height: 1.5,
  );

  static final caption = _baseStyle.copyWith(
    fontSize: 14, fontWeight: FontWeight.w400, height: 1.4,
    color: BeautyAIColors.charcoal.withValues(alpha: 0.7),
  );

  static final captionMedium = _baseStyle.copyWith(
    fontSize: 14, fontWeight: FontWeight.w500, height: 1.4,
  );

  static final button = _baseStyle.copyWith(
    fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5,
  );

  static final small = _baseStyle.copyWith(
    fontSize: 12, fontWeight: FontWeight.w400, height: 1.3,
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
  static const double xxxl = 40;
  static const double huge = 48;
  static const double massive = 64;
}

// =================== RADIUS ===================

class BeautyAIRadii {
  BeautyAIRadii._();

  static const double chip = 16;      // More rounded
  static const double button = 24;    // Softer pills
  static const double card = 24;      // Soft cards
  static const double cardLarge = 32;
  static const double modal = 32;

  static BorderRadius get chipRadius => BorderRadius.circular(chip);
  static BorderRadius get buttonRadius => BorderRadius.circular(button);
  static BorderRadius get cardRadius => BorderRadius.circular(card);
  static BorderRadius get cardLargeRadius => BorderRadius.circular(cardLarge);
  static BorderRadius get modalRadius => BorderRadius.circular(modal);
}

// =================== SHADOWS ===================

class BeautyAIShadows {
  BeautyAIShadows._();

  // Soft, diffuse shadows for a clean look
  static List<BoxShadow> get card => [
    BoxShadow(color: BeautyAIColors.roseGold.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 8)),
    BoxShadow(color: BeautyAIColors.charcoal.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
  ];

  static List<BoxShadow> get cardElevated => [
    BoxShadow(color: BeautyAIColors.roseGold.withValues(alpha: 0.15), blurRadius: 30, offset: const Offset(0, 15)),
    BoxShadow(color: BeautyAIColors.charcoal.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 6)),
  ];

  static List<BoxShadow> get modal => [
    BoxShadow(color: BeautyAIColors.charcoal.withValues(alpha: 0.15), blurRadius: 40, offset: const Offset(0, 20)),
  ];

  static List<BoxShadow> goldGlow({double opacity = 0.45}) => [
    BoxShadow(color: BeautyAIColors.metallicGold.withValues(alpha: opacity), blurRadius: 25, spreadRadius: 2),
  ];

  static List<BoxShadow> roseGlow({double opacity = 0.4}) => [
    BoxShadow(color: BeautyAIColors.roseGold.withValues(alpha: opacity), blurRadius: 25, spreadRadius: 2),
  ];
}

// =================== GLASS FORMULA ===================

class BeautyAIGlass {
  BeautyAIGlass._();

  static const double cardBlurSigma = 20;
  static const double modalBlurSigma = 30;
  static const double fillOpacity = 0.6; // Higher opacity for lighter theme
  static const double borderOpacity = 0.3;
  static const double bubbleHighlightOpacity = 0.2;
  static const double borderWidth = 1.0;
}

// =================== MOTION ===================

class BeautyAIMotion {
  BeautyAIMotion._();

  static const Duration fast = Duration(milliseconds: 250);
  static const Duration standard = Duration(milliseconds: 450);
  static const Duration slow = Duration(milliseconds: 700);
  static const Duration resultReveal = Duration(milliseconds: 1200);

  static const Curve standardEasing = Cubic(0.4, 0.0, 0.2, 1.0);
  static const Curve emphasizedEasing = Cubic(0.4, 0.0, 0.6, 1.0);
  static const Curve easeOut = Curves.easeOut;

  static const double buttonPressScale = 0.98;
  static const double cardLiftOffset = -4;
}

// =================== THEME DATA ===================

final beautySalonAITheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light, // Switched to light mode for beauty salon

  colorScheme: ColorScheme.light(
    primary: BeautyAIColors.roseGold,
    secondary: BeautyAIColors.metallicGold,
    tertiary: BeautyAIColors.sageGreen,
    error: BeautyAIColors.error,
    surface: BeautyAIColors.creamWhite,
    onSurface: BeautyAIColors.charcoal,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
  ),

  scaffoldBackgroundColor: BeautyAIColors.creamWhite,

  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: BeautyAIColors.charcoal,
    titleTextStyle: BeautyAIText.h3,
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

  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BeautyAIRadii.cardRadius),
    color: Colors.white.withValues(alpha: 0.8), // Clean white cards
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: BeautyAISpacing.xl, vertical: BeautyAISpacing.base),
      shape: RoundedRectangleBorder(borderRadius: BeautyAIRadii.buttonRadius),
      textStyle: BeautyAIText.button,
      backgroundColor: BeautyAIColors.roseGold,
      foregroundColor: Colors.white,
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: BeautyAISpacing.base, vertical: BeautyAISpacing.sm),
      textStyle: BeautyAIText.button,
      foregroundColor: BeautyAIColors.roseGold,
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BeautyAIRadii.buttonRadius,
      borderSide: BorderSide(color: BeautyAIColors.roseGold.withValues(alpha: 0.3)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BeautyAIRadii.buttonRadius,
      borderSide: BorderSide(color: BeautyAIColors.roseGold.withValues(alpha: 0.3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BeautyAIRadii.buttonRadius,
      borderSide: const BorderSide(color: BeautyAIColors.roseGold, width: 2),
    ),
    hintStyle: TextStyle(color: BeautyAIColors.charcoal.withValues(alpha: 0.4)),
  ),

  dividerTheme: DividerThemeData(
    color: BeautyAIColors.charcoal.withValues(alpha: 0.1),
    thickness: 1,
  ),
);
