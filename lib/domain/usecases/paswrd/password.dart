
import '../../repositories/password/password.dart';

class ChangePasswordUseCase {
  final PasswordRepository repository;

  ChangePasswordUseCase({
    required this.repository,
  });

  Future<void> call({
    required String currentPassword,
    required String newPassword,
  }) {
    return repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}