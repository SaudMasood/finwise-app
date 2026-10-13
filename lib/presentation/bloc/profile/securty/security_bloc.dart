
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/repositories/profile/security_repo.dart';
import 'security_event.dart';
import 'security_state.dart';

class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  final SecurityRepository repository;

  SecurityBloc({
    required this.repository,
  }) : super(const SecurityInitial()) {
    on<CheckPinRequested>(_onCheckPin);
    on<ChangePinRequested>(_onChangePin);
  }

  Future<void> _onCheckPin(
      CheckPinRequested event,
      Emitter<SecurityState> emit,
      ) async {
    emit(const SecurityLoading());

    try {
      final hasPin = await repository.hasPin();
      emit(SecurityPinStatusLoaded(hasPin));
    } catch (e) {
      emit(SecurityFailure(_message(e)));
    }
  }

  Future<void> _onChangePin(
      ChangePinRequested event,
      Emitter<SecurityState> emit,
      ) async {
    emit(const SecurityLoading());

    try {
      await repository.changePin(
        currentPin: event.currentPin,
        newPin: event.newPin,
      );

      emit(const SecurityPinChanged());
    } catch (e) {
      emit(SecurityFailure(_message(e)));
    }
  }

  String _message(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }
}
