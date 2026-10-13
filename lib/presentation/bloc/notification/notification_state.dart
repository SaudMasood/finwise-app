import 'package:equatable/equatable.dart';
import '../../../domain/entities/notification/notification.dart';

enum NotificationStatus {
  initial,
  loading,
  success,
  failure,
}

class NotificationState extends Equatable {
  final NotificationStatus status;
  final List<AppNotification> notifications;
  final String? errorMessage;
  final bool isDeleting;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.notifications = const [],
    this.errorMessage,
    this.isDeleting = false,
  });

  NotificationState copyWith({
    NotificationStatus? status,
    List<AppNotification>? notifications,
    String? errorMessage,
    bool clearError = false,
    bool? isDeleting,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      errorMessage:
      clearError ? null : errorMessage ?? this.errorMessage,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }

  @override
  List<Object?> get props => [
    status,
    notifications,
    errorMessage,
    isDeleting,
  ];
}