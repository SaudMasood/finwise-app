import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/analytics/get_clender_tran.dart';
import 'clender_event.dart';
import 'clender_state.dart';

class CalendarBloc
    extends Bloc<CalendarEvent, CalendarState> {
  final GetCalendarTransactionsUseCase
  getCalendarTransactionsUseCase;

  CalendarBloc({
    required this.getCalendarTransactionsUseCase,
  }) : super(
    CalendarState(
      selectedDate: DateTime.now(),
    ),
  ) {
    on<SelectCalendarDate>(
      _onSelectCalendarDate,
    );
  }

  Future<void> _onSelectCalendarDate(
      SelectCalendarDate event,
      Emitter<CalendarState> emit,
      ) async {
    emit(
      state.copyWith(
        status: CalendarStatus.loading,
        selectedDate: event.date,
        errorMessage: null,
      ),
    );

    try {
      final transactions =
      await getCalendarTransactionsUseCase(
        event.date,
      );

      emit(
        state.copyWith(
          status: CalendarStatus.success,
          selectedDate: event.date,
          transactions: transactions,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CalendarStatus.failure,
          selectedDate: event.date,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}