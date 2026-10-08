import 'package:flutter_bloc/flutter_bloc.dart';

import 'newpass_event.dart';
import 'newpass_state.dart';

class NewPasswordBloc
    extends Bloc<NewPasswordEvent, NewPasswordState> {
  NewPasswordBloc() : super(NewPasswordInitial()) {
    on<NewPasswordSubmitted>(_changePassword);
  }

  Future<void> _changePassword(
      NewPasswordSubmitted event,
      Emitter<NewPasswordState> emit,
      ) async {
    emit(NewPasswordLoading());

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    if (event.password.isEmpty) {
      emit(
        const NewPasswordFailure(
          message: 'Please enter a new password.',
        ),
      );
      return;
    }

    if (event.confirmPassword.isEmpty) {
      emit(
        const NewPasswordFailure(
          message: 'Please confirm your password.',
        ),
      );
      return;
    }

    if (event.password.length < 6) {
      emit(
        const NewPasswordFailure(
          message: 'Password must be at least 6 characters.',
        ),
      );
      return;
    }

    if (event.password != event.confirmPassword) {
      emit(
        const NewPasswordFailure(
          message: 'Passwords do not match.',
        ),
      );
      return;
    }

    emit(NewPasswordSuccess());
  }
}