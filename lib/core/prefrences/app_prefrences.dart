
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  AppPreferences._();

  static const String _notificationPrefix = 'finwise_notification_';

//darkmode seting
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

  // ---------------- NOTIFICATION DEFAULTS ----------------

  static const Map<String, bool> defaultNotificationSettings = {
    'generalNotification': true,
    'sound': true,
    'soundCall': true,
    'vibrate': true,
    'transactionUpdate': true,
    'expenseReminder': true,
    'budgetNotifications': true,
    'lowBalanceAlerts': true,
  };

  static String _notificationKey(String uid, String key) {
    return '${_notificationPrefix}${uid}_$key';
  }

  // Load all notification preferences.
  static Future<Map<String, bool>> getNotificationSettings(
      String uid,
      ) async {
    final prefs = await SharedPreferences.getInstance();

    return {
      for (final entry in defaultNotificationSettings.entries)
        entry.key: prefs.getBool(
          _notificationKey(uid, entry.key),
        ) ??
            entry.value,
    };
  }

  // Save one notification preference.
  static Future<void> saveNotificationSetting({
    required String uid,
    required String key,
    required bool enabled,
  }) async {
    if (!defaultNotificationSettings.containsKey(key)) {
      throw ArgumentError.value(
        key,
        'key',
        'Unknown notification setting',
      );
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      _notificationKey(uid, key),
      enabled,
    );
  }


  static Future<String?> getProfileImagePath(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('profile_image_$uid');
  }

  static Future<void> saveProfileImagePath({
    required String uid,
    required String imagePath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_$uid', imagePath);
  }

  static Future<void> removeProfileImagePath(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_image_$uid');
  }
}
