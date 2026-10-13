import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/logout/logout_usecase.dart';
import 'logout_event.dart';
import 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final LogoutUseCase logoutUseCase;

  LogoutBloc(this.logoutUseCase) : super(LogoutInitial()) {
    on<LogoutRequested>((event, emit) async {
      emit(LogoutLoading());

      try {
        await logoutUseCase();
        emit(LogoutSuccess());
      } catch (e) {
        emit(
          LogoutFailure(
            'Unable to log out. Please try again.',
          ),
        );
      }
    });
  }
}