import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/local_notification.dart';
import '../../../domain/repositories/local_notific/local.dart';
import 'local_event.dart';
import 'local_state.dart';
class NotificationSettingsBloc
    extends Bloc<NotificationSettingsEvent, NotificationSettingsState> {
  final NotificationSettingsRepository repository;
  final LocalNotificationService notificationService;

  NotificationSettingsBloc({
    required this.repository,
    required this.notificationService,
  }) : super(const NotificationSettingsState()) {
    on<LoadNotificationSettings>(_loadSettings);
    on<UpdateNotificationSetting>(_updateSetting);
  }

  Future<void> _loadSettings(
      LoadNotificationSettings event,
      Emitter<NotificationSettingsState> emit,
      ) async {
    emit(state.copyWith(
      status: NotificationSettingsStatus.loading,
      clearError: true,
    ));

    try {
      final settings = await repository.getSettings();

      emit(state.copyWith(
        status: NotificationSettingsStatus.loaded,
        settings: settings,
        clearError: true,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: NotificationSettingsStatus.failure,
        errorMessage: 'Unable to load notification settings.',
      ));
    }
  }

  Future<void> _updateSetting(
      UpdateNotificationSetting event,
      Emitter<NotificationSettingsState> emit,
      ) async {
    if (state.savingKeys.contains(event.key)) return;

    if (!state.settings.containsKey(event.key)) return;

    final previousValue = state.settings[event.key]!;
    final updatedSettings = Map<String, bool>.from(state.settings)
      ..[event.key] = event.value;

    final savingKeys = Set<String>.from(state.savingKeys)
      ..add(event.key);

    emit(state.copyWith(
      settings: updatedSettings,
      savingKeys: savingKeys,
      clearError: true,
    ));

    try {
      await repository.updateSetting(event.key, event.value);

      if (event.key == 'generalNotification' ||
          event.key == 'expenseReminder') {
        await notificationService.refreshReminderSchedule();
      }

      final remainingKeys = Set<String>.from(state.savingKeys)
        ..remove(event.key);

      emit(state.copyWith(
        status: NotificationSettingsStatus.loaded,
        savingKeys: remainingKeys,
        clearError: true,
      ));
    } catch (_) {
      final restoredSettings = Map<String, bool>.from(state.settings)
        ..[event.key] = previousValue;

      final remainingKeys = Set<String>.from(state.savingKeys)
        ..remove(event.key);

      emit(state.copyWith(
        status: NotificationSettingsStatus.loaded,
        settings: restoredSettings,
        savingKeys: remainingKeys,
        errorMessage: 'Unable to save notification settings.',
      ));
    }
  }
}