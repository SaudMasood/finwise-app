import 'package:equatable/equatable.dart';

import '../../../domain/entities/analytics/analytics.dart';


abstract class AnalysisState extends Equatable {
  const AnalysisState();

  @override
  List<Object?> get props => [];
}

class AnalysisInitial extends AnalysisState {}

class AnalysisLoading extends AnalysisState {}

class AnalysisSuccess extends AnalysisState {
  final AnalysisEntity analysis;

  const AnalysisSuccess({
    required this.analysis,
  });

  @override
  List<Object?> get props => [analysis];
}

class AnalysisFailure extends AnalysisState {
  final String message;

  const AnalysisFailure({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}