import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordButtonPressed
    extends ForgotPasswordEvent {
  final String email;

  const ForgotPasswordButtonPressed({
    required this.email,
  });

  @override
  List<Object?> get props => [
    email,
  ];
}