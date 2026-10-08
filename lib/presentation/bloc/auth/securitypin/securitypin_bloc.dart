import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'securitypin_event.dart';
import 'securitypin_state.dart';

class SecurityPinBloc
    extends Bloc<SecurityPinEvent, SecurityPinState> {
  final FirebaseAuth firebaseAuth;

  SecurityPinBloc({
    required this.firebaseAuth,
  }) : super(SecurityPinInitial()) {
    on<SecurityEmailChecked>(_emailChecked);
    on<SecurityEmailResend>(_resendEmail);
  }

  Future<void> _emailChecked(
      SecurityEmailChecked event,
      Emitter<SecurityPinState> emit,
      ) async {
    emit(SecurityPinLoading());

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    emit(SecurityPinSuccess());
  }

  Future<void> _resendEmail(
      SecurityEmailResend event,
      Emitter<SecurityPinState> emit,
      ) async {
    emit(SecurityPinLoading());

    try {
      await firebaseAuth.sendPasswordResetEmail(
        email: event.email,
      );

      emit(SecurityPinSuccess());
    } on FirebaseAuthException catch (e) {
      String message = 'Unable to send reset email.';

      if (e.code == 'invalid-email') {
        message = 'Please enter a valid email.';
      } else if (e.code == 'user-not-found') {
        message = 'No account found with this email.';
      } else if (e.code == 'network-request-failed') {
        message = 'Check your internet connection.';
      }

      emit(
        SecurityPinFailure(
          message: message,
        ),
      );
    } catch (e) {
      emit(
        const SecurityPinFailure(
          message: 'Something went wrong. Please try again.',
        ),
      );
    }
  }
}