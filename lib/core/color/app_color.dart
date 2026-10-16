
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primaryGreen = Color(0xFF00D09E);
  static const Color lightGreen = Color(0xFFF1FFF3);
  static const Color softGreen = Color(0xFFDDF5E2);
  static const Color darkGreen = Color(0xFF063F3F);

  static const Color blue = Color(0xFF4DA3FF);
  static const Color strongBlue = Color(0xFF246BCE);
  static const Color calendarBlue = Color(0xFF5B8DEF);
  static const Color blueLight = Color(0xFFEAF2FF);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF1FFF3);
  static const Color lightSurface = Colors.white;
  static const Color lightCard = Colors.white;
  static const Color lightText = Color(0xFF063F3F);
  static const Color lightSecondaryText = Color(0xFF6B7280);
  static const Color lightDivider = Color(0xFFDDF5E2);
  static const Color lightSearchField = Color(0xFFF5F7F8);


  // Dark theme — matched more closely to Figma
  static const Color darkBackground = Color(0xFF062E2C);
  static const Color darkSurface = Color(0xFF0B3835);
  static const Color darkCard = Color(0xFF103F3B);
  static const Color darkText = Color(0xFFF5FAFA);
  static const Color darkSecondaryText = Color(0xFFB7D0CC);
  static const Color darkDivider = Color(0xFF24534E);
  static const Color darkSearchField = Color(0xFF16443F);

  // Common Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color error = Color(0xFFE53935);

  // Progress Colors
  static const Color progressTrack = Color(0xFFE5E7EB);
  static const Color progressFill = primaryGreen;
  static const Color darkProgressTrack = Color(0xFF344541);

  static const List<Color> pieColors = [
    primaryGreen,
    blue,
    Color(0xFFFFB74D),
    Color(0xFFAB7AE8),
    Color(0xFFFF6B6B),
  ];

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color background(BuildContext context) {
    return isDark(context) ? darkBackground : lightBackground;
  }

  // Theme-Aware Surface
  static Color surface(BuildContext context) {
    return isDark(context) ? darkSurface : lightSurface;
  }

  static Color card(BuildContext context) {
    return isDark(context) ? darkCard : lightCard;
  }

  static Color text(BuildContext context) {
    return isDark(context) ? darkText : lightText;
  }

  static Color secondaryText(BuildContext context) {
    return isDark(context)
        ? darkSecondaryText
        : lightSecondaryText;
  }

  // Theme-Aware Divider
  static Color divider(BuildContext context) {
    return isDark(context) ? darkDivider : lightDivider;
  }

  static Color searchField(BuildContext context) {
    return isDark(context)
        ? darkSearchField
        : lightSearchField;
  }

  static Color progressTrackColor(BuildContext context) {
    return isDark(context)
        ? darkProgressTrack
        : progressTrack;
  }
}
