import 'package:equatable/equatable.dart';

abstract class PasswordState extends Equatable {
  const PasswordState();

  @override
  List<Object?> get props => [];
}

class PasswordInitial extends PasswordState {}

class PasswordLoading extends PasswordState {}

class PasswordSuccess extends PasswordState {
  final String message;

  const PasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class PasswordFailure extends PasswordState {
  final String message;

  const PasswordFailure(this.message);

  @override
  List<Object?> get props => [message];
}