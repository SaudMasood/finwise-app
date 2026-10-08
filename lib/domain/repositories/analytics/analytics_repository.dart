
import '../../entities/analytics/analytics.dart';

abstract class AnalysisRepository {
  Future<AnalysisEntity> getAnalysis();
}