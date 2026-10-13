
import 'package:shared_preferences/shared_preferences.dart';

class FingerprintLocalDataSource {
  static const String _enabledKey = 'fingerprint_enabled';
  static const String _labelKey = 'fingerprint_label';

  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_enabledKey) ?? false;
  }

  Future<String?> getLabel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_labelKey);
  }

  Future<void> enable() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_enabledKey, true);
    await prefs.setString(_labelKey, 'Fingerprint');
  }

  Future<void> disable() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_enabledKey, false);
    await prefs.remove(_labelKey);
  }
}
