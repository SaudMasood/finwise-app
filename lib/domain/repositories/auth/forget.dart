abstract class ForgotPasswordRepository {
  Future<void> sendPasswordResetEmail({
    required String email,
  });
}