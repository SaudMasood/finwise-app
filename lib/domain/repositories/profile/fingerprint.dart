
abstract class FingerprintRepository {
  Future<bool> isAvailable();
  Future<bool> authenticate();
  Future<bool> isEnabled();
  Future<String?> getLabel();
  Future<void> enable();
  Future<void> disable();
}
