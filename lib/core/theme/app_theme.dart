
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../color/app_color.dart';
import '../prefrences/app_prefrences.dart';

class AppTheme {
  AppTheme._();

  static final ValueNotifier<ThemeMode> themeMode =
  ValueNotifier<ThemeMode>(ThemeMode.light);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      primaryColor: AppColors.primaryGreen,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        brightness: Brightness.light,
        primary: AppColors.primaryGreen,
        secondary: AppColors.blue,
        surface: AppColors.lightSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.darkGreen,
        elevation: 0,
      ),
      cardColor: AppColors.lightCard,
      dividerColor: AppColors.lightDivider,
      iconTheme: const IconThemeData(
        color: AppColors.lightText,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? AppColors.primaryGreen
              : Colors.grey;
        }),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      primaryColor: AppColors.primaryGreen,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        brightness: Brightness.dark,
        primary: AppColors.primaryGreen,
        secondary: AppColors.blue,
        surface: AppColors.darkSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkText,
        elevation: 0,
      ),
      cardColor: AppColors.darkCard,
      dividerColor: AppColors.darkDivider,
      iconTheme: const IconThemeData(
        color: AppColors.darkText,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? AppColors.primaryGreen
              : Colors.grey;
        }),
      ),
    );
  }

  static void setDarkMode(bool enabled) {
    themeMode.value = enabled ? ThemeMode.dark : ThemeMode.light;
  }

  static Future<void> loadSavedTheme(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('dark_mode_$uid') ?? false;

    setDarkMode(isDark);
  }

  static Future<void> initialize() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final isDark = await AppPreferences.getDarkMode(user.uid);
      setDarkMode(isDark);
    }
  }
}
