import 'package:flutter/material.dart';
import 'camper_tokens.dart';

// Compatibility Layer for "CamperAI" -> "CamperAI" refactor
// This allows the rest of the app to function while we redesign components.

class CamperAIColors {
  // Mapping to new tokens
  static const canvasWhite = CamperTokens.ink0;
  static const soleBlack = CamperTokens.bg0;
  static const richBrown = CamperTokens.bg1;
  static const leatherTan = CamperTokens.primary;
  static const metallicGold = CamperTokens.accentAmber;
  static const laceGray = CamperTokens.muted;
  static const error = CamperTokens.danger;

  // Direct access
  static const primary = CamperTokens.primary;
  static const surface = CamperTokens.surface;
  static const surface2 = CamperTokens.surface2;
  static const textMain = CamperTokens.ink0;
  static const textBody = CamperTokens.ink1;
}

class CamperAISpacing {
  static const double xs = CamperTokens.xs;
  static const double sm = CamperTokens.sm;
  static const double md = CamperTokens.md;
  static const double base = CamperTokens.base;
  static const double lg = CamperTokens.lg;
  static const double xl = CamperTokens.xl;
  static const double xxl = CamperTokens.xxl;
}

class CamperAIRadii {
  static BorderRadius get cardRadius => BorderRadius.circular(CamperTokens.rMd);
  static BorderRadius get buttonRadius => BorderRadius.circular(CamperTokens.rLg);
  static BorderRadius get modalRadius => BorderRadius.circular(CamperTokens.rXl);
}

class CamperAIText {
  static final _theme = CamperTokens.getTextTheme();

  static TextStyle get h1 => _theme.displayLarge!;
  static TextStyle get h2 => _theme.displayMedium!;
  static TextStyle get h3 => _theme.displaySmall!;
  static TextStyle get body => _theme.bodyLarge!;
  static TextStyle get bodyMedium => _theme.bodyMedium!.copyWith(fontSize: 16);
  static TextStyle get caption => _theme.labelSmall!;
  static TextStyle get button => _theme.labelLarge!;
}

// =================== THEME DATA ===================

final camperVanTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  colorScheme: ColorScheme.dark(
    primary: CamperTokens.primary,
    secondary: CamperTokens.accentAmber,
    surface: CamperTokens.surface,
    onSurface: CamperTokens.ink0,
    background: CamperTokens.bg0,
    onBackground: CamperTokens.ink0,
    error: CamperTokens.danger,
  ),

  scaffoldBackgroundColor: CamperTokens.bg0,

  textTheme: CamperTokens.getTextTheme(),

  appBarTheme: AppBarTheme(
    centerTitle: true,
    backgroundColor: Colors.transparent,
    foregroundColor: CamperTokens.ink0,
    elevation: 0,
    titleTextStyle: CamperTokens.getTextTheme().displaySmall!.copyWith(fontSize: 20),
  ),

  cardTheme: CardThemeData(
    color: CamperTokens.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CamperTokens.rMd)),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: CamperTokens.primary,
      foregroundColor: CamperTokens.bg0,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CamperTokens.rLg)),
      textStyle: CamperTokens.getTextTheme().labelLarge,
    ),
  ),
);
