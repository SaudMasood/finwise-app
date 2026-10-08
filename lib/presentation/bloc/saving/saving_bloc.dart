import 'dart:async';

import 'package:finwise/presentation/bloc/saving/saving_event.dart';
import 'package:finwise/presentation/bloc/saving/saving_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/saving/add_saving_category_usecase.dart';
import '../../../domain/usecases/saving/add_saving_usecase.dart';
import '../../../domain/usecases/saving/get _saving_usecas.dart';
import '../../../domain/usecases/saving/get_saving_goal_usecase.dart';
import '../../../domain/usecases/saving/get_savings_categories_usecase.dart';


class SavingsBloc
    extends Bloc<SavingsEvent, SavingsState> {
  final GetSavingsUseCase getSavingsUseCase;
  final GetSavingsCategoriesUseCase
  getSavingsCategoriesUseCase;
  final GetSavingGoalUseCase
  getSavingGoalUseCase;
  final AddSavingUseCase addSavingUseCase;
  final AddSavingCategoryUseCase
  addSavingCategoryUseCase;

  StreamSubscription? _savingsSubscription;
  StreamSubscription? _categoriesSubscription;

  SavingsBloc({
    required this.getSavingsUseCase,
    required this.getSavingsCategoriesUseCase,
    required this.getSavingGoalUseCase,
    required this.addSavingUseCase,
    required this.addSavingCategoryUseCase,
  }) : super(const SavingsState()) {
    on<LoadSavingsCategories>(
      _onLoadSavingsCategories,
    );

    on<SavingCategoriesUpdated>(
      _onSavingCategoriesUpdated,
    );

    on<AddSavingCategory>(
      _onAddSavingCategory,
    );

    on<LoadSavings>(
      _onLoadSavings,
    );

    on<SavingsUpdated>(
      _onSavingsUpdated,
    );

    on<LoadSavingGoal>(
      _onLoadSavingGoal,
    );

    on<AddSaving>(
      _onAddSaving,
    );
  }

  Future<void> _onLoadSavingsCategories(
      LoadSavingsCategories event,
      Emitter<SavingsState> emit,
      ) async {
    emit(
      state.copyWith(
        status: SavingsStatus.loading,
      ),
    );

    await _categoriesSubscription?.cancel();

    try {
      _categoriesSubscription =
          getSavingsCategoriesUseCase().listen(
                (categories) {
              add(
                SavingCategoriesUpdated(
                  categories: categories,
                ),
              );
            },
          );
    } catch (e) {
      emit(
        state.copyWith(
          status: SavingsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onSavingCategoriesUpdated(
      SavingCategoriesUpdated event,
      Emitter<SavingsState> emit,
      ) {
    emit(
      state.copyWith(
        status: SavingsStatus.success,
        savingCategories: event.categories,
      ),
    );
  }

  Future<void> _onAddSavingCategory(
      AddSavingCategory event,
      Emitter<SavingsState> emit,
      ) async {
    try {
      final name = event.name.trim();

      if (name.isEmpty) {
        return;
      }

      final alreadyExists =
      state.savingCategories.any(
            (category) =>
        category.toLowerCase() ==
            name.toLowerCase(),
      );

      if (alreadyExists) {
        emit(
          state.copyWith(
            errorMessage:
            'Saving category already exists',
            categoryAdded: false,
          ),
        );

        return;
      }

      await addSavingCategoryUseCase(
        name: name,
        goal: event.goal,
      );

      emit(
        state.copyWith(
          categoryAdded: true,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          categoryAdded: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadSavings(
      LoadSavings event,
      Emitter<SavingsState> emit,
      ) async {
    emit(
      state.copyWith(
        status: SavingsStatus.loading,
        savingSuccess: false,
      ),
    );

    await _savingsSubscription?.cancel();

    try {
      final goal = await getSavingGoalUseCase(
        event.category,
      );

      emit(
        state.copyWith(
          goal: goal,
          status: SavingsStatus.success,
        ),
      );

      _savingsSubscription =
          getSavingsUseCase(event.category).listen(
                (savings) {
              add(
                SavingsUpdated(
                  savings: savings,
                ),
              );
            },
          );
    } catch (e) {
      emit(
        state.copyWith(
          status: SavingsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onSavingsUpdated(
      SavingsUpdated event,
      Emitter<SavingsState> emit,
      ) {
    emit(
      state.copyWith(
        status: SavingsStatus.success,
        savings: event.savings,
      ),
    );
  }

  Future<void> _onLoadSavingGoal(
      LoadSavingGoal event,
      Emitter<SavingsState> emit,
      ) async {
    try {
      final goal = await getSavingGoalUseCase(
        event.category,
      );

      emit(
        state.copyWith(
          goal: goal,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onAddSaving(
      AddSaving event,
      Emitter<SavingsState> emit,
      ) async {
    try {
      await addSavingUseCase(
        event.saving,
      );

      emit(
        state.copyWith(
          savingSuccess: true,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          savingSuccess: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await _savingsSubscription?.cancel();
    await _categoriesSubscription?.cancel();

    return super.close();
  }
}