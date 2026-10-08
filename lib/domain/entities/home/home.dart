class HomeEntity {
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final double budget;
  final double revenueLastWeek;
  final double foodLastWeek;
  final List<HomeActivityEntity> activities;

  const HomeEntity({
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.budget,
    required this.revenueLastWeek,
    required this.foodLastWeek,
    required this.activities,
  });
}

class HomeActivityEntity {
  final String id;
  final String title;
  final String category;
  final String type;
  final double amount;
  final DateTime date;

  const HomeActivityEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.type,
    required this.amount,
    required this.date,
  });
}