import 'package:flutter/material.dart';
import 'camper_tokens.dart';

final ThemeData camperTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: CamperTokens.bg0,
  primaryColor: CamperTokens.primary,

  colorScheme: const ColorScheme.dark(
    primary: CamperTokens.primary,
    onPrimary: Colors.black,
    secondary: CamperTokens.accentSunrise,
    onSecondary: Colors.black,
    surface: CamperTokens.surface,
    onSurface: CamperTokens.ink1,
    error: CamperTokens.danger,
    onError: Colors.white,
    background: CamperTokens.bg0,
    onBackground: CamperTokens.ink1,
    surfaceTint: Colors.transparent, // Disable material 3 purple tint
  ),

  textTheme: CamperTokens.textTheme(ThemeData.dark().textTheme),

  appBarTheme: const AppBarTheme(
    backgroundColor: CamperTokens.bg0,
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    iconTheme: IconThemeData(color: CamperTokens.ink0),
    titleTextStyle: TextStyle(
      color: CamperTokens.ink0,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),

  cardTheme: CardTheme(
    color: CamperTokens.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(CamperTokens.radiusM),
      side: const BorderSide(color: CamperTokens.line, width: 1),
    ),
    margin: EdgeInsets.zero,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: CamperTokens.primary,
      foregroundColor: Colors.black,
      elevation: 0,
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CamperTokens.radiusM),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: CamperTokens.spaceL,
        vertical: CamperTokens.spaceM
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: CamperTokens.ink0,
      side: const BorderSide(color: CamperTokens.line),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CamperTokens.radiusM),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: CamperTokens.spaceL,
        vertical: CamperTokens.spaceM
      ),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: CamperTokens.bg1,
    contentPadding: const EdgeInsets.all(CamperTokens.spaceM),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(CamperTokens.radiusM),
      borderSide: const BorderSide(color: CamperTokens.line),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(CamperTokens.radiusM),
      borderSide: const BorderSide(color: CamperTokens.line),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(CamperTokens.radiusM),
      borderSide: const BorderSide(color: CamperTokens.primary),
    ),
    labelStyle: const TextStyle(color: CamperTokens.muted),
    hintStyle: const TextStyle(color: CamperTokens.muted),
  ),

  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: CamperTokens.surface,
    modalBackgroundColor: CamperTokens.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(CamperTokens.radiusL)),
    ),
  ),

  sliderTheme: SliderThemeData(
    activeTrackColor: CamperTokens.primary,
    inactiveTrackColor: CamperTokens.line,
    thumbColor: CamperTokens.primary,
    overlayColor: CamperTokens.primary.withOpacity(0.2),
  ),

  chipTheme: ChipThemeData(
    backgroundColor: CamperTokens.surface,
    selectedColor: CamperTokens.primarySoft,
    labelStyle: const TextStyle(color: CamperTokens.ink1),
    secondaryLabelStyle: const TextStyle(color: CamperTokens.primary),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(CamperTokens.radiusS),
      side: const BorderSide(color: CamperTokens.line),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  ),
);
