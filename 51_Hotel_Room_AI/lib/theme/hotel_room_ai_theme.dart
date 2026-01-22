// lib/theme/hotel_room_ai_theme.dart
// Complete Design System for Hotel Room AI
// Option A: Warm Light "Boutique Linen"

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// =================== COLOR PALETTE ===================

class HotelAIColors {
  HotelAIColors._();

  // Option A - Warm Light "Boutique Linen"
  static const bg0 = Color(0xFFFBF7F2); // Linen
  static const bg1 = Color(0xFFFFFFFF); // Surface
  static const surface = Color(0xFFFFFFFF);

  static const ink0 = Color(0xFF1C1612); // Darkest
  static const ink1 = Color(0xFF3B2F28); // Dark Brown
  static const muted = Color(0xFF6B5B52); // Muted Brown

  static const primary = Color(0xFFA06A43); // Warm Tan / Leather
  static const primarySoft = Color(0xFFF1E3D8); // Light Tan

  static const accent = Color(0xFF2E6F6A); // Teal Calm
  static const line = Color(0xFFE7DDD4); // Divider

  // Functional
  static const error = Color(0xFFB3261E);
  static const success = Color(0xFF2E6F6A);
}

// =================== TYPOGRAPHY ===================

class HotelAIText {
  HotelAIText._();

  // Heading: DM Serif Display
  static final TextStyle _headingStyle = GoogleFonts.dmSerifDisplay(
    color: HotelAIColors.ink0,
  );

  // Body: Inter
  static final TextStyle _bodyStyle = GoogleFonts.inter(
    color: HotelAIColors.ink1,
  );

  static final h1 = _headingStyle.copyWith(
    fontSize: 32, fontWeight: FontWeight.w400, height: 1.2,
  );

  static final h2 = _headingStyle.copyWith(
    fontSize: 24, fontWeight: FontWeight.w400, height: 1.3,
  );

  static final h3 = _headingStyle.copyWith(
    fontSize: 20, fontWeight: FontWeight.w400, height: 1.4,
  );

  static final body = _bodyStyle.copyWith(
    fontSize: 16, fontWeight: FontWeight.w400, height: 1.5,
  );

  static final bodyMedium = _bodyStyle.copyWith(
    fontSize: 16, fontWeight: FontWeight.w500, height: 1.5,
  );

  static final small = _bodyStyle.copyWith(
    fontSize: 14, fontWeight: FontWeight.w400, height: 1.4,
  );

  static final caption = _bodyStyle.copyWith(
    fontSize: 12, fontWeight: FontWeight.w400, height: 1.4,
    color: HotelAIColors.muted,
  );

  static final button = _bodyStyle.copyWith(
    fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.5,
  );
}

// =================== SPACING ===================

class HotelAISpacing {
  HotelAISpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

// =================== RADIUS ===================

class HotelAIRadii {
  HotelAIRadii._();

  static const double small = 8;
  static const double medium = 14; // Hotel style
  static const double large = 20;

  static BorderRadius get mediumRadius => BorderRadius.circular(medium);
  static BorderRadius get largeRadius => BorderRadius.circular(large);
  static BorderRadius get chipRadius => BorderRadius.circular(small);
}

// =================== SHADOWS ===================

class HotelAIShadows {
  HotelAIShadows._();

  static List<BoxShadow> get soft => [
    BoxShadow(
      color: HotelAIColors.ink0.withValues(alpha: 0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get floating => [
    BoxShadow(
      color: HotelAIColors.ink0.withValues(alpha: 0.1),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get cardElevated => [
    BoxShadow(
      color: HotelAIColors.ink0.withValues(alpha: 0.15),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];

  static List<BoxShadow> get modal => [
    BoxShadow(
      color: HotelAIColors.ink0.withValues(alpha: 0.2),
      blurRadius: 40,
      offset: const Offset(0, 20),
    ),
  ];
}

// =================== MOTION ===================

class HotelAIMotion {
  HotelAIMotion._();
  static const Duration standard = Duration(milliseconds: 300);
  static const Curve emphasizedEasing = Curves.easeInOutCubic;
}

// =================== THEME DATA ===================

final hotelRoomAITheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  colorScheme: ColorScheme.light(
    primary: HotelAIColors.primary,
    secondary: HotelAIColors.accent,
    surface: HotelAIColors.bg0, // Linen Background
    onSurface: HotelAIColors.ink0,
    background: HotelAIColors.bg0,
    onBackground: HotelAIColors.ink0,
    error: HotelAIColors.error,
  ),

  scaffoldBackgroundColor: HotelAIColors.bg0,

  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: HotelAIColors.bg0,
    foregroundColor: HotelAIColors.ink0,
    titleTextStyle: HotelAIText.h3,
    iconTheme: const IconThemeData(color: HotelAIColors.ink0),
  ),

  textTheme: TextTheme(
    displayLarge: HotelAIText.h1,
    displayMedium: HotelAIText.h2,
    displaySmall: HotelAIText.h3,
    bodyLarge: HotelAIText.body,
    bodyMedium: HotelAIText.bodyMedium,
    bodySmall: HotelAIText.caption,
    labelLarge: HotelAIText.button,
  ),

  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: HotelAIRadii.mediumRadius),
    color: HotelAIColors.bg1, // White surface on Linen
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: HotelAIColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(
        horizontal: HotelAISpacing.lg,
        vertical: HotelAISpacing.base
      ),
      shape: RoundedRectangleBorder(borderRadius: HotelAIRadii.mediumRadius),
      textStyle: HotelAIText.button,
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: HotelAIColors.primary,
      textStyle: HotelAIText.button,
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: HotelAIColors.ink0,
      side: const BorderSide(color: HotelAIColors.line),
      padding: const EdgeInsets.symmetric(
        horizontal: HotelAISpacing.base,
        vertical: HotelAISpacing.base
      ),
      shape: RoundedRectangleBorder(borderRadius: HotelAIRadii.mediumRadius),
      textStyle: HotelAIText.button,
    ),
  ),

  dividerTheme: const DividerThemeData(
    color: HotelAIColors.line,
    thickness: 1,
  ),
);
