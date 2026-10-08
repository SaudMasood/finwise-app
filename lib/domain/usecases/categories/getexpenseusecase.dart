import '../../entities/categories/expnse.dart';
import '../../repositories/categories/categories_repository.dart';

class GetExpensesUseCase {
  final CategoryRepository repository;

  GetExpensesUseCase({
    required this.repository,
  });

  Stream<List<ExpenseEntity>> call({
    String? category,
  }) {
    return repository.watchTransactions(
      category: category,
    );
  }
}