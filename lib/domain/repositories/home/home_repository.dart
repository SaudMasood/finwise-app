import '../../entities/home/home.dart';

abstract class HomeRepository {
  Stream<List<HomeActivityEntity>>
  watchTransactions();

  Stream<double> watchBudget();
}