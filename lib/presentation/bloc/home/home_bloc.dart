import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/local_notification.dart';
import '../../../domain/entities/home/home.dart';
import '../../../domain/usecases/home/home_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeUseCase getHomeUseCase;

  StreamSubscription? _transactionSubscription;
  StreamSubscription? _budgetSubscription;

  List<HomeActivityEntity> _allTransactions = [];
  double _budget = 0;
  String _selectedPeriod = 'Monthly';

  double? _previousBalance;
  double? _previousExpense;

  bool _weeklyReminderScheduled = false;

  static const double lowBalanceThreshold = 100;
  static const double expenseAlertThreshold = 10000;

  HomeBloc({
    required this.getHomeUseCase,
  }) : super(const HomeInitial()) {
    on<LoadHome>(_loadHome);
    on<HomeTransactionsUpdated>(_transactionsUpdated);
    on<HomeBudgetUpdated>(_budgetUpdated);
    on<SelectHomePeriod>(_selectPeriod);
  }

  Future<void> _loadHome(
      LoadHome event,
      Emitter<HomeState> emit,
      ) async {
    emit(const HomeLoading());

    await _transactionSubscription?.cancel();
    await _budgetSubscription?.cancel();

    try {
      if (!_weeklyReminderScheduled) {
        _weeklyReminderScheduled = true;
        unawaited(_scheduleWeeklyExpenseReminder());
      }

      _transactionSubscription = getHomeUseCase.watchTransactions().listen(
            (transactions) {
          if (!isClosed) {
            add(HomeTransactionsUpdated(transactions));
          }
        },
        onError: (error) {
          if (!isClosed) addError(error);
        },
      );

      _budgetSubscription = getHomeUseCase.watchBudget().listen(
            (budget) {
          if (!isClosed) {
            add(HomeBudgetUpdated(budget));
          }
        },
        onError: (error) {
          if (!isClosed) addError(error);
        },
      );
    } catch (error) {
      emit(HomeFailure(message: error.toString()));
    }
  }

  void _transactionsUpdated(
      HomeTransactionsUpdated event,
      Emitter<HomeState> emit,
      ) {
    _allTransactions = event.transactions.cast<HomeActivityEntity>().toList();
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

  void _emitHome(Emitter<HomeState> emit) {
    final filtered = _filterTransactions(
      _allTransactions,
      _selectedPeriod,
    );

    double totalIncome = 0;
    double totalExpense = 0;

    for (final transaction in _allTransactions) {
      if (transaction.type.toLowerCase() == 'income') {
        totalIncome += transaction.amount;
      } else if (transaction.type.toLowerCase() == 'expense') {
        totalExpense += transaction.amount;
      }
    }

    final totalBalance = totalIncome - totalExpense;

    final previousBalance = _previousBalance;
    final previousExpense = _previousExpense;

    if (previousBalance != null &&
        previousBalance >= lowBalanceThreshold &&
        totalBalance < lowBalanceThreshold) {
      unawaited(_sendLowBalanceNotification(totalBalance));
    }

    if (previousExpense != null &&
        previousExpense < expenseAlertThreshold &&
        totalExpense >= expenseAlertThreshold) {
      unawaited(_sendBudgetNotification(totalExpense));
    }

    _previousBalance = totalBalance;
    _previousExpense = totalExpense;

    double revenueLastWeek = 0;
    double foodLastWeek = 0;

    final sevenDaysAgo = DateTime.now().subtract(
      const Duration(days: 7),
    );

    for (final transaction in _allTransactions) {
      if (transaction.date.isBefore(sevenDaysAgo)) continue;

      if (transaction.type.toLowerCase() == 'income') {
        revenueLastWeek += transaction.amount;
      } else if (transaction.type.toLowerCase() == 'expense' &&
          transaction.category.toLowerCase().contains('food')) {
        foodLastWeek += transaction.amount;
      }
    }

    final home = HomeEntity(
      totalBalance: totalBalance,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      budget: _budget,
      revenueLastWeek: revenueLastWeek,
      foodLastWeek: foodLastWeek,
      activities: filtered,
    );

    emit(
      HomeSuccess(
        home: home,
        selectedPeriod: _selectedPeriod,
      ),
    );
  }

  Future<void> _sendLowBalanceNotification(double balance) async {
    try {
      await LocalNotificationService.instance.addLowBalanceNotification(
        balance: balance,
      );
    } catch (error) {
      debugPrint('Low balance notification failed: $error');
    }
  }

  Future<void> _sendBudgetNotification(double totalExpense) async {
    try {
      await LocalNotificationService.instance.addBudgetNotification(
        title: 'Expense Limit Reached',
        message: 'Your total expenses have reached Rs. 10,000.',
        details:
        'Your recorded expenses are Rs. ${totalExpense.toStringAsFixed(2)}.',
      );
    } catch (error) {
      debugPrint('Budget notification failed: $error');
    }
  }

  Future<void> _scheduleWeeklyExpenseReminder() async {
    try {
      await LocalNotificationService.instance
          .scheduleDefaultWeeklyExpenseReminder();
    } catch (error) {
      debugPrint('Expense reminder scheduling failed: $error');
      _weeklyReminderScheduled = false;
    }
  }

  List<HomeActivityEntity> _filterTransactions(
      List<HomeActivityEntity> transactions,
      String period,
      ) {
    final now = DateTime.now();

    if (period == 'Daily') {
      return transactions.where((transaction) {
        return transaction.date.year == now.year &&
            transaction.date.month == now.month &&
            transaction.date.day == now.day;
      }).toList();
    }

    if (period == 'Weekly') {
      final weekStart = now.subtract(const Duration(days: 7));

      return transactions
          .where((transaction) => transaction.date.isAfter(weekStart))
          .toList();
    }

    if (period == 'Monthly') {
      return transactions.where((transaction) {
        return transaction.date.year == now.year &&
            transaction.date.month == now.month;
      }).toList();
    }

    return transactions;
  }

  @override
  Future<void> close() async {
    await _transactionSubscription?.cancel();
    await _budgetSubscription?.cancel();
    return super.close();
  }
}