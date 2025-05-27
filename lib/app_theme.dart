import 'package:flutter/material.dart';

class AppTheme {
  static const Color backgroundColor = Color(0xFFFFEECE);
  static const Color backgroundSplashColor = Color(0x50FFC266);
  static const Color buttonColor1 = Color(0xFF4CAF50);  // Green
  static const Color buttonColor2 = Color(0xFFF57C00); // orange.shade700
  static const Color buttonColor3 = Color(0xFFFFB066); // Moderate choice

  static const Color borderColor = Colors.black12;
  static const double paddingSuperTiny = 2.0;
  static const double paddingTiny = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMediumSmall = 12.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingLARGE = 28.0;
  static const double paddingHuge = 32.0;
  static const double appbarHeight = 90.0;
  static const double productCardButtonWidth = 150.0;
  static const double searchbarHeight = 50.0;
  static const double searchbarFontSize = 24.0;
  static const double shoppingCartButtonFontSize = 24.0;
  static const double frameWidth = 600.0;
  static const double detailCardSize = 600.0;
  static const double accountViewSize = 739.0;
  static const double wizardCardSize = 739.0;
  static const double cartButtonSize = 24.0;

  static ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: Color(0xFFFFEECE));
  static const TextStyle accountButtonStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle logoStyle = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle smallHeading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.15,
  );
  static const TextStyle smallText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  );
  static const TextStyle mediumHeading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle mediumLargeHeading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle mediumLargeText= TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle mediumText = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  );
  static const TextStyle largeText = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  );
  static const TextStyle largeHeading = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle LARGEHeading = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle VLARGEHeading = TextStyle(
    fontSize: 54,
    fontWeight: FontWeight.w600,
  );
  static const Widget starStyle = Icon(
    Icons.star_border,
    color: Colors.black,
    size: 32,
  );

}
