
import 'package:equatable/equatable.dart';

abstract class NotificationSettingsEvent extends Equatable {
  const NotificationSettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotificationSettings extends NotificationSettingsEvent {
  const LoadNotificationSettings();
}

class UpdateNotificationSetting extends NotificationSettingsEvent {
  final String key;
  final bool value;

  const UpdateNotificationSetting({
    required this.key,
    required this.value,
  });

  @override
  List<Object?> get props => [key, value];
}
