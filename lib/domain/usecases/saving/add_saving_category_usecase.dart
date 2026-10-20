
import '../../repositories/saving/saving_repo.dart';

class AddSavingCategoryUseCase {
  final SavingsRepository repository;

  AddSavingCategoryUseCase(this.repository);

  Future<void> call({
    required String name,
    double goal = 0,
  }) {
    return repository.addSavingCategory(
      name: name,
      goal: goal,
    );
  }
}
