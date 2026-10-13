import '../../entities/notification/notification.dart';
import '../../repositories/notification/notification_repository.dart';

class WatchNotificationsUseCase {
  final NotificationRepository repository;

  WatchNotificationsUseCase({required this.repository});

  Stream<List<AppNotification>> call() {
    return repository.watchNotifications();
  }
}

class MarkNotificationReadUseCase {
  final NotificationRepository repository;

  MarkNotificationReadUseCase({required this.repository});

  Future<void> call(String id) {
    return repository.markNotificationRead(id);
  }
}

class MarkAllNotificationsReadUseCase {
  final NotificationRepository repository;

  MarkAllNotificationsReadUseCase({required this.repository});

  Future<void> call(List<String> ids) {
    return repository.markAllNotificationsRead(ids);
  }
}

class CreateNotificationUseCase {
  final NotificationRepository repository;

  CreateNotificationUseCase({required this.repository});

  Future<String> call({
    required String title,
    required String message,
    required String type,
    String details = '',
    DateTime? scheduledAt,
    String? sourceId,
  }) {
    return repository.createNotification(
      title: title,
      message: message,
      type: type,
      details: details,
      scheduledAt: scheduledAt,
      sourceId: sourceId,
    );
  }
}

class DeleteAllNotificationsUseCase {
  final NotificationRepository repository;

  DeleteAllNotificationsUseCase({required this.repository});

  Future<void> call() {
    return repository.deleteAllNotifications();
  }
}