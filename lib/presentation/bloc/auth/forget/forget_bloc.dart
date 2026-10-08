import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/auth/forget.dart';
import 'forget_event.dart';
import 'forget_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordUseCase forgotPasswordUseCase;

  ForgotPasswordBloc({
    required this.forgotPasswordUseCase,
  }) : super(ForgotPasswordInitial()) {
    on<ForgotPasswordButtonPressed>(
      _forgotPassword,
    );
  }

  Future<void> _forgotPassword(
      ForgotPasswordButtonPressed event,
      Emitter<ForgotPasswordState> emit,
      ) async {
    emit(ForgotPasswordLoading());

    try {
      await forgotPasswordUseCase(
        email: event.email,
      );

      emit(ForgotPasswordSuccess());
    } catch (e) {
      String message =
          'Unable to send password reset email.';

      if (e.toString().contains('invalid-email')) {
        message = 'Please enter a valid email.';
      } else if (e.toString().contains('user-not-found')) {
        message = 'No account found with this email.';
      } else if (e
          .toString()
          .contains('network-request-failed')) {
        message = 'Check your internet connection.';
      }

      emit(
        ForgotPasswordFailure(
          message: message,
        ),
      );
    }
  }
}