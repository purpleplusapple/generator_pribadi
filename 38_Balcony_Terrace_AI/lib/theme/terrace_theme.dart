import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// =================== COLOR PALETTE (Night Garden) ===================

class TerraceAIColors {
  TerraceAIColors._();

  // Backgrounds
  static const bg0 = Color(0xFF070B0A);
  static const bg1 = Color(0xFF0B1110);

  // Surfaces
  static const surface = Color(0xFF101A18);
  static const surface2 = Color(0xFF142220);
  static const glassFill = Color(0x0DFFFFFF); // Very subtle fill for glass

  // Text / Ink
  static const ink0 = Color(0xFFF2F3EE); // Titles
  static const ink1 = Color(0xFFD2D7CF); // Body
  static const muted = Color(0xFFA3ACA2); // Secondary
  static const line = Color(0xFF263332);  // Dividers/Borders

  // Brand Colors
  static const primary = Color(0xFF2FA37B); // Emerald
  static const primarySoft = Color(0xFF182A23);

  static const accent = Color(0xFFE7A35A); // Lantern Amber
  static const accentSoft = Color(0xFF2A2218);

  static const accent2 = Color(0xFF6F7CFF); // Violet (Highlights only)

  // Functional
  static const success = Color(0xFF2DBA8A);
  static const danger = Color(0xFFD14B4B);
  static const warning = accent; // Re-use amber for warning

  // Opacity helpers
  static Color primaryWithOpacity(double opacity) => primary.withValues(alpha: opacity);
  static Color accentWithOpacity(double opacity) => accent.withValues(alpha: opacity);
  static Color ink0WithOpacity(double opacity) => ink0.withValues(alpha: opacity);
}

// =================== GRADIENTS ===================

class TerraceAIGradients {
  TerraceAIGradients._();

  static const background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [TerraceAIColors.bg0, TerraceAIColors.bg1],
  );

  static const primaryCta = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [TerraceAIColors.primary, Color(0xFF3BC799)],
  );

  static const amberGlow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [TerraceAIColors.accent, Color(0xFFFFC078)],
  );

  static const glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x1AFFFFFF), // 10%
      Color(0x05FFFFFF), // 2%
    ],
  );

  static const bottomSheetMask = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, TerraceAIColors.bg0],
    stops: [0.0, 0.3],
  );
}

// =================== TYPOGRAPHY ===================

class TerraceAIText {
  TerraceAIText._();

  // Headings: Fraunces (Premium Cozy)
  static final TextStyle _headingStyle = GoogleFonts.fraunces(
    color: TerraceAIColors.ink0,
  );

  // Body: Inter (Clean Modern)
  static final TextStyle _bodyStyle = GoogleFonts.inter(
    color: TerraceAIColors.ink1,
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
    fontSize: 16, fontWeight: FontWeight.w500, height: 1.5, color: TerraceAIColors.ink0,
  );

  static final bodySemiBold = _bodyStyle.copyWith(
    fontSize: 16, fontWeight: FontWeight.w600, height: 1.5, color: TerraceAIColors.ink0,
  );

  static final caption = _bodyStyle.copyWith(
    fontSize: 14, fontWeight: FontWeight.w400, height: 1.4,
    color: TerraceAIColors.muted,
  );

  static final button = _bodyStyle.copyWith(
    fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5,
    color: TerraceAIColors.bg0, // Text on primary button usually dark
  );

  static final small = _bodyStyle.copyWith(
    fontSize: 12, fontWeight: FontWeight.w400, height: 1.3,
    color: TerraceAIColors.muted,
  );
}

// =================== SPACING & RADII ===================

class TerraceAISpacing {
  TerraceAISpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double huge = 48;
}

class TerraceAIRadii {
  TerraceAIRadii._();
  static const double sm = 12;
  static const double md = 18;
  static const double lg = 24;
  static const double xl = 30;

  static BorderRadius get smRadius => BorderRadius.circular(sm);
  static BorderRadius get mdRadius => BorderRadius.circular(md);
  static BorderRadius get lgRadius => BorderRadius.circular(lg);
  static BorderRadius get xlRadius => BorderRadius.circular(xl);
}

// =================== SHADOWS ===================

class TerraceAIShadows {
  TerraceAIShadows._();

  static List<BoxShadow> get card => [
    BoxShadow(color: Colors.black.withValues(alpha: 0.20), blurRadius: 20, offset: const Offset(0, 8)),
  ];

  static List<BoxShadow> get modal => [
    BoxShadow(color: Colors.black.withValues(alpha: 0.40), blurRadius: 40, offset: const Offset(0, -10)),
  ];

  static List<BoxShadow> amberGlow({double opacity = 0.3}) => [
    BoxShadow(color: TerraceAIColors.accent.withValues(alpha: opacity), blurRadius: 24, spreadRadius: 2),
  ];

  static List<BoxShadow> emeraldGlow({double opacity = 0.2}) => [
    BoxShadow(color: TerraceAIColors.primary.withValues(alpha: opacity), blurRadius: 24, spreadRadius: 1),
  ];
}

// =================== THEME DATA ===================

final terraceTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  colorScheme: ColorScheme.dark(
    primary: TerraceAIColors.primary,
    secondary: TerraceAIColors.accent,
    tertiary: TerraceAIColors.accent2,
    error: TerraceAIColors.danger,
    surface: TerraceAIColors.surface,
    onSurface: TerraceAIColors.ink0,
    onPrimary: TerraceAIColors.bg0,
    onSecondary: TerraceAIColors.bg0,
    background: TerraceAIColors.bg0,
  ),

  scaffoldBackgroundColor: TerraceAIColors.bg0,

  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: TerraceAIColors.ink0,
    titleTextStyle: TerraceAIText.h3,
  ),

  textTheme: TextTheme(
    displayLarge: TerraceAIText.h1,
    displayMedium: TerraceAIText.h2,
    displaySmall: TerraceAIText.h3,
    bodyLarge: TerraceAIText.body,
    bodyMedium: TerraceAIText.bodyMedium,
    bodySmall: TerraceAIText.caption,
    labelLarge: TerraceAIText.button,
  ),

  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: TerraceAIRadii.mdRadius),
    color: TerraceAIColors.surface.withValues(alpha: 0.5),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: TerraceAIColors.primary,
      foregroundColor: TerraceAIColors.bg0,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: TerraceAISpacing.xl, vertical: TerraceAISpacing.base),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // Pill shape
      textStyle: TerraceAIText.button,
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: TerraceAIColors.ink1,
      side: const BorderSide(color: TerraceAIColors.line),
      padding: const EdgeInsets.symmetric(horizontal: TerraceAISpacing.base, vertical: TerraceAISpacing.base),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: TerraceAIText.bodyMedium,
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: TerraceAIColors.surface2,
    hintStyle: TerraceAIText.caption,
    contentPadding: const EdgeInsets.all(TerraceAISpacing.base),
    border: OutlineInputBorder(
      borderRadius: TerraceAIRadii.smRadius,
      borderSide: const BorderSide(color: TerraceAIColors.line),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: TerraceAIRadii.smRadius,
      borderSide: const BorderSide(color: TerraceAIColors.line),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: TerraceAIRadii.smRadius,
      borderSide: const BorderSide(color: TerraceAIColors.primary, width: 1.5),
    ),
  ),

  dividerTheme: const DividerThemeData(
    color: TerraceAIColors.line,
    thickness: 1,
  ),
);
