
import '../../entities/analytics/serchtrans.dart';

abstract class SearchRepository {
  Future<List<SearchTransactionEntity>> getTransactions();

  Future<List<String>> getCategories();
}