// lib/theme/boutique_theme.dart
// Complete Design System for Retail Store Boutique AI
// Dark Luxury Boutique aesthetic: Midnight Boutique, black marble, smoked glass, brass, velvet

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// =================== COLOR PALETTE (Midnight Boutique) ===================

class BoutiqueColors {
  BoutiqueColors._();

  // Backgrounds
  static const bg0 = Color(0xFF0A0B10); // deep black-blue
  static const bg1 = Color(0xFF0F111A);
  static const surface = Color(0xFF151827);
  static const surface2 = Color(0xFF1B2033);

  // Ink / Text
  static const ink0 = Color(0xFFF5F2ED); // titles (off-white)
  static const ink1 = Color(0xFFD9D4CD); // body (not too dark!)
  static const muted = Color(0xFFA8A19A); // secondary

  // Luxury Accents
  static const primary = Color(0xFFC9A45B); // brass gold
  static const primarySoft = Color(0xFF2A2417); // gold-tinted surface
  static const accent = Color(0xFFE35DA7); // magenta rose highlight (small only)
  static const accent2 = Color(0xFF47D7C8); // aqua highlight (small only)

  // Lines
  static const line = Color(0xFF2A2F44);

  // States
  static const success = Color(0xFF2DBA8A);
  static const danger = Color(0xFFD14B4B);

  // Opacity variants
  static Color primaryWithOpacity(double opacity) => primary.withValues(alpha: opacity);
  static Color bgWithOpacity(double opacity) => bg0.withValues(alpha: opacity);
  static Color inkWithOpacity(double opacity) => ink0.withValues(alpha: opacity);
}

// =================== GRADIENTS ===================

class BoutiqueGradients {
  BoutiqueGradients._();

  static const background = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [BoutiqueColors.bg0, BoutiqueColors.bg1],
  );

  static const glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x1AFFFFFF), // white 10%
      Color(0x05FFFFFF), // white 2%
    ],
  );

  static const goldSheen = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [BoutiqueColors.primary, Color(0xFFE5C580)],
  );

  static const readabilityScrim = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x80000000), Color(0x00000000)],
  );
}

// =================== TYPOGRAPHY (Set A: Editorial Luxury) ===================

class BoutiqueText {
  BoutiqueText._();

  // Headings: Playfair Display
  static final TextStyle _headingStyle = GoogleFonts.playfairDisplay(
    color: BoutiqueColors.ink0,
  );

  // Body: Inter
  static final TextStyle _bodyStyle = GoogleFonts.inter(
    color: BoutiqueColors.ink1,
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
    color: BoutiqueColors.muted,
  );

  static final captionMedium = _bodyStyle.copyWith(
    fontSize: 14, fontWeight: FontWeight.w500, height: 1.4,
    color: BoutiqueColors.muted,
  );

  static final button = _bodyStyle.copyWith(
    fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5,
    color: BoutiqueColors.bg0, // High contrast on gold button
  );

  static final small = _bodyStyle.copyWith(
    fontSize: 12, fontWeight: FontWeight.w400, height: 1.3,
  );
}

// =================== SPACING ===================

class BoutiqueSpacing {
  BoutiqueSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;
}

// =================== RADIUS ===================

class BoutiqueRadii {
  BoutiqueRadii._();

  static const double chip = 12;
  static const double button = 18;    // Soft premium
  static const double card = 22;      // Soft premium
  static const double modal = 28;     // Luxury modals

  static BorderRadius get chipRadius => BorderRadius.circular(chip);
  static BorderRadius get buttonRadius => BorderRadius.circular(button);
  static BorderRadius get cardRadius => BorderRadius.circular(card);
  static BorderRadius get modalRadius => BorderRadius.circular(modal);
}

// =================== SHADOWS ===================

class BoutiqueShadows {
  BoutiqueShadows._();

  // Soft, minimal, glow
  static List<BoxShadow> get card => [
    BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8)),
  ];

  static List<BoxShadow> get cardElevated => [
    BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 30, offset: const Offset(0, 12)),
  ];

  static List<BoxShadow> goldGlow({double opacity = 0.3}) => [
    BoxShadow(color: BoutiqueColors.primary.withValues(alpha: opacity), blurRadius: 24, spreadRadius: 1),
  ];
}

// =================== GLASS FORMULA ===================

class BoutiqueGlass {
  BoutiqueGlass._();

  static const double blurSigma = 15;
  static const double borderOpacity = 0.15;
}

// =================== THEME DATA ===================

final boutiqueTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  colorScheme: ColorScheme.dark(
    primary: BoutiqueColors.primary,
    secondary: BoutiqueColors.accent,
    tertiary: BoutiqueColors.muted,
    error: BoutiqueColors.danger,
    surface: BoutiqueColors.surface,
    onSurface: BoutiqueColors.ink0,
    onPrimary: BoutiqueColors.bg0, // Black text on Gold
    onSecondary: BoutiqueColors.bg0,
  ),

  scaffoldBackgroundColor: BoutiqueColors.bg0,

  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: BoutiqueColors.ink0,
    titleTextStyle: BoutiqueText.h3,
  ),

  textTheme: TextTheme(
    displayLarge: BoutiqueText.h1,
    displayMedium: BoutiqueText.h2,
    displaySmall: BoutiqueText.h3,
    bodyLarge: BoutiqueText.body,
    bodyMedium: BoutiqueText.bodyMedium,
    bodySmall: BoutiqueText.caption,
    labelLarge: BoutiqueText.button,
  ),

  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BoutiqueRadii.cardRadius),
    color: BoutiqueColors.surface.withValues(alpha: 0.6), // slight translucency
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: BoutiqueColors.primary,
      foregroundColor: BoutiqueColors.bg0,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: BoutiqueSpacing.xl, vertical: BoutiqueSpacing.base),
      shape: RoundedRectangleBorder(borderRadius: BoutiqueRadii.buttonRadius),
      textStyle: BoutiqueText.button,
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: BoutiqueColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: BoutiqueSpacing.base, vertical: BoutiqueSpacing.sm),
      textStyle: BoutiqueText.button.copyWith(color: BoutiqueColors.primary),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: BoutiqueColors.surface2,
    border: OutlineInputBorder(
      borderRadius: BoutiqueRadii.buttonRadius,
      borderSide: BorderSide(color: BoutiqueColors.line),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BoutiqueRadii.buttonRadius,
      borderSide: BorderSide(color: BoutiqueColors.line),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BoutiqueRadii.buttonRadius,
      borderSide: const BorderSide(color: BoutiqueColors.primary, width: 2),
    ),
    hintStyle: BoutiqueText.caption,
  ),

  dividerTheme: const DividerThemeData(
    color: BoutiqueColors.line,
    thickness: 1,
  ),
);
