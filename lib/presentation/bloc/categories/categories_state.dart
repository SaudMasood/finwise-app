import 'package:equatable/equatable.dart';

import '../../../domain/entities/categories/expnse.dart';

enum CategoryStatus {
  initial,
  loading,
  loaded,
  saving,
  saved,
  failure,
}

class CategoryState extends Equatable {
  final CategoryStatus status;
  final List<String> categories;
  final List<ExpenseEntity> transactions;

  final double totalIncome;
  final double totalExpense;
  final double totalBalance;

  final String? savedType;
  final String? errorMessage;

  const CategoryState({
    this.status = CategoryStatus.initial,
    this.categories = const [],
    this.transactions = const [],
    this.totalIncome = 0,
    this.totalExpense = 0,
    this.totalBalance = 0,
    this.savedType,
    this.errorMessage,
  });

  CategoryState copyWith({
    CategoryStatus? status,
    List<String>? categories,
    List<ExpenseEntity>? transactions,
    double? totalIncome,
    double? totalExpense,
    double? totalBalance,
    String? savedType,
    String? errorMessage,
    bool clearAction = false,
    bool clearError = false,
  }) {
    return CategoryState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      transactions: transactions ?? this.transactions,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      totalBalance: totalBalance ?? this.totalBalance,
      savedType: clearAction ? null : savedType ?? this.savedType,
      errorMessage:
      clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    categories,
    transactions,
    totalIncome,
    totalExpense,
    totalBalance,
    savedType,
    errorMessage,
  ];
}