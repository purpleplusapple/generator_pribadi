import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'terrace_tokens.dart';

// =================== COMPATIBILITY LAYER ===================
// These classes allow existing code (mass-renamed) to compile while redirecting to new tokens.

class TerraceColors {
  TerraceColors._();

  static const bg0 = TerraceTokens.bg0;
  static const bg1 = TerraceTokens.bg1;
  static const surface = TerraceTokens.surface;

  static const richBrown = TerraceTokens.bg1; // Mapped
  static const canvasWhite = TerraceTokens.ink0;
  static const soleBlack = TerraceTokens.bg0;

  static const leatherTan = TerraceTokens.accentAmber;
  static const metallicGold = TerraceTokens.primaryEmerald; // Emerald is primary now
  static const laceGray = TerraceTokens.muted;

  static const success = TerraceTokens.success;
  static const warning = TerraceTokens.accentAmber;
  static const error = TerraceTokens.danger;

  static const textMain = TerraceTokens.ink0;
  static const textMuted = TerraceTokens.muted;
}

class TerraceSpacing {
  TerraceSpacing._();
  static const double xs = TerraceTokens.spaceXs;
  static const double sm = TerraceTokens.spaceSm;
  static const double md = 12; // Legacy
  static const double base = TerraceTokens.spaceMd;
  static const double lg = 20; // Legacy
  static const double xl = TerraceTokens.spaceLg;
  static const double xxl = TerraceTokens.spaceXl;
  static const double xxxl = 40;
  static const double huge = TerraceTokens.spaceXxl;
  static const double massive = 64;
}

class TerraceRadii {
  TerraceRadii._();
  static const double chip = TerraceTokens.radiusSmall;
  static const double button = TerraceTokens.radiusMedium;
  static const double card = TerraceTokens.radiusMedium;
  static const double cardLarge = TerraceTokens.radiusLarge;

  static BorderRadius get chipRadius => BorderRadius.circular(chip);
  static BorderRadius get buttonRadius => BorderRadius.circular(button);
  static BorderRadius get cardRadius => BorderRadius.circular(card);
}

class TerraceShadows {
  TerraceShadows._();
  static List<BoxShadow> get card => TerraceTokens.shadowSoft;
  static List<BoxShadow> goldGlow({double opacity = 0.4}) => TerraceTokens.shadowGlow;
}

class TerraceGradients {
  TerraceGradients._();
  static const primaryCta = LinearGradient(
    colors: [TerraceTokens.primaryEmerald, TerraceTokens.success],
  );
}

// =================== NEW TYPOGRAPHY ===================

class TerraceText {
  TerraceText._();

  // Heading: Fraunces (Premium Cozy)
  static final TextStyle _headingStyle = GoogleFonts.fraunces(
    color: TerraceTokens.ink0,
  );

  // Body: Inter (Clean)
  static final TextStyle _bodyStyle = GoogleFonts.inter(
    color: TerraceTokens.ink1,
  );

  static final h1 = _headingStyle.copyWith(
    fontSize: 32, fontWeight: FontWeight.w600, height: 1.2,
  );

  static final h2 = _headingStyle.copyWith(
    fontSize: 24, fontWeight: FontWeight.w600, height: 1.3,
  );

  static final h3 = _headingStyle.copyWith(
    fontSize: 20, fontWeight: FontWeight.w600, height: 1.4,
  );

  static final body = _bodyStyle.copyWith(
    fontSize: 16, fontWeight: FontWeight.w400, height: 1.5,
  );

  static final bodyMedium = _bodyStyle.copyWith(
    fontSize: 16, fontWeight: FontWeight.w500, height: 1.5,
  );

  static final caption = _bodyStyle.copyWith(
    fontSize: 14, fontWeight: FontWeight.w400, height: 1.4,
    color: TerraceTokens.muted,
  );

  static final button = _bodyStyle.copyWith(
    fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5,
  );
}

// =================== THEME DATA ===================

final terraceTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  colorScheme: const ColorScheme.dark(
    primary: TerraceTokens.primaryEmerald,
    secondary: TerraceTokens.accentAmber,
    tertiary: TerraceTokens.accentViolet,
    surface: TerraceTokens.surface,
    error: TerraceTokens.danger,
    onSurface: TerraceTokens.ink0,
    background: TerraceTokens.bg0,
  ),

  scaffoldBackgroundColor: TerraceTokens.bg0,

  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: TerraceTokens.ink0,
    titleTextStyle: TerraceText.h3,
    elevation: 0,
  ),

  textTheme: TextTheme(
    displayLarge: TerraceText.h1,
    bodyLarge: TerraceText.body,
    bodyMedium: TerraceText.bodyMedium,
    labelLarge: TerraceText.button,
  ),

  cardTheme: CardTheme(
    color: TerraceTokens.surface.withValues(alpha: 0.8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TerraceTokens.radiusMedium)),
    elevation: 0,
  ),
);
