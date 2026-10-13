
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/datasources/local_notification.dart';
import '../../../domain/entities/categories/expnse.dart';
import '../../../domain/usecases/categories/addcategryusecase.dart';
import '../../../domain/usecases/categories/addexpnseusecse.dart';
import '../../../domain/usecases/categories/addincome.dart';
import '../../../domain/usecases/categories/getcategories_usecase.dart';
import '../../../domain/usecases/categories/getexpenseusecase.dart';
import 'categories_event.dart';
import 'categories_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetExpensesUseCase getExpensesUseCase;
  final AddCategoryUseCase addCategoryUseCase;
  final AddExpenseUseCase addExpenseUseCase;
  final AddIncomeUseCase addIncomeUseCase;
  final FirebaseAuth firebaseAuth;

  StreamSubscription<List<String>>? _categoriesSubscription;
  StreamSubscription<List<ExpenseEntity>>? _transactionsSubscription;

  CategoryBloc({
    required this.getCategoriesUseCase,
    required this.getExpensesUseCase,
    required this.addCategoryUseCase,
    required this.addExpenseUseCase,
    required this.addIncomeUseCase,
    required this.firebaseAuth,
  }) : super(const CategoryState()) {
    on<WatchCategories>(_watchCategories);
    on<WatchAllTransactions>(_watchAllTransactions);
    on<WatchCategoryTransactions>(_watchCategoryTransactions);
    on<CategoriesUpdated>(_categoriesUpdated);
    on<TransactionsUpdated>(_transactionsUpdated);
    on<AddNewCategory>(_addNewCategory);
    on<AddExpense>(_addExpense);
    on<AddIncome>(_addIncome);
  }

  Future<void> _watchCategories(
      WatchCategories event,
      Emitter<CategoryState> emit,
      ) async {
    await _categoriesSubscription?.cancel();

    emit(state.copyWith(
      status: CategoryStatus.loading,
      clearError: true,
    ));

    _categoriesSubscription = getCategoriesUseCase().listen(
          (categories) {
        if (!isClosed) {
          add(CategoriesUpdated(categories: categories));
        }
      },
      onError: (error) {
        if (!isClosed) addError(error);
      },
    );
  }

  Future<void> _watchAllTransactions(
      WatchAllTransactions event,
      Emitter<CategoryState> emit,
      ) async {
    await _transactionsSubscription?.cancel();

    emit(state.copyWith(
      status: CategoryStatus.loading,
      clearError: true,
    ));

    _transactionsSubscription = getExpensesUseCase().listen(
          (transactions) {
        if (!isClosed) {
          add(TransactionsUpdated(transactions: transactions));
        }
      },
      onError: (error) {
        if (!isClosed) addError(error);
      },
    );
  }

  Future<void> _watchCategoryTransactions(
      WatchCategoryTransactions event,
      Emitter<CategoryState> emit,
      ) async {
    await _transactionsSubscription?.cancel();

    emit(state.copyWith(
      status: CategoryStatus.loading,
      clearError: true,
    ));

    _transactionsSubscription = getExpensesUseCase(
      category: event.category,
    ).listen(
          (transactions) {
        if (!isClosed) {
          add(TransactionsUpdated(transactions: transactions));
        }
      },
      onError: (error) {
        if (!isClosed) addError(error);
      },
    );
  }

  void _categoriesUpdated(
      CategoriesUpdated event,
      Emitter<CategoryState> emit,
      ) {
    emit(state.copyWith(
      status: CategoryStatus.loaded,
      categories: event.categories,
      clearError: true,
      clearAction: true,
    ));
  }

  void _transactionsUpdated(
      TransactionsUpdated event,
      Emitter<CategoryState> emit,
      ) {
    double income = 0;
    double expense = 0;

    for (final transaction in event.transactions) {
      if (transaction.type == 'income') {
        income += transaction.amount;
      } else if (transaction.type == 'expense') {
        expense += transaction.amount;
      }
    }

    emit(state.copyWith(
      status: CategoryStatus.loaded,
      transactions: event.transactions,
      totalIncome: income,
      totalExpense: expense,
      totalBalance: income - expense,
      clearError: true,
      clearAction: true,
    ));
  }

  Future<void> _addNewCategory(
      AddNewCategory event,
      Emitter<CategoryState> emit,
      ) async {
    try {
      emit(state.copyWith(
        status: CategoryStatus.saving,
        clearError: true,
      ));

      await addCategoryUseCase(category: event.category);

      emit(state.copyWith(
        status: CategoryStatus.saved,
        savedType: 'category',
        clearError: true,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: CategoryStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _addExpense(
      AddExpense event,
      Emitter<CategoryState> emit,
      ) async {
    try {
      emit(state.copyWith(
        status: CategoryStatus.saving,
        clearError: true,
      ));

      await addExpenseUseCase(expense: event.expense);

      try {
        await LocalNotificationService.instance.addTransactionNotification(
          title: 'Expense Added Successfully',
          message: '${event.expense.title} expense has been added.',
          details:
          '${event.expense.title} - Rs. ${event.expense.amount.toStringAsFixed(2)}',
          type: 'expense',
        );
      } catch (error) {
        debugPrint('Expense notification failed: $error');
      }

      emit(state.copyWith(
        status: CategoryStatus.saved,
        savedType: 'expense',
        clearError: true,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: CategoryStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _addIncome(
      AddIncome event,
      Emitter<CategoryState> emit,
      ) async {
    try {
      emit(state.copyWith(
        status: CategoryStatus.saving,
        clearError: true,
      ));

      await addIncomeUseCase(income: event.income);

      try {
        await LocalNotificationService.instance.addTransactionNotification(
          title: 'Income Added Successfully',
          message: '${event.income.title} income has been added.',
          details:
          '${event.income.title} - Rs. ${event.income.amount.toStringAsFixed(2)}',
          type: 'income',
        );
      } catch (error) {
        debugPrint('Income notification failed: $error');
      }

      emit(state.copyWith(
        status: CategoryStatus.saved,
        savedType: 'income',
        clearError: true,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: CategoryStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  @override
  Future<void> close() async {
    await _categoriesSubscription?.cancel();
    await _transactionsSubscription?.cancel();
    return super.close();
  }
}
