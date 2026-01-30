import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// =================== COLOR PALETTE ===================

class GuestAIColors {
  GuestAIColors._();

  // "Boutique Guest Suite" Palette
  static const warmLinen = Color(0xFFFAF7F2); // bg0
  static const pureWhite = Color(0xFFFFFFFF); // bg1 / surface
  static const softSurface = Color(0xFFF4EFE8); // surface2

  static const inkTitle = Color(0xFF1B1612); // ink0
  static const inkBody = Color(0xFF342C26); // ink1
  static const muted = Color(0xFF6B5B52);
  static const line = Color(0xFFE7DDD4);

  // Accents
  static const brass = Color(0xFFB8844B); // primary
  static const brassSoft = Color(0xFFF1E3D8); // primarySoft
  static const deepTeal = Color(0xFF2E6F6A); // accent
  static const rose = Color(0xFFC76D7C); // accent2

  // States
  static const success = Color(0xFF1C8B6A);
  static const error = Color(0xFFC0392B);
  static const warning = Color(0xFFF39C12);

  // Aliases for compatibility/usage
  static const primary = brass;
  static const primaryContainer = brassSoft;
  static const background = warmLinen;
  static const surface = pureWhite;
  static const textMain = inkTitle;
  static const textBody = inkBody;
}

// =================== TYPOGRAPHY ===================

class GuestAIText {
  GuestAIText._();

  static final TextStyle _heading = GoogleFonts.dmSerifDisplay(
    color: GuestAIColors.inkTitle,
  );

  static final TextStyle _body = GoogleFonts.inter(
    color: GuestAIColors.inkBody,
  );

  static final h1 = _heading.copyWith(
    fontSize: 32, fontWeight: FontWeight.w400, height: 1.2, letterSpacing: -0.5,
  );

  static final h2 = _heading.copyWith(
    fontSize: 24, fontWeight: FontWeight.w400, height: 1.3,
  );

  static final h3 = _heading.copyWith(
    fontSize: 20, fontWeight: FontWeight.w400, height: 1.4,
  );

  static final body = _body.copyWith(
    fontSize: 16, fontWeight: FontWeight.w400, height: 1.5,
  );

  static final bodyMedium = _body.copyWith(
    fontSize: 16, fontWeight: FontWeight.w500, height: 1.5,
  );

  static final small = _body.copyWith(
    fontSize: 14, fontWeight: FontWeight.w400, height: 1.4,
    color: GuestAIColors.muted,
  );

  static final button = _body.copyWith(
    fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5,
  );
}

// =================== SPACING ===================

class GuestAISpacing {
  GuestAISpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

// =================== RADIUS ===================

class GuestAIRadii {
  GuestAIRadii._();
  static const double soft = 18;
  static const double regular = 22;
  static const double large = 26;

  static BorderRadius get softRadius => BorderRadius.circular(soft);
  static BorderRadius get regularRadius => BorderRadius.circular(regular);
}

// =================== THEME DATA ===================

final guestThemeData = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  scaffoldBackgroundColor: GuestAIColors.warmLinen,
  primaryColor: GuestAIColors.brass,

  colorScheme: ColorScheme.light(
    primary: GuestAIColors.brass,
    primaryContainer: GuestAIColors.brassSoft,
    secondary: GuestAIColors.deepTeal,
    surface: GuestAIColors.pureWhite,
    onPrimary: Colors.white,
    onSurface: GuestAIColors.inkTitle,
    error: GuestAIColors.error,
  ),

  appBarTheme: AppBarTheme(
    backgroundColor: GuestAIColors.warmLinen,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: GuestAIText.h3,
    iconTheme: const IconThemeData(color: GuestAIColors.inkTitle),
  ),

  cardTheme: CardTheme(
    color: GuestAIColors.pureWhite,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(GuestAIRadii.regular),
      side: const BorderSide(color: GuestAIColors.line, width: 1),
    ),
  ),

  textTheme: TextTheme(
    displayLarge: GuestAIText.h1,
    displayMedium: GuestAIText.h2,
    displaySmall: GuestAIText.h3,
    bodyLarge: GuestAIText.body,
    bodyMedium: GuestAIText.bodyMedium,
    labelLarge: GuestAIText.button,
  ),
);
