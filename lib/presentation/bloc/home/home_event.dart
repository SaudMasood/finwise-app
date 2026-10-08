import 'package:equatable/equatable.dart';

abstract class HomeEvent
    extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHome extends HomeEvent {
  const LoadHome();
}

class SelectHomePeriod extends HomeEvent {
  final String period;

  const SelectHomePeriod({
    required this.period,
  });

  @override
  List<Object?> get props => [
    period,
  ];
}

class HomeTransactionsUpdated
    extends HomeEvent {
  final List<dynamic> transactions;

  const HomeTransactionsUpdated(
      this.transactions,
      );

  @override
  List<Object?> get props => [
    transactions,
  ];
}

class HomeBudgetUpdated
    extends HomeEvent {
  final double budget;

  const HomeBudgetUpdated(
      this.budget,
      );

  @override
  List<Object?> get props => [
    budget,
  ];
}