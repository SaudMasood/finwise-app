import '../../entities/transactions/transactions.dart';

abstract class TransactionRepository {
  Future<List<TransactionEntity>> getTransactions();
}