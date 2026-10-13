import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/deleteacc/deleteacc.dart';
import 'deleteaccount_event.dart';
import 'deleteaccount_state.dart';


class DeleteAccountBloc
    extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  final DeleteAccountUseCase deleteAccountUseCase;

  DeleteAccountBloc({
    required this.deleteAccountUseCase,
  }) : super(DeleteAccountInitial()) {
    on<DeleteAccountRequested>(_onDeleteAccount);
  }

  Future<void> _onDeleteAccount(
      DeleteAccountRequested event,
      Emitter<DeleteAccountState> emit,
      ) async {
    emit(DeleteAccountLoading());

    try {
      await deleteAccountUseCase(
        password: event.password,
      );

      emit(const DeleteAccountSuccess());
    } on FirebaseAuthException catch (e) {
      final String message;

      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          message = 'The password you entered is incorrect.';
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
        case 'user-not-found':
          message = 'Your account could not be found.';
          break;
        default:
          message = e.message ?? 'Unable to delete your account.';
      }

      emit(DeleteAccountFailure(message));
    } catch (e) {
      emit(
        DeleteAccountFailure(
          e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}