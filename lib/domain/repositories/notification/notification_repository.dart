import '../../entities/notification/notification.dart';

abstract class NotificationRepository {
  Stream<List<AppNotification>> watchNotifications();

  Future<void> markNotificationRead(String id);

  Future<void> markAllNotificationsRead(List<String> ids);

  Future<String> createNotification({
    required String title,
    required String message,
    required String type,
    String details,
    DateTime? scheduledAt,
    String? sourceId,
  });

  Future<void> deleteAllNotifications();
}