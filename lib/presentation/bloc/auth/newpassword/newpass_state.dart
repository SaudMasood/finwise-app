import 'package:equatable/equatable.dart';

abstract class NewPasswordState extends Equatable {
  const NewPasswordState();

  @override
  List<Object?> get props => [];
}

class NewPasswordInitial extends NewPasswordState {}

class NewPasswordLoading extends NewPasswordState {}

class NewPasswordSuccess extends NewPasswordState {}

class NewPasswordFailure extends NewPasswordState {
  final String message;

  const NewPasswordFailure({
    required this.message,
  });

  @override
  List<Object?> get props => [
    message,
  ];
}