abstract class PasswordRepository {
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}