import 'package:equatable/equatable.dart';

import '../../../domain/entities/transactions/transactions.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {
  const TransactionInitial();
}

class TransactionLoading extends TransactionState {
  const TransactionLoading();
}

class TransactionSuccess extends TransactionState {
  final List<TransactionEntity> allTransactions;
  final List<TransactionEntity> transactions;
  final String? selectedType;
  final DateTime? selectedDate;

  const TransactionSuccess({
    required this.allTransactions,
    required this.transactions,
    required this.selectedType,
    required this.selectedDate,
  });

  @override
  List<Object?> get props => [
    allTransactions,
    transactions,
    selectedType,
    selectedDate,
  ];
}

class TransactionFailure extends TransactionState {
  final String message;

  const TransactionFailure({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}