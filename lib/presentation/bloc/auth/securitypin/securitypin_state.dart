import 'package:equatable/equatable.dart';

abstract class SecurityPinState extends Equatable {
  const SecurityPinState();

  @override
  List<Object?> get props => [];
}

class SecurityPinInitial extends SecurityPinState {}

class SecurityPinLoading extends SecurityPinState {}

class SecurityPinSuccess extends SecurityPinState {}

class SecurityPinFailure extends SecurityPinState {
  final String message;

  const SecurityPinFailure({
    required this.message,
  });

  @override
  List<Object?> get props => [
    message,
  ];
}