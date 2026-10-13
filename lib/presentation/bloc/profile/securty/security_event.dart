
import 'package:equatable/equatable.dart';

abstract class SecurityEvent extends Equatable {
  const SecurityEvent();

  @override
  List<Object?> get props => [];
}

class CheckPinRequested extends SecurityEvent {
  const CheckPinRequested();
}

class ChangePinRequested extends SecurityEvent {
  final String currentPin;
  final String newPin;

  const ChangePinRequested({
    required this.currentPin,
    required this.newPin,
  });

  @override
  List<Object?> get props => [currentPin, newPin];
}
