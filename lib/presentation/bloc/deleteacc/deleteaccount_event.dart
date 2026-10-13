import 'package:equatable/equatable.dart';

abstract class DeleteAccountEvent extends Equatable {
  const DeleteAccountEvent();

  @override
  List<Object?> get props => [];
}

class DeleteAccountRequested extends DeleteAccountEvent {
  final String password;

  const DeleteAccountRequested({
    required this.password,
  });

  @override
  List<Object?> get props => [password];
}