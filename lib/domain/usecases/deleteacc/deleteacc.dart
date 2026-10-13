
import '../../repositories/deleteaccount/deleteaccount_repo.dart';

class DeleteAccountUseCase {
  final DeleteAccountRepository repository;

  DeleteAccountUseCase({
    required this.repository,
  });

  Future<void> call({
    required String password,
  }) {
    return repository.deleteAccount(
      password: password,
    );
  }
}