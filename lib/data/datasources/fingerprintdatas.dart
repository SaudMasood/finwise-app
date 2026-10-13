
import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

class FingerprintBiometricDataSource {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<String> checkBiometrics() async {
    try {
      final supported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      final biometrics = await _auth.getAvailableBiometrics();

      final result = '''
Device supported: $supported
Can check biometrics: $canCheck
Available biometrics: $biometrics
''';

      debugPrint(result);
      return result;
    } catch (e) {
      debugPrint('Biometric check error: $e');
      return 'Biometric check error: $e';
    }
  }


  Future<bool> isAvailable() async {
    try {
      final supported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;

      debugPrint('Device supported: $supported');
      debugPrint('Can check biometrics: $canCheck');

      return supported && canCheck;
    } catch (e) {
      debugPrint('Biometric availability error: $e');
      return false;
    }
  }



  Future<bool> authenticate() async {
    return _auth.authenticate(
      localizedReason: 'Verify your fingerprint to enable FinWise access',
      biometricOnly: true,
    );
  }
}
