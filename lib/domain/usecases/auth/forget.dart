import '../../repositories/auth/forget.dart';

class ForgotPasswordUseCase {
  final ForgotPasswordRepository repository;

  ForgotPasswordUseCase({
    required this.repository,
  });

  Future<void> call({
    required String email,
  }) {
    return repository.sendPasswordResetEmail(
      email: email,
    );
  }
}