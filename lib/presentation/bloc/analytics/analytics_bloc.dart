import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/analytics/analytics_usecase.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalysisBloc
    extends Bloc<AnalysisEvent, AnalysisState> {
  final GetAnalysisUseCase getAnalysisUseCase;

  AnalysisBloc({
    required this.getAnalysisUseCase,
  }) : super(AnalysisInitial()) {
    on<LoadAnalysis>(_loadAnalysis);
  }

  Future<void> _loadAnalysis(
      LoadAnalysis event,
      Emitter<AnalysisState> emit,
      ) async {
    emit(AnalysisLoading());

    try {
      final analysis =
      await getAnalysisUseCase();

      emit(
        AnalysisSuccess(
          analysis: analysis,
        ),
      );
    } catch (e) {
      emit(
        AnalysisFailure(
          message: e.toString(),
        ),
      );
    }
  }
}