
import '../../../domain/repositories/profile/fingerprint.dart';
import '../../datasources/fingerprint_local_datasorce.dart';
import '../../datasources/fingerprintdatas.dart';

class FingerprintRepositoryImpl implements FingerprintRepository {
  final FingerprintBiometricDataSource biometricDataSource;
  final FingerprintLocalDataSource localDataSource;

  FingerprintRepositoryImpl({
    required this.biometricDataSource,
    required this.localDataSource,
  });

  @override
  Future<bool> isAvailable() {
    return biometricDataSource.isAvailable();
  }

  @override
  Future<bool> authenticate() {
    return biometricDataSource.authenticate();
  }

  @override
  Future<bool> isEnabled() {
    return localDataSource.isEnabled();
  }

  @override
  Future<String?> getLabel() {
    return localDataSource.getLabel();
  }

  @override
  Future<void> enable() {
    return localDataSource.enable();
  }

  @override
  Future<void> disable() {
    return localDataSource.disable();
  }
}
