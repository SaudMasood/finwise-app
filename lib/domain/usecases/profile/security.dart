

import '../../repositories/profile/security_repo.dart';

class ChangePinUseCase {
  final SecurityRepository repository;

  ChangePinUseCase({
    required this.repository,
  });

  Future<void> call({
    required String currentPin,
    required String newPin,
  }) {
    return repository.changePin(
      currentPin: currentPin,
      newPin: newPin,
    );
  }
}
