
import '../../repositories/categories/categories_repository.dart';

class AddCategoryUseCase {
  final CategoryRepository repository;

  AddCategoryUseCase({
    required this.repository,
  });

  Future<void> call({
    required String category,
  }) {
    return repository.addCategory(
      category: category,
    );
  }
}