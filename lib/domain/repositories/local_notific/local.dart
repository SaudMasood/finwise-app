abstract class NotificationSettingsRepository {
  Future<Map<String, bool>> getSettings();

  Future<void> updateSetting(String key, bool value);
}