import '../../entities/transactions/transactions.dart';
import '../../repositories/transactions/transactions_repository.dart';

class GetTransactionsUseCase {
  final TransactionRepository repository;

  GetTransactionsUseCase({
    required this.repository,
  });

  Future<List<TransactionEntity>> call() {
    return repository.getTransactions();
  }
}