import '../../entities/home/home.dart';
import '../../repositories/home/home_repository.dart';

class GetHomeUseCase {
  final HomeRepository repository;

  GetHomeUseCase({
    required this.repository,
  });

  Stream<List<HomeActivityEntity>>
  watchTransactions() {
    return repository.watchTransactions();
  }

  Stream<double> watchBudget() {
    return repository.watchBudget();
  }
}