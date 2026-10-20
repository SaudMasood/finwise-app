import '../../../domain/entities/notification/notification.dart';
import '../../../domain/repositories/notification/notification_repository.dart';
import '../../datasources/firestore_notification_datasource.dart';

class NotificationRepositoryImpl
    implements NotificationRepository {
  final NotificationDataSource dataSource;

  NotificationRepositoryImpl({required this.dataSource});

  @override
  Stream<List<AppNotification>> watchNotifications() {
    return dataSource.watchNotifications().map((items) {
      return items.map((item) {
        DateTime parseDate(dynamic value) {
          if (value is DateTime) return value;
          if (value != null && value.toDate is Function) {
            return value.toDate() as DateTime;
          }
          return DateTime.now();
        }

        final createdAt = item['createdAt'];
        final scheduledAt = item['scheduledAt'];

        return AppNotification(
          id: item['id'] as String? ?? '',
          title: item['title'] as String? ?? 'Notification',
          message: item['message'] as String? ?? '',
          details: item['details'] as String? ?? '',
          type: item['type'] as String? ?? 'general',
          createdAt: parseDate(createdAt),
          scheduledAt:
          scheduledAt == null ? null : parseDate(scheduledAt),
          isRead: item['isRead'] as bool? ?? false,
        );
      }).toList();
    });
  }

  @override
  Future<void> markNotificationRead(String id) {
    return dataSource.markNotificationRead(id);
  }

  @override
  Future<void> markAllNotificationsRead(List<String> ids) {
    return dataSource.markAllNotificationsRead(ids);
  }

  @override
  Future<String> createNotification({
    required String title,
    required String message,
    required String type,
    String details = '',
    DateTime? scheduledAt,
    String? sourceId,
  }) {
    return dataSource.createNotification(
      title: title,
      message: message,
      type: type,
      details: details,
      scheduledAt: scheduledAt,
      sourceId: sourceId,
    );
  }

  @override
  Future<void> deleteAllNotifications() {
    return dataSource.deleteAllNotifications();
  }
}