import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/saving/saving.dart';
import '../../../domain/usecases/saving/add_saving_category_usecase.dart';
import '../../../domain/usecases/saving/add_saving_usecase.dart';
import '../../../domain/usecases/saving/get _saving_usecas.dart';
import '../../../domain/usecases/saving/get_saving_goal_usecase.dart';
import '../../../domain/usecases/saving/get_savings_categories_usecase.dart';
import 'saving_event.dart';
import 'saving_state.dart';

class SavingsBloc extends Bloc<SavingsEvent, SavingsState> {
  final GetSavingsUseCase getSavingsUseCase;
  final GetSavingsCategoriesUseCase getSavingsCategoriesUseCase;
  final GetSavingGoalUseCase getSavingGoalUseCase;
  final AddSavingUseCase addSavingUseCase;
  final AddSavingCategoryUseCase addSavingCategoryUseCase;

  StreamSubscription<List<String>>? _categoriesSubscription;
  StreamSubscription<List<SavingEntity>>? _savingsSubscription;

  String? _activeCategory;

  SavingsBloc({
    required this.getSavingsUseCase,
    required this.getSavingsCategoriesUseCase,
    required this.getSavingGoalUseCase,
    required this.addSavingUseCase,
    required this.addSavingCategoryUseCase,
  }) : super(const SavingsState()) {
    on<LoadSavingsCategories>(_onLoadCategories);
    on<SavingCategoriesUpdated>(_onCategoriesUpdated);
    on<AddSavingCategory>(_onAddCategory);
    on<LoadSavings>(_onLoadSavings);
    on<SavingsUpdated>(_onSavingsUpdated);
    on<LoadSavingGoal>(_onLoadGoal);
    on<AddSaving>(_onAddSaving);
    on<ClearSavingFeedback>(_onClearFeedback);
    on<InternalSavingsError>(_onError);
  }

  Future<void> _onLoadCategories(
      LoadSavingsCategories event,
      Emitter<SavingsState> emit,
      ) async {
    emit(state.copyWith(
      status: SavingsStatus.loading,
      clearErrorMessage: true,
    ));

    try {
      await _categoriesSubscription?.cancel();

      _categoriesSubscription =
          getSavingsCategoriesUseCase().listen(
                (categories) {
              add(SavingCategoriesUpdated(categories));
            },
            onError: (Object error) {
              add(InternalSavingsError(error.toString()));
            },
          );
    } catch (error) {
      emit(state.copyWith(
        status: SavingsStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  void _onCategoriesUpdated(
      SavingCategoriesUpdated event,
      Emitter<SavingsState> emit,
      ) {
    emit(state.copyWith(
      status: SavingsStatus.success,
      savingCategories: event.categories,
      categoryAdded: false,
      clearErrorMessage: true,
    ));
  }

  Future<void> _onAddCategory(
      AddSavingCategory event,
      Emitter<SavingsState> emit,
      ) async {
    try {
      await addSavingCategoryUseCase(
        name: event.name,
        goal: event.goal,
      );

      emit(state.copyWith(
        status: SavingsStatus.success,
        categoryAdded: true,
        clearErrorMessage: true,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: SavingsStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onLoadSavings(
      LoadSavings event,
      Emitter<SavingsState> emit,
      ) async {
    _activeCategory = event.category;

    emit(state.copyWith(
      status: SavingsStatus.loading,
      savings: const [],
      clearErrorMessage: true,
    ));

    try {
      await _savingsSubscription?.cancel();

      _savingsSubscription = getSavingsUseCase(event.category).listen(
            (savings) {
          add(SavingsUpdated(savings));
        },
        onError: (Object error) {
          add(InternalSavingsError(error.toString()));
        },
      );
    } catch (error) {
      emit(state.copyWith(
        status: SavingsStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  void _onSavingsUpdated(
      SavingsUpdated event,
      Emitter<SavingsState> emit,
      ) {
    emit(state.copyWith(
      status: SavingsStatus.success,
      savings: event.savings,
      clearErrorMessage: true,
    ));
  }

  Future<void> _onLoadGoal(
      LoadSavingGoal event,
      Emitter<SavingsState> emit,
      ) async {
    try {
      final goal = await getSavingGoalUseCase(event.category);

      // Prevent an older category request from changing the current goal.
      if (_activeCategory != null &&
          _activeCategory != event.category) {
        return;
      }

      emit(state.copyWith(
        goal: goal,
        clearErrorMessage: true,
      ));
    } catch (error) {
      emit(state.copyWith(
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onAddSaving(
      AddSaving event,
      Emitter<SavingsState> emit,
      ) async {
    try {
      await addSavingUseCase(event.saving);

      emit(state.copyWith(
        status: SavingsStatus.success,
        savingSuccess: true,
        clearErrorMessage: true,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: SavingsStatus.failure,
        savingSuccess: false,
        errorMessage: error.toString(),
      ));
    }
  }

  void _onClearFeedback(
      ClearSavingFeedback event,
      Emitter<SavingsState> emit,
      ) {
    emit(state.copyWith(
      savingSuccess: false,
      categoryAdded: false,
      clearErrorMessage: true,
    ));
  }

  void _onError(
      InternalSavingsError event,
      Emitter<SavingsState> emit,
      ) {
    emit(state.copyWith(
      status: SavingsStatus.failure,
      errorMessage: event.message,
    ));
  }

  @override
  Future<void> close() async {
    await _categoriesSubscription?.cancel();
    await _savingsSubscription?.cancel();
    return super.close();
  }
}