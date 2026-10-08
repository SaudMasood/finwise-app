import '../../../domain/entities/home/home.dart';
import '../../../domain/repositories/home/home_repository.dart';
import '../../datasources/homedatasource.dart';

class HomeRepositoryImpl
    implements HomeRepository {
  final HomeDataSource dataSource;

  HomeRepositoryImpl({
    required this.dataSource,
  });

  @override
  Stream<List<HomeActivityEntity>>
  watchTransactions() {
    return dataSource.watchTransactions();
  }

  @override
  Stream<double> watchBudget() {
    return dataSource.watchBudget();
  }
}