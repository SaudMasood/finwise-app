
import 'package:finwise/presentation/bloc/auth/signup/signup_event.dart';
import 'package:finwise/presentation/bloc/auth/signup/signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/auth/signupusecase.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupUseCase signupUseCase;

  SignupBloc({
    required this.signupUseCase,
  }) : super(SignupInitial()) {
    on<SignupButtonPressed>(_signup);
  }

  Future<void> _signup(
      SignupButtonPressed event,
      Emitter<SignupState> emit,
      ) async {
    emit(SignupLoading());

    try {
      await signupUseCase(
        email: event.email,
        password: event.password,
      );

      emit(SignupSuccess());
    } catch (e) {
      String message = 'Signup failed. Please try again.';

      if (e.toString().contains('email-already-in-use')) {
        message = 'This email is already registered.';
      } else if (e.toString().contains('invalid-email')) {
        message = 'Please enter a valid email.';
      } else if (e.toString().contains('weak-password')) {
        message = 'Password is too weak.';
      } else if (e.toString().contains('network-request-failed')) {
        message = 'Check your internet connection.';
      }

      emit(
        SignupFailure(
          message: message,
        ),
      );
    }
  }
}