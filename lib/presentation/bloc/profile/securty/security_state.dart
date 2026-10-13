
import 'package:equatable/equatable.dart';

abstract class SecurityState extends Equatable {
  const SecurityState();

  @override
  List<Object?> get props => [];
}

class SecurityInitial extends SecurityState {
  const SecurityInitial();
}

class SecurityLoading extends SecurityState {
  const SecurityLoading();
}

class SecurityPinStatusLoaded extends SecurityState {
  final bool hasPin;

  const SecurityPinStatusLoaded(this.hasPin);

  @override
  List<Object?> get props => [hasPin];
}

class SecurityPinChanged extends SecurityState {
  const SecurityPinChanged();
}

class SecurityFailure extends SecurityState {
  final String message;

  const SecurityFailure(this.message);

  @override
  List<Object?> get props => [message];
}
