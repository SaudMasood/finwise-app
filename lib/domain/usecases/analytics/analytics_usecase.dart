
import '../../entities/analytics/analytics.dart';
import '../../repositories/analytics/analytics_repository.dart';

class GetAnalysisUseCase {
  final AnalysisRepository repository;

  GetAnalysisUseCase({
    required this.repository,
  });

  Future<AnalysisEntity> call() {
    return repository.getAnalysis();
  }
}