import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      print('LOGIN FIREBASE ERROR CODE: ${e.code}');
      print('LOGIN FIREBASE ERROR MESSAGE: ${e.message}');

      emit(
        LoginFailure(
          message: _getFirebaseMessage(e.code),
        ),
      );
    } catch (e) {
      print('LOGIN ERROR: $e');

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

      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      print('GOOGLE FIREBASE ERROR CODE: ${e.code}');
      print('GOOGLE FIREBASE ERROR MESSAGE: ${e.message}');

      emit(
        LoginFailure(
          message: 'Google Error: ${e.code}',
        ),
      );
    } catch (e) {
      print('GOOGLE LOGIN ERROR: $e');

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

      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      print('FACEBOOK FIREBASE ERROR CODE: ${e.code}');
      print('FACEBOOK FIREBASE ERROR MESSAGE: ${e.message}');

      emit(
        LoginFailure(
          message: 'Facebook Error: ${e.code}',
        ),
      );
    } catch (e) {
      print('FACEBOOK LOGIN ERROR: $e');

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