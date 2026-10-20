
import '../../entities/saving/saving.dart';
import '../../repositories/saving/saving_repo.dart';

class AddSavingUseCase {
  final SavingsRepository repository;

  AddSavingUseCase(this.repository);

  Future<void> call(SavingEntity saving) {
    return repository.addSaving(saving);
  }
}
