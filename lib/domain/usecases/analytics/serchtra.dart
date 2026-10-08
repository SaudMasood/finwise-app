
import '../../entities/analytics/serchtrans.dart';
import '../../repositories/analytics/serchtrans.dart';

class SearchTransactionsUseCase {
  final SearchRepository repository;

  SearchTransactionsUseCase({
    required this.repository,
  });

  Future<List<SearchTransactionEntity>> getTransactions() {
    return repository.getTransactions();
  }

  Future<List<String>> getCategories() {
    return repository.getCategories();
  }

  List<SearchTransactionEntity> filterTransactions({
    required List<SearchTransactionEntity> transactions,
    required String searchText,
    required String category,
    required DateTime? date,
    required String type,
  }) {
    final query = searchText.trim().toLowerCase();

    return transactions.where((transaction) {
      final matchesText =
          query.isEmpty ||
              transaction.title.toLowerCase().contains(query) ||
              transaction.category.toLowerCase().contains(query);

      final matchesCategory =
          category.isEmpty ||
              transaction.category.toLowerCase() ==
                  category.toLowerCase();

      final matchesType =
          type.isEmpty ||
              transaction.type.toLowerCase() ==
                  type.toLowerCase();

      final matchesDate =
          date == null ||
              (
                  transaction.date.year == date.year &&
                      transaction.date.month == date.month &&
                      transaction.date.day == date.day
              );

      return matchesText &&
          matchesCategory &&
          matchesType &&
          matchesDate;
    }).toList();
  }
}