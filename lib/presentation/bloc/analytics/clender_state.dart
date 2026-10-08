import 'package:equatable/equatable.dart';

import '../../../domain/entities/analytics/clender.dart';


enum CalendarStatus {
  initial,
  loading,
  success,
  failure,
}

class CalendarState extends Equatable {
  final CalendarStatus status;
  final DateTime selectedDate;
  final List<CalendarTransactionEntity>
  transactions;
  final String? errorMessage;

  const CalendarState({
    this.status = CalendarStatus.initial,
    required this.selectedDate,
    this.transactions = const [],
    this.errorMessage,
  });

  CalendarState copyWith({
    CalendarStatus? status,
    DateTime? selectedDate,
    List<CalendarTransactionEntity>?
    transactions,
    String? errorMessage,
  }) {
    return CalendarState(
      status: status ?? this.status,
      selectedDate:
      selectedDate ?? this.selectedDate,
      transactions:
      transactions ?? this.transactions,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    selectedDate,
    transactions,
    errorMessage,
  ];
}