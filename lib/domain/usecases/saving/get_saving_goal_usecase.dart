
import '../../repositories/saving/saving_repo.dart';

class GetSavingGoalUseCase {
  final SavingsRepository repository;

  GetSavingGoalUseCase(this.repository);

  Future<double> call(String category) {
    return repository.getGoal(category);
  }
}
