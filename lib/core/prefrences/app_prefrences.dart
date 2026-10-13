
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static Future<bool> getDarkMode(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('dark_mode_$uid') ?? false;
  }

  static Future<void> saveDarkMode(
      String uid,
      bool enabled,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode_$uid', enabled);
  }
}
