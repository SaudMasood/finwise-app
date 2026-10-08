class AnalysisEntity {
  final double totalBalance;
  final double totalExpense;
  final double budget;
  final double expensePercentage;
  final double revenueLastWeek;
  final double foodLastWeek;
  final List<AnalysisTransactionEntity> transactions;
  final List<double> chartValues;

  const AnalysisEntity({
    required this.totalBalance,
    required this.totalExpense,
    required this.budget,
    required this.expensePercentage,
    required this.revenueLastWeek,
    required this.foodLastWeek,
    required this.transactions,
    required this.chartValues,
  });
}

class AnalysisTransactionEntity {
  final String title;
  final String category;
  final String type;
  final double amount;
  final DateTime date;

  const AnalysisTransactionEntity({
    required this.title,
    required this.category,
    required this.type,
    required this.amount,
    required this.date,
  });
}