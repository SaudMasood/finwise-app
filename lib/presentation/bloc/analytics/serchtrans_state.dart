import 'package:equatable/equatable.dart';

import '../../../domain/entities/analytics/serchtrans.dart';


abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchDataLoaded extends SearchState {
  final List<String> categories;

  const SearchDataLoaded({
    required this.categories,
  });

  @override
  List<Object?> get props => [categories];
}

class SearchSuccess extends SearchState {
  final List<String> categories;
  final List<SearchTransactionEntity> results;

  const SearchSuccess({
    required this.categories,
    required this.results,
  });

  @override
  List<Object?> get props => [
    categories,
    results,
  ];
}

class SearchFailure extends SearchState {
  final String message;

  const SearchFailure({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}