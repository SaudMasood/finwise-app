import 'package:equatable/equatable.dart';

import '../../../domain/entities/categories/expnse.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class WatchCategories extends CategoryEvent {
  const WatchCategories();
}

class WatchAllTransactions extends CategoryEvent {
  const WatchAllTransactions();
}

class WatchCategoryTransactions extends CategoryEvent {
  final String category;

  const WatchCategoryTransactions({
    required this.category,
  });

  @override
  List<Object> get props => [category];
}

class CategoriesUpdated extends CategoryEvent {
  final List<String> categories;

  const CategoriesUpdated({
    required this.categories,
  });

  @override
  List<Object> get props => [categories];
}

class TransactionsUpdated extends CategoryEvent {
  final List<ExpenseEntity> transactions;

  const TransactionsUpdated({
    required this.transactions,
  });

  @override
  List<Object> get props => [transactions];
}

class AddNewCategory extends CategoryEvent {
  final String category;

  const AddNewCategory({
    required this.category,
  });

  @override
  List<Object> get props => [category];
}

class AddExpense extends CategoryEvent {
  final ExpenseEntity expense;

  const AddExpense({
    required this.expense,
  });

  @override
  List<Object> get props => [expense];
}

class AddIncome extends CategoryEvent {
  final ExpenseEntity income;

  const AddIncome({
    required this.income,
  });

  @override
  List<Object> get props => [income];
}