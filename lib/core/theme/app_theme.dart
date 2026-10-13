
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../prefrences/app_prefrences.dart';

class AppTheme {
  static const Color mainGreen = Color(0xFF00D09E);
  static const Color lightGreen = Color(0xFFF1FFF3);
  static const Color softGreen = Color(0xFFDDF5E2);
  static const Color darkGreen = Color(0xFF063F3F);
  static const Color blue = Color(0xFF4DA3FF);

  static final ValueNotifier<ThemeMode> themeMode =
  ValueNotifier<ThemeMode>(ThemeMode.light);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightGreen,
      colorScheme: ColorScheme.fromSeed(
        seedColor: mainGreen,
        brightness: Brightness.light,
        primary: mainGreen,
        secondary: blue,
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: mainGreen,
        foregroundColor: darkGreen,
      ),
      cardColor: Colors.white,
      dividerColor: softGreen,
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? mainGreen
              : Colors.grey;
        }),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121A19),
      colorScheme: ColorScheme.fromSeed(
        seedColor: mainGreen,
        brightness: Brightness.dark,
        primary: mainGreen,
        secondary: blue,
        surface: const Color(0xFF1D2927),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: const Color(0xFF1D2927),
        foregroundColor: Colors.white,
      ),
      cardColor: const Color(0xFF1D2927),
      dividerColor: const Color(0xFF344541),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? mainGreen
              : Colors.grey;
        }),
      ),
    );
  }

  static void setDarkMode(bool enabled) {
    themeMode.value =
    enabled ? ThemeMode.dark : ThemeMode.light;
  }


  static Future<void> loadSavedTheme(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('dark_mode_$uid') ?? false;

    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  static Future<void> initialize() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final isDark = await AppPreferences.getDarkMode(user.uid);
      setDarkMode(isDark);
    }
  }

}
