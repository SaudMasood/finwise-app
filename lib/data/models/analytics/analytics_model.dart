
import '../../../domain/entities/analytics/analytics.dart';

class AnalysisModel extends AnalysisEntity {
  const AnalysisModel({
    required super.totalBalance,
    required super.totalExpense,
    required super.budget,
    required super.expensePercentage,
    required super.revenueLastWeek,
    required super.foodLastWeek,
    required super.transactions,
    required super.chartValues,
  });
}

class AnalysisTransactionModel
    extends AnalysisTransactionEntity {
  const AnalysisTransactionModel({
    required super.title,
    required super.category,
    required super.type,
    required super.amount,
    required super.date,
  });
}