import 'package:equatable/equatable.dart';

import '../../../domain/entities/saving/saving.dart';

enum SavingsStatus {
  initial,
  loading,
  success,
  failure,
}

class SavingsState extends Equatable {
  final SavingsStatus status;
  final List<String> savingCategories;
  final List<SavingEntity> savings;
  final double goal;
  final String? errorMessage;
  final bool savingSuccess;
  final bool categoryAdded;

  const SavingsState({
    this.status = SavingsStatus.initial,
    this.savingCategories = const [],
    this.savings = const [],
    this.goal = 0,
    this.errorMessage,
    this.savingSuccess = false,
    this.categoryAdded = false,
  });

  SavingsState copyWith({
    SavingsStatus? status,
    List<String>? savingCategories,
    List<SavingEntity>? savings,
    double? goal,
    String? errorMessage,
    bool? savingSuccess,
    bool? categoryAdded,
    bool clearErrorMessage = false,
  }) {
    return SavingsState(
      status: status ?? this.status,
      savingCategories: savingCategories ?? this.savingCategories,
      savings: savings ?? this.savings,
      goal: goal ?? this.goal,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      savingSuccess: savingSuccess ?? this.savingSuccess,
      categoryAdded: categoryAdded ?? this.categoryAdded,
    );
  }

  @override
  List<Object?> get props => [
    status,
    savingCategories,
    savings,
    goal,
    errorMessage,
    savingSuccess,
    categoryAdded,
  ];
}