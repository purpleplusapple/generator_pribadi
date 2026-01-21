// lib/theme/shoe_room_ai_theme.dart
// Complete Design System for Shoe Room AI
// Premium shoe materials aesthetic: leather, canvas, metal accents

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// =================== COLOR PALETTE ===================

/// Premium Shoe Materials color palette
class ShoeAIColors {
  ShoeAIColors._();

  // Base Colors (premium shoe materials)
  static const richBrown = Color(0xFF3E2723);
  static const canvasWhite = Color(0xFFFAFAFA);
  static const soleBlack = Color(0xFF212121);

  // Accent Colors (shoe details & luxury)
  static const leatherTan = Color(0xFFBF8040);
  static const metallicGold = Color(0xFFD4AF37);
  static const laceGray = Color(0xFF9E9E9E);

  // State Colors
  static const success = Color(0xFF66BB6A);
  static const warning = metallicGold;
  static const error = Color(0xFFEF5350);

  // Opacity variants
  static Color tanWithOpacity(double opacity) => leatherTan.withValues(alpha: opacity);
  static Color goldWithOpacity(double opacity) => metallicGold.withValues(alpha: opacity);
  static Color whiteWithOpacity(double opacity) => canvasWhite.withValues(alpha: opacity);
  
  // Legacy compatibility
  static const pitBlack = soleBlack;
  static const textMain = canvasWhite;
  static const textMuted = Color(0xFFB0B0B0);
}

// =================== GRADIENTS ===================

class ShoeAIGradients {
  ShoeAIGradients._();

  static const background = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF212121), Color(0xFF3E2723)],
  );

  static const primaryCta = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [ShoeAIColors.leatherTan, ShoeAIColors.metallicGold],
  );

  static const accentHighlight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ShoeAIColors.metallicGold, ShoeAIColors.canvasWhite],
  );

  static const readabilityScrim = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x40000000), Color(0x00000000)],
  );
}

// =================== TYPOGRAPHY ===================

class ShoeAIText {
  ShoeAIText._();

  static final TextStyle _baseStyle = GoogleFonts.inter(
    color: ShoeAIColors.canvasWhite,
  );

  static final h1 = _baseStyle.copyWith(
    fontSize: 32, fontWeight: FontWeight.w700, height: 1.2, letterSpacing: -0.5,
  );

  static final h2 = _baseStyle.copyWith(
    fontSize: 24, fontWeight: FontWeight.w600, height: 1.3, letterSpacing: -0.3,
  );

  static final h3 = _baseStyle.copyWith(
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
    color: ShoeAIColors.canvasWhite.withValues(alpha: 0.7),
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

class ShoeAISpacing {
  ShoeAISpacing._();

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

class ShoeAIRadii {
  ShoeAIRadii._();

  static const double chip = 12;      // Rounder chips
  static const double button = 20;    // Pill-shaped buttons
  static const double card = 20;      // Softer cards
  static const double cardLarge = 24; // More pronounced
  static const double modal = 26;     // Luxury modals

  static BorderRadius get chipRadius => BorderRadius.circular(chip);
  static BorderRadius get buttonRadius => BorderRadius.circular(button);
  static BorderRadius get cardRadius => BorderRadius.circular(card);
  static BorderRadius get cardLargeRadius => BorderRadius.circular(cardLarge);
  static BorderRadius get modalRadius => BorderRadius.circular(modal);
}

// =================== SHADOWS ===================

class ShoeAIShadows {
  ShoeAIShadows._();

  // Deeper, more luxurious shadows
  static List<BoxShadow> get card => [
    BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 28, offset: const Offset(0, 12)),
    BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 6)),
  ];

  static List<BoxShadow> get cardElevated => [
    BoxShadow(color: Colors.black.withValues(alpha: 0.22), blurRadius: 38, offset: const Offset(0, 18)),
    BoxShadow(color: Colors.black.withValues(alpha: 0.10), blurRadius: 16, offset: const Offset(0, 8)),
  ];

  static List<BoxShadow> get modal => [
    BoxShadow(color: Colors.black.withValues(alpha: 0.28), blurRadius: 48, offset: const Offset(0, 24)),
    BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 20, offset: const Offset(0, 10)),
  ];

  static List<BoxShadow> goldGlow({double opacity = 0.45}) => [
    BoxShadow(color: ShoeAIColors.metallicGold.withValues(alpha: opacity), blurRadius: 32, spreadRadius: 2),
  ];

  static List<BoxShadow> tanGlow({double opacity = 0.4}) => [
    BoxShadow(color: ShoeAIColors.leatherTan.withValues(alpha: opacity), blurRadius: 30, spreadRadius: 2),
  ];
}

// =================== GLASS FORMULA ===================

class ShoeAIGlass {
  ShoeAIGlass._();

  static const double cardBlurSigma = 18;
  static const double modalBlurSigma = 24;
  static const double fillOpacity = 0.09;
  static const double borderOpacity = 0.16;
  static const double bubbleHighlightOpacity = 0.04;
  static const double borderWidth = 1.8;
}

// =================== MOTION ===================

class ShoeAIMotion {
  ShoeAIMotion._();

  // Slower, more luxurious animations
  static const Duration fast = Duration(milliseconds: 220);     // Slightly slower
  static const Duration standard = Duration(milliseconds: 400); // More pronounced
  static const Duration slow = Duration(milliseconds: 600);     // Elegant
  static const Duration resultReveal = Duration(milliseconds: 1000); // Dramatic

  static const Curve standardEasing = Cubic(0.4, 0.0, 0.2, 1.0);
  static const Curve emphasizedEasing = Cubic(0.4, 0.0, 0.6, 1.0);
  static const Curve easeOut = Curves.easeOut;

  static const double buttonPressScale = 0.97;
  static const double cardLiftOffset = -3;
}

// =================== THEME DATA ===================

final shoeRoomAITheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  
  colorScheme: ColorScheme.dark(
    primary: ShoeAIColors.leatherTan,
    secondary: ShoeAIColors.metallicGold,
    tertiary: ShoeAIColors.laceGray,
    error: ShoeAIColors.error,
    surface: ShoeAIColors.richBrown,
    onSurface: ShoeAIColors.canvasWhite,
    onPrimary: ShoeAIColors.soleBlack,
    onSecondary: ShoeAIColors.soleBlack,
  ),

  scaffoldBackgroundColor: ShoeAIColors.soleBlack,

  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: ShoeAIColors.canvasWhite,
    titleTextStyle: ShoeAIText.h3,
  ),

  textTheme: TextTheme(
    displayLarge: ShoeAIText.h1,
    displayMedium: ShoeAIText.h2,
    displaySmall: ShoeAIText.h3,
    bodyLarge: ShoeAIText.body,
    bodyMedium: ShoeAIText.bodyMedium,
    bodySmall: ShoeAIText.caption,
    labelLarge: ShoeAIText.button,
  ),

  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: ShoeAIRadii.cardRadius),
    color: ShoeAIColors.canvasWhite.withValues(alpha: ShoeAIGlass.fillOpacity),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: ShoeAISpacing.xl, vertical: ShoeAISpacing.base),
      shape: RoundedRectangleBorder(borderRadius: ShoeAIRadii.buttonRadius),
      textStyle: ShoeAIText.button,
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: ShoeAISpacing.base, vertical: ShoeAISpacing.sm),
      textStyle: ShoeAIText.button,
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: ShoeAIColors.canvasWhite.withValues(alpha: 0.06),
    border: OutlineInputBorder(
      borderRadius: ShoeAIRadii.buttonRadius,
      borderSide: BorderSide(color: ShoeAIColors.canvasWhite.withValues(alpha: 0.2)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: ShoeAIRadii.buttonRadius,
      borderSide: BorderSide(color: ShoeAIColors.canvasWhite.withValues(alpha: 0.2)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: ShoeAIRadii.buttonRadius,
      borderSide: const BorderSide(color: ShoeAIColors.leatherTan, width: 2),
    ),
  ),

  dividerTheme: DividerThemeData(
    color: ShoeAIColors.canvasWhite.withValues(alpha: 0.1),
    thickness: 1,
  ),
);
