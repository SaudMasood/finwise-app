import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/transactions/transactions.dart';
import '../../../domain/usecases/transactions/get_transactions_usecase.dart';
import 'transactions_event.dart';
import 'transactions_state.dart';

class TransactionBloc
    extends Bloc<TransactionEvent, TransactionState> {
  final GetTransactionsUseCase getTransactionsUseCase;

  List<TransactionEntity> allTransactions = [];

  String? selectedType;
  DateTime? selectedDate;

  TransactionBloc({
    required this.getTransactionsUseCase,
  }) : super(const TransactionInitial()) {
    on<LoadTransactions>(_loadTransactions);
    on<SelectTransactionType>(_selectTransactionType);
    on<SelectTransactionDate>(_selectTransactionDate);
    on<ClearTransactionFilters>(_clearFilters);
  }

  Future<void> _loadTransactions(
      LoadTransactions event,
      Emitter<TransactionState> emit,
      ) async {
    try {
      emit(const TransactionLoading());

      final result = await getTransactionsUseCase();

      allTransactions = result;

      selectedType = null;
      selectedDate = null;

      emit(
        TransactionSuccess(
          allTransactions: allTransactions,
          transactions: allTransactions,
          selectedType: selectedType,
          selectedDate: selectedDate,
        ),
      );
    } catch (e) {
      emit(
        TransactionFailure(
          message: e.toString(),
        ),
      );
    }
  }

  void _selectTransactionType(
      SelectTransactionType event,
      Emitter<TransactionState> emit,
      ) {
    selectedType = event.type;

    _applyFilters(emit);
  }

  void _selectTransactionDate(
      SelectTransactionDate event,
      Emitter<TransactionState> emit,
      ) {
    selectedDate = event.date;

    _applyFilters(emit);
  }

  void _clearFilters(
      ClearTransactionFilters event,
      Emitter<TransactionState> emit,
      ) {
    selectedType = null;
    selectedDate = null;

    emit(
      TransactionSuccess(
        allTransactions: allTransactions,
        transactions: allTransactions,
        selectedType: null,
        selectedDate: null,
      ),
    );
  }

  void _applyFilters(
      Emitter<TransactionState> emit,
      ) {
    List<TransactionEntity> filtered =
    List.from(allTransactions);

    if (selectedType != null) {
      filtered = filtered.where((transaction) {
        return transaction.type.toLowerCase() ==
            selectedType!.toLowerCase();
      }).toList();
    }

    if (selectedDate != null) {
      filtered = filtered.where((transaction) {
        return transaction.date.year ==
            selectedDate!.year &&
            transaction.date.month ==
                selectedDate!.month &&
            transaction.date.day ==
                selectedDate!.day;
      }).toList();
    }

    emit(
      TransactionSuccess(
        allTransactions: allTransactions,
        transactions: filtered,
        selectedType: selectedType,
        selectedDate: selectedDate,
      ),
    );
  }
}