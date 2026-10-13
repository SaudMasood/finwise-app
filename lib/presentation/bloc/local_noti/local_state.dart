import 'package:equatable/equatable.dart';

enum NotificationSettingsStatus {
  initial,
  loading,
  loaded,
  failure,
}

class NotificationSettingsState extends Equatable {
  final NotificationSettingsStatus status;
  final Map<String, bool> settings;
  final Set<String> savingKeys;
  final String? errorMessage;

  const NotificationSettingsState({
    this.status = NotificationSettingsStatus.initial,
    this.settings = const {},
    this.savingKeys = const {},
    this.errorMessage,
  });

  NotificationSettingsState copyWith({
    NotificationSettingsStatus? status,
    Map<String, bool>? settings,
    Set<String>? savingKeys,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationSettingsState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
      savingKeys: savingKeys ?? this.savingKeys,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    settings,
    savingKeys,
    errorMessage,
  ];
}