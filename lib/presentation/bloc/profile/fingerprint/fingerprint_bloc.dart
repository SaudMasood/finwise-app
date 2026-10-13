
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/repositories/profile/fingerprint.dart';
import 'fingerprint_event.dart';
import 'fingerprint_state.dart';

class FingerprintBloc extends Bloc<FingerprintEvent, FingerprintState> {
  final FingerprintRepository repository;

  FingerprintBloc(this.repository) : super(FingerprintInitial()) {
    on<LoadFingerprint>(_loadFingerprint);
    on<EnableFingerprint>(_enableFingerprint);
    on<DisableFingerprint>(_disableFingerprint);
  }

  Future<void> _loadFingerprint(
      LoadFingerprint event,
      Emitter<FingerprintState> emit,
      ) async {
    emit(FingerprintLoading());

    try {
      final enabled = await repository.isEnabled();
      final available = await repository.isAvailable();
      final label = await repository.getLabel();

      emit(
        FingerprintLoaded(
          enabled: enabled,
          available: available,
          label: label,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('Load fingerprint error: $e');
      debugPrintStack(stackTrace: stackTrace);

      emit(
        FingerprintFailure(
          'Unable to load fingerprint settings: $e',
        ),
      );
    }
  }

  Future<void> _enableFingerprint(
      EnableFingerprint event,
      Emitter<FingerprintState> emit,
      ) async {
    emit(FingerprintLoading());

    try {
      final available = await repository.isAvailable();

      if (!available) {
        emit(
          FingerprintFailure(
            'Biometric authentication is unavailable. Check device settings.',
          ),
        );
        return;
      }

      final authenticated = await repository.authenticate();

      if (!authenticated) {
        emit(
          FingerprintFailure(
            'Fingerprint authentication was cancelled or unsuccessful.',
          ),
        );
        return;
      }

      await repository.enable();
      emit(FingerprintSuccess());
    } catch (e, stackTrace) {
      debugPrint('Enable fingerprint error: $e');
      debugPrintStack(stackTrace: stackTrace);

      emit(
        FingerprintFailure(
          'Fingerprint authentication error: $e',
        ),
      );
    }
  }

  Future<void> _disableFingerprint(
      DisableFingerprint event,
      Emitter<FingerprintState> emit,
      ) async {
    emit(FingerprintLoading());

    try {
      await repository.disable();
      emit(FingerprintSuccess());
    } catch (e, stackTrace) {
      debugPrint('Disable fingerprint error: $e');
      debugPrintStack(stackTrace: stackTrace);

      emit(
        FingerprintFailure(
          'Unable to disable fingerprint: $e',
        ),
      );
    }
  }
}
