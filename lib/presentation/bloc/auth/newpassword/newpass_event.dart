import 'package:equatable/equatable.dart';

abstract class NewPasswordEvent extends Equatable {
  const NewPasswordEvent();

  @override
  List<Object?> get props => [];
}

class NewPasswordSubmitted extends NewPasswordEvent {
  final String password;
  final String confirmPassword;

  const NewPasswordSubmitted({
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [
    password,
    confirmPassword,
  ];
}