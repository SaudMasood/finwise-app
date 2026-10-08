
import '../../repositories/categories/categories_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository repository;

  GetCategoriesUseCase({
    required this.repository,
  });

  Stream<List<String>> call() {
    return repository.watchCategories();
  }
}