import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/notification/notification_usecase.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc
    extends Bloc<NotificationEvent, NotificationState> {
  final WatchNotificationsUseCase watchNotificationsUseCase;
  final MarkNotificationReadUseCase markNotificationReadUseCase;
  final MarkAllNotificationsReadUseCase
  markAllNotificationsReadUseCase;
  final DeleteAllNotificationsUseCase deleteAllNotificationsUseCase;

  StreamSubscription? notificationSubscription;

  NotificationBloc({
    required this.watchNotificationsUseCase,
    required this.markNotificationReadUseCase,
    required this.markAllNotificationsReadUseCase,
    required this.deleteAllNotificationsUseCase,
  }) : super(const NotificationState()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkNotificationRead>(_onMarkNotificationRead);
    on<MarkAllNotificationsRead>(_onMarkAllNotificationsRead);
    on<DeleteAllNotifications>(_onDeleteAllNotifications);
  }

  Future<void> _onLoadNotifications(
      LoadNotifications event,
      Emitter<NotificationState> emit,
      ) async {
    await notificationSubscription?.cancel();

    emit(state.copyWith(
      status: NotificationStatus.loading,
      clearError: true,
    ));

    notificationSubscription = watchNotificationsUseCase().listen(
          (notifications) {
        if (!isClosed) {
          emitFromStream(notifications);
        }
      },
      onError: (Object error) {
        if (!isClosed) {
          addError(error);
        }
      },
    );
  }

  void emitFromStream(List<dynamic> notifications) {
    add(_NotificationsReceived(notifications.cast()));
  }

  Future<void> _onMarkNotificationRead(
      MarkNotificationRead event,
      Emitter<NotificationState> emit,
      ) async {
    try {
      await markNotificationReadUseCase(event.notificationId);
    } catch (error) {
      emit(state.copyWith(errorMessage: error.toString()));
    }
  }

  Future<void> _onMarkAllNotificationsRead(
      MarkAllNotificationsRead event,
      Emitter<NotificationState> emit,
      ) async {
    try {
      final ids = state.notifications
          .where((notification) => !notification.isRead)
          .map((notification) => notification.id)
          .toList();

      if (ids.isNotEmpty) {
        await markAllNotificationsReadUseCase(ids);
      }
    } catch (error) {
      emit(state.copyWith(errorMessage: error.toString()));
    }
  }

  Future<void> _onDeleteAllNotifications(
      DeleteAllNotifications event,
      Emitter<NotificationState> emit,
      ) async {
    emit(state.copyWith(isDeleting: true, clearError: true));

    try {
      await deleteAllNotificationsUseCase();
      emit(state.copyWith(isDeleting: false));
    } catch (error) {
      emit(state.copyWith(
        isDeleting: false,
        errorMessage: error.toString(),
      ));
    }
  }

  @override
  Future<void> close() async {
    await notificationSubscription?.cancel();
    return super.close();
  }
}

class _NotificationsReceived extends NotificationEvent {
  final List notifications;

  const _NotificationsReceived(this.notifications);

  @override
  List<Object?> get props => [notifications];
}