import 'package:equatable/equatable.dart';

import '../../../domain/entities/saving/saving.dart';

abstract class SavingsEvent extends Equatable {
  const SavingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSavingsCategories extends SavingsEvent {
  const LoadSavingsCategories();
}

class SavingCategoriesUpdated extends SavingsEvent {
  final List<String> categories;

  const SavingCategoriesUpdated(this.categories);

  @override
  List<Object?> get props => [categories];
}

class AddSavingCategory extends SavingsEvent {
  final String name;
  final double goal;

  const AddSavingCategory({
    required this.name,
    this.goal = 0,
  });

  @override
  List<Object?> get props => [name, goal];
}

class LoadSavings extends SavingsEvent {
  final String category;

  const LoadSavings({required this.category});

  @override
  List<Object?> get props => [category];
}

class SavingsUpdated extends SavingsEvent {
  final List<SavingEntity> savings;

  const SavingsUpdated(this.savings);

  @override
  List<Object?> get props => [savings];
}

class LoadSavingGoal extends SavingsEvent {
  final String category;

  const LoadSavingGoal({required this.category});

  @override
  List<Object?> get props => [category];
}

class AddSaving extends SavingsEvent {
  final SavingEntity saving;

  const AddSaving({required this.saving});

  @override
  List<Object?> get props => [saving];
}

class ClearSavingFeedback extends SavingsEvent {
  const ClearSavingFeedback();
}

class InternalSavingsError extends SavingsEvent {
  final String message;

  const InternalSavingsError(this.message);

  @override
  List<Object?> get props => [message];
}