
abstract class SecurityRepository {
  Future<bool> hasPin();

  Future<void> changePin({
    required String currentPin,
    required String newPin,
  });
}
