import 'package:equatable/equatable.dart';

abstract class SecurityPinEvent extends Equatable {
  const SecurityPinEvent();

  @override
  List<Object?> get props => [];
}

class SecurityEmailChecked extends SecurityPinEvent {
  final String email;

  const SecurityEmailChecked({
    required this.email,
  });

  @override
  List<Object?> get props => [
    email,
  ];
}

class SecurityEmailResend extends SecurityPinEvent {
  final String email;

  const SecurityEmailResend({
    required this.email,
  });

  @override
  List<Object?> get props => [
    email,
  ];
}