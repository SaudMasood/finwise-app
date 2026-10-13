
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/datasources/fcm_notifction.dart';
import '../../../../domain/usecases/auth/loginusecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc({
    required this.loginUseCase,
  }) : super(LoginInitial()) {
    on<LoginButtonPressed>(_login);
    on<GoogleLoginButtonPressed>(_googleLogin);
    on<FacebookLoginButtonPressed>(_facebookLogin);
  }

  Future<void> _registerFcmDevice() async {
    try {
      await FcmService().registerDevice();
    } catch (e) {
      debugPrint('FCM device registration failed: $e');
    }
  }

  Future<void> _login(
      LoginButtonPressed event,
      Emitter<LoginState> emit,
      ) async {
    emit(LoginLoading());

    try {
      await loginUseCase(
        email: event.email,
        password: event.password,
      );

      await _registerFcmDevice();

      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      debugPrint('LOGIN FIREBASE ERROR CODE: ${e.code}');
      debugPrint('LOGIN FIREBASE ERROR MESSAGE: ${e.message}');

      emit(
        LoginFailure(
          message: _getFirebaseMessage(e.code),
        ),
      );
    } catch (e) {
      debugPrint('LOGIN ERROR: $e');

      emit(
        const LoginFailure(
          message: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  Future<void> _googleLogin(
      GoogleLoginButtonPressed event,
      Emitter<LoginState> emit,
      ) async {
    emit(LoginLoading());

    try {
      await loginUseCase.loginWithGoogle();

      await _registerFcmDevice();

      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      debugPrint('GOOGLE FIREBASE ERROR CODE: ${e.code}');
      debugPrint('GOOGLE FIREBASE ERROR MESSAGE: ${e.message}');

      emit(
        LoginFailure(
          message: 'Google Error: ${e.code}',
        ),
      );
    } catch (e) {
      debugPrint('GOOGLE LOGIN ERROR: $e');

      emit(
        LoginFailure(
          message: 'Google Error: $e',
        ),
      );
    }
  }

  Future<void> _facebookLogin(
      FacebookLoginButtonPressed event,
      Emitter<LoginState> emit,
      ) async {
    emit(LoginLoading());

    try {
      await loginUseCase.loginWithFacebook();

      await _registerFcmDevice();

      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      debugPrint('FACEBOOK FIREBASE ERROR CODE: ${e.code}');
      debugPrint('FACEBOOK FIREBASE ERROR MESSAGE: ${e.message}');

      emit(
        LoginFailure(
          message: 'Facebook Error: ${e.code}',
        ),
      );
    } catch (e) {
      debugPrint('FACEBOOK LOGIN ERROR: $e');

      emit(
        LoginFailure(
          message: 'Facebook Error: $e',
        ),
      );
    }
  }

  String _getFirebaseMessage(String code) {
    switch (code) {
      case 'invalid-credential':
        return 'Invalid login credentials.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'Please enter a valid email.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Check your internet connection.';
      case 'operation-not-allowed':
        return 'This login method is not enabled in Firebase.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different login method.';
      default:
        return 'Login failed: $code';
    }
  }
}
