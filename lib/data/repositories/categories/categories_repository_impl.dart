import '../../../domain/entities/categories/expnse.dart';
import '../../../domain/repositories/categories/categories_repository.dart';
import '../../datasources/categoriesdatasorces.dart';
import '../../models/categories/expensemodel.dart';

class CategoryRepositoryImpl
    implements CategoryRepository {
  final CategoryDataSource dataSource;

  CategoryRepositoryImpl({
    required this.dataSource,
  });

  @override
  Stream<List<String>> watchCategories() {
    return dataSource.watchCategories();
  }

  @override
  Stream<List<ExpenseEntity>> watchTransactions({
    String? category,
  }) {
    return dataSource.watchTransactions(
      category: category,
    );
  }

  @override
  Future<void> addCategory({
    required String category,
  }) {
    return dataSource.addCategory(
      category: category,
    );
  }

  @override
  Future<void> addExpense({
    required ExpenseEntity expense,
  }) {
    final model = ExpenseModel(
      id: expense.id,
      category: expense.category,
      title: expense.title,
      amount: expense.amount,
      message: expense.message,
      date: expense.date,
      createdAt: expense.createdAt,
      type: 'expense',
    );

    return dataSource.addExpense(
      expense: model,
    );
  }

  @override
  Future<void> addIncome({
    required ExpenseEntity income,
  }) {
    final model = ExpenseModel(
      id: income.id,
      category: income.category,
      title: income.title,
      amount: income.amount,
      message: income.message,
      date: income.date,
      createdAt: income.createdAt,
      type: 'income',
    );

    return dataSource.addIncome(
      income: model,
    );
  }
}