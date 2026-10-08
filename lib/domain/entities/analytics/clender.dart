class CalendarTransactionEntity {
  final String id;
  final String title;
  final String category;
  final String type;
  final double amount;
  final String message;
  final DateTime date;

  const CalendarTransactionEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.type,
    required this.amount,
    required this.message,
    required this.date,
  });
}