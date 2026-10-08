import '../../entities/categories/expnse.dart';
import '../../repositories/categories/categories_repository.dart';

class AddExpenseUseCase {
  final CategoryRepository repository;

  AddExpenseUseCase({
    required this.repository,
  });

  Future<void> call({
    required ExpenseEntity expense,
  }) {
    return repository.addExpense(
      expense: expense,
    );
  }
}