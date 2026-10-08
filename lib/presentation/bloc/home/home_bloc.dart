import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/home/home.dart';
import '../../../domain/usecases/home/home_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc
    extends Bloc<HomeEvent, HomeState> {
  final GetHomeUseCase getHomeUseCase;

  StreamSubscription?
  _transactionSubscription;

  StreamSubscription?
  _budgetSubscription;

  List<HomeActivityEntity>
  _allTransactions = [];

  double _budget = 0;

  String _selectedPeriod = 'Monthly';

  HomeBloc({
    required this.getHomeUseCase,
  }) : super(
    const HomeInitial(),
  ) {
    on<LoadHome>(
      _loadHome,
    );

    on<HomeTransactionsUpdated>(
      _transactionsUpdated,
    );

    on<HomeBudgetUpdated>(
      _budgetUpdated,
    );

    on<SelectHomePeriod>(
      _selectPeriod,
    );
  }

  Future<void> _loadHome(
      LoadHome event,
      Emitter<HomeState> emit,
      ) async {
    emit(
      const HomeLoading(),
    );

    await _transactionSubscription
        ?.cancel();

    await _budgetSubscription?.cancel();

    try {
      _transactionSubscription =
          getHomeUseCase
              .watchTransactions()
              .listen(
                (transactions) {
              add(
                HomeTransactionsUpdated(
                  transactions,
                ),
              );
            },
            onError: (error) {
              addError(error);
            },
          );

      _budgetSubscription =
          getHomeUseCase
              .watchBudget()
              .listen(
                (budget) {
              add(
                HomeBudgetUpdated(
                  budget,
                ),
              );
            },
            onError: (error) {
              addError(error);
            },
          );
    } catch (e) {
      emit(
        HomeFailure(
          message: e.toString(),
        ),
      );
    }
  }

  void _transactionsUpdated(
      HomeTransactionsUpdated event,
      Emitter<HomeState> emit,
      ) {
    _allTransactions =
        event.transactions
            .cast<HomeActivityEntity>()
            .toList();

    _emitHome(emit);
  }

  void _budgetUpdated(
      HomeBudgetUpdated event,
      Emitter<HomeState> emit,
      ) {
    _budget = event.budget;

    _emitHome(emit);
  }

  void _selectPeriod(
      SelectHomePeriod event,
      Emitter<HomeState> emit,
      ) {
    _selectedPeriod = event.period;

    _emitHome(emit);
  }

  void _emitHome(
      Emitter<HomeState> emit,
      ) {
    final filtered =
    _filterTransactions(
      _allTransactions,
      _selectedPeriod,
    );

    double totalIncome = 0;
    double totalExpense = 0;

    for (final transaction
    in _allTransactions) {
      if (transaction.type
          .toLowerCase() ==
          'income') {
        totalIncome +=
            transaction.amount;
      } else if (transaction.type
          .toLowerCase() ==
          'expense') {
        totalExpense +=
            transaction.amount;
      }
    }

    final totalBalance =
        totalIncome - totalExpense;

    double revenueLastWeek = 0;
    double foodLastWeek = 0;

    final now = DateTime.now();

    final sevenDaysAgo = now.subtract(
      const Duration(days: 7),
    );

    for (final transaction
    in _allTransactions) {
      if (transaction.date
          .isBefore(sevenDaysAgo)) {
        continue;
      }

      if (transaction.type
          .toLowerCase() ==
          'income') {
        revenueLastWeek +=
            transaction.amount;
      }

      if (transaction.type
          .toLowerCase() ==
          'expense') {
        if (transaction.category
            .toLowerCase()
            .contains('food')) {
          foodLastWeek +=
              transaction.amount;
        }
      }
    }

    final home = HomeEntity(
      totalBalance: totalBalance,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      budget: _budget,
      revenueLastWeek:
      revenueLastWeek,
      foodLastWeek: foodLastWeek,
      activities: filtered,
    );

    emit(
      HomeSuccess(
        home: home,
        selectedPeriod:
        _selectedPeriod,
      ),
    );
  }

  List<HomeActivityEntity>
  _filterTransactions(
      List<HomeActivityEntity>
      transactions,
      String period,
      ) {
    final now = DateTime.now();

    if (period == 'Daily') {
      return transactions.where(
            (transaction) {
          return transaction.date.year ==
              now.year &&
              transaction.date.month ==
                  now.month &&
              transaction.date.day ==
                  now.day;
        },
      ).toList();
    }

    if (period == 'Weekly') {
      final weekStart = now.subtract(
        const Duration(days: 7),
      );

      return transactions.where(
            (transaction) {
          return transaction.date
              .isAfter(weekStart);
        },
      ).toList();
    }

    if (period == 'Monthly') {
      return transactions.where(
            (transaction) {
          return transaction.date.year ==
              now.year &&
              transaction.date.month ==
                  now.month;
        },
      ).toList();
    }

    return transactions;
  }

  @override
  Future<void> close() async {
    await _transactionSubscription
        ?.cancel();

    await _budgetSubscription?.cancel();

    return super.close();
  }
}