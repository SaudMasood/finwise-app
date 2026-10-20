
import '../../entities/saving/saving.dart';
import '../../repositories/saving/saving_repo.dart';

class GetSavingsUseCase {
  final SavingsRepository repository;

  GetSavingsUseCase(this.repository);

  Stream<List<SavingEntity>> call(String category) {
    return repository.watchSavings(category);
  }
}
