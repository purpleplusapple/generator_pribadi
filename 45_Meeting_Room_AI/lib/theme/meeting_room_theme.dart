import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'meeting_tokens.dart';

// =================== COLOR PALETTE ADAPTER ===================

class MeetingAIColors {
  MeetingAIColors._();

  // Forwarding to new Tokens
  static const bg0 = MeetingTokens.bg0;
  static const bg1 = MeetingTokens.bg1;
  static const surface = MeetingTokens.surface;
  static const ink0 = MeetingTokens.ink0;
  static const ink1 = MeetingTokens.ink1;
  static const primary = MeetingTokens.primary;
  static const accent = MeetingTokens.accent;

  // Legacy Mappings (to prevent build errors from clone)
  static const richBrown = MeetingTokens.bg0; // Background
  static const canvasWhite = MeetingTokens.ink0; // Text/Icon light
  static const soleBlack = MeetingTokens.bg1; // Dark backgrounds

  static const leatherTan = MeetingTokens.accent; // Primary Action (Blue)
  static const metallicGold = MeetingTokens.primary; // Secondary/Highlight (Steel)
  static const laceGray = MeetingTokens.muted; // Muted text

  static const success = MeetingTokens.success;
  static const warning = MeetingTokens.accentGold;
  static const error = MeetingTokens.danger;

  // Helpers
  static Color tanWithOpacity(double opacity) => leatherTan.withValues(alpha: opacity);
  static Color goldWithOpacity(double opacity) => metallicGold.withValues(alpha: opacity);
  static Color whiteWithOpacity(double opacity) => canvasWhite.withValues(alpha: opacity);

  static const pitBlack = MeetingTokens.bg0;
  static const textMain = MeetingTokens.ink0;
  static const textMuted = MeetingTokens.muted;
}

// =================== TYPOGRAPHY ===================

class MeetingRoomText {
  MeetingRoomText._();

  static final TextStyle _soraHeading = GoogleFonts.sora(
    color: MeetingTokens.ink0,
  );

  static final TextStyle _interBody = GoogleFonts.inter(
    color: MeetingTokens.ink1,
  );

  static final h1 = _soraHeading.copyWith(
    fontSize: 32, fontWeight: FontWeight.w700, height: 1.2, letterSpacing: -0.5,
  );

  static final h2 = _soraHeading.copyWith(
    fontSize: 24, fontWeight: FontWeight.w600, height: 1.3, letterSpacing: -0.3,
  );

  static final h3 = _soraHeading.copyWith(
    fontSize: 20, fontWeight: FontWeight.w600, height: 1.4, letterSpacing: -0.2,
  );

  static final body = _interBody.copyWith(
    fontSize: 16, fontWeight: FontWeight.w400, height: 1.5,
  );

  static final bodyMedium = _interBody.copyWith(
    fontSize: 16, fontWeight: FontWeight.w500, height: 1.5,
  );

  static final bodySemiBold = _interBody.copyWith(
    fontSize: 16, fontWeight: FontWeight.w600, height: 1.5,
  );

  static final caption = _interBody.copyWith(
    fontSize: 14, fontWeight: FontWeight.w400, height: 1.4,
    color: MeetingTokens.muted,
  );

  static final captionMedium = _interBody.copyWith(
    fontSize: 14, fontWeight: FontWeight.w500, height: 1.4,
    color: MeetingTokens.muted,
  );

  static final button = _interBody.copyWith(
    fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.3,
    color: Colors.white,
  );

  static final small = _interBody.copyWith(
    fontSize: 12, fontWeight: FontWeight.w400, height: 1.3,
    color: MeetingTokens.muted,
  );
}

// =================== RADIUS ===================

class MeetingAIRadii {
  MeetingAIRadii._();

  static const double chip = MeetingTokens.radiusSM;
  static const double button = MeetingTokens.radiusMD;
  static const double card = MeetingTokens.radiusLG;
  static const double cardLarge = MeetingTokens.radiusXL;
  static const double modal = MeetingTokens.radiusXL;

  static BorderRadius get chipRadius => BorderRadius.circular(chip);
  static BorderRadius get buttonRadius => BorderRadius.circular(button);
  static BorderRadius get cardRadius => BorderRadius.circular(card);
  static BorderRadius get cardLargeRadius => BorderRadius.circular(cardLarge);
  static BorderRadius get modalRadius => BorderRadius.circular(modal);
}

// =================== SPACING ===================

class MeetingRoomSpacing {
  MeetingRoomSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;
}

// =================== SHADOWS ===================

class MeetingAIShadows {
  MeetingAIShadows._();

  static List<BoxShadow> get card => [
    BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 4)),
  ];

  static List<BoxShadow> get cardElevated => [
    BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 30, offset: const Offset(0, 10)),
  ];
}

// =================== GLASS ===================

class MeetingAIGlass {
  MeetingAIGlass._();
  static const double cardBlurSigma = MeetingTokens.glassBlur;
  static const double fillOpacity = MeetingTokens.glassOpacity;
  static const double borderOpacity = MeetingTokens.glassBorderOpacity;
  static const double borderWidth = 1.0;
}

// =================== THEME DATA ===================

final meetingRoomAITheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  colorScheme: ColorScheme.dark(
    primary: MeetingTokens.accent, // Blue
    secondary: MeetingTokens.primary, // Steel
    tertiary: MeetingTokens.muted,
    error: MeetingTokens.danger,
    surface: MeetingTokens.surface,
    onSurface: MeetingTokens.ink0,
    background: MeetingTokens.bg0,
    onBackground: MeetingTokens.ink0,
  ),

  scaffoldBackgroundColor: MeetingTokens.bg0,

  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: MeetingTokens.ink0,
    titleTextStyle: MeetingRoomText.h3,
  ),

  textTheme: TextTheme(
    displayLarge: MeetingRoomText.h1,
    displayMedium: MeetingRoomText.h2,
    bodyLarge: MeetingRoomText.body,
    bodyMedium: MeetingRoomText.bodyMedium,
    labelLarge: MeetingRoomText.button,
  ),

  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: MeetingAIRadii.cardRadius),
    color: MeetingTokens.surface,
  ),
);
