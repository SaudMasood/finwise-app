class SearchTransactionEntity {
  final String id;
  final String title;
  final String category;
  final String type;
  final double amount;
  final DateTime date;

  const SearchTransactionEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.type,
    required this.amount,
    required this.date,
  });
}