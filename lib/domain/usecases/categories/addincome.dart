import '../../entities/categories/expnse.dart';
import '../../repositories/categories/categories_repository.dart';

class AddIncomeUseCase {
  final CategoryRepository repository;

  AddIncomeUseCase({
    required this.repository,
  });

  Future<void> call({
    required ExpenseEntity income,
  }) {
    return repository.addIncome(
      income: income,
    );
  }
}