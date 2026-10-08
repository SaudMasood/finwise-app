
import '../../repositories/saving/saving_repo.dart';

class GetSavingsCategoriesUseCase {
  final SavingsRepository repository;

  GetSavingsCategoriesUseCase({
    required this.repository,
  });

  Stream<List<String>> call() {
    return repository.watchSavingCategories();
  }
}