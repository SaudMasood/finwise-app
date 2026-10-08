import 'package:finwise/presentation/bloc/analytics/serchtrans_event.dart';
import 'package:finwise/presentation/bloc/analytics/serchtrans_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/analytics/serchtra.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchTransactionsUseCase searchTransactionsUseCase;

  SearchBloc({
    required this.searchTransactionsUseCase,
  }) : super(SearchInitial()) {
    on<LoadSearchData>(_loadSearchData);
    on<PerformSearch>(_performSearch);
  }

  Future<void> _loadSearchData(
      LoadSearchData event,
      Emitter<SearchState> emit,
      ) async {
    emit(SearchLoading());

    try {
      final categories =
      await searchTransactionsUseCase.getCategories();

      emit(
        SearchDataLoaded(
          categories: categories,
        ),
      );
    } catch (e) {
      emit(
        SearchFailure(
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _performSearch(
      PerformSearch event,
      Emitter<SearchState> emit,
      ) async {
    emit(SearchLoading());

    try {
      final transactions =
      await searchTransactionsUseCase.getTransactions();

      final categories =
      await searchTransactionsUseCase.getCategories();

      final results =
      searchTransactionsUseCase.filterTransactions(
        transactions: transactions,
        searchText: event.searchText,
        category: event.category,
        date: event.date,
        type: event.type,
      );

      emit(
        SearchSuccess(
          categories: categories,
          results: results,
        ),
      );
    } catch (e) {
      emit(
        SearchFailure(
          message: e.toString(),
        ),
      );
    }
  }
}