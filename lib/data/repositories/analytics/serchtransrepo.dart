import '../../../domain/entities/analytics/serchtrans.dart';
import '../../../domain/repositories/analytics/serchtrans.dart';
import '../../datasources/serchtransctiondatas.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchDataSource dataSource;

  SearchRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<List<SearchTransactionEntity>> getTransactions() {
    return dataSource.getTransactions();
  }

  @override
  Future<List<String>> getCategories() {
    return dataSource.getCategories();
  }
}