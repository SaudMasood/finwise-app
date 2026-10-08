import 'package:equatable/equatable.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactions extends TransactionEvent {
  const LoadTransactions();
}

class SelectTransactionType extends TransactionEvent {
  final String? type;

  const SelectTransactionType({
    required this.type,
  });

  @override
  List<Object?> get props => [type];
}

class SelectTransactionDate extends TransactionEvent {
  final DateTime date;

  const SelectTransactionDate({
    required this.date,
  });

  @override
  List<Object?> get props => [date];
}

class ClearTransactionFilters extends TransactionEvent {
  const ClearTransactionFilters();
}