
import '../../../domain/repositories/local_notific/local.dart';
import '../../datasources/local_notification.dart';

class NotificationSettingsRepositoryImpl
    implements NotificationSettingsRepository {
  final LocalNotificationService dataSource;

  NotificationSettingsRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Map<String, bool>> getSettings() {
    return dataSource.getSettings();
  }

  @override
  Future<void> updateSetting(String key, bool value) {
    return dataSource.updateSetting(key, value);
  }
}