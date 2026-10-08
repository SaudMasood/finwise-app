import '../../../domain/entities/analytics/analytics.dart';
import '../../../domain/repositories/analytics/analytics_repository.dart';
import '../../datasources/analysisdatasource.dart';

class AnalysisRepositoryImpl
    implements AnalysisRepository {
  final AnalysisDataSource dataSource;

  AnalysisRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<AnalysisEntity> getAnalysis() {
    return dataSource.getAnalysis();
  }
}