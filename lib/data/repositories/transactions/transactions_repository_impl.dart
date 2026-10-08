import '../../../domain/entities/transactions/transactions.dart';
import '../../../domain/repositories/transactions/transactions_repository.dart';
import '../../datasources/transctiondatasorce.dart';

class TransactionRepositoryImpl
    implements TransactionRepository {
  final TransactionDataSource dataSource;

  TransactionRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<List<TransactionEntity>> getTransactions() {
    return dataSource.getTransactions();
  }
}