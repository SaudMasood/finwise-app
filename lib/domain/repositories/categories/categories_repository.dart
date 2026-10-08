import '../../entities/categories/expnse.dart';

abstract class CategoryRepository {
  Stream<List<String>> watchCategories();

  Stream<List<ExpenseEntity>> watchTransactions({
    String? category,
  });

  Future<void> addCategory({
    required String category,
  });

  Future<void> addExpense({
    required ExpenseEntity expense,
  });

  Future<void> addIncome({
    required ExpenseEntity income,
  });
}