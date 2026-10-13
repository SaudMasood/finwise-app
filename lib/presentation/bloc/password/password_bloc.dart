import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/paswrd/password.dart';
import 'password_event.dart';
import 'password_state.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final ChangePasswordUseCase changePasswordUseCase;

  PasswordBloc({
    required this.changePasswordUseCase,
  }) : super(PasswordInitial()) {
    on<ChangePasswordRequested>(_onChangePassword);
  }

  Future<void> _onChangePassword(
      ChangePasswordRequested event,
      Emitter<PasswordState> emit,
      ) async {
    emit(PasswordLoading());

    try {
      await changePasswordUseCase(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      );

      emit(
        const PasswordSuccess(
          'Password changed successfully.',
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          message = 'Your current password is incorrect.';
          break;
        case 'weak-password':
          message = 'Your new password is too weak.';
          break;
        case 'requires-recent-login':
          message = 'Please sign in again and retry.';
          break;
        case 'network-request-failed':
          message = 'Network error. Please try again.';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Please try again later.';
          break;
        default:
          message = e.message ?? 'Unable to change password.';
      }

      emit(PasswordFailure(message));
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      emit(PasswordFailure(message));
    }
  }
}