import 'package:equatable/equatable.dart';

class ExpenseEntity extends Equatable {
  final String id;
  final String category;
  final String title;
  final double amount;
  final String message;
  final DateTime date;
  final DateTime createdAt;
  final String type;

  const ExpenseEntity({
    required this.id,
    required this.category,
    required this.title,
    required this.amount,
    required this.message,
    required this.date,
    required this.createdAt,
    required this.type,
  });

  @override
  List<Object> get props => [
    id,
    category,
    title,
    amount,
    message,
    date,
    createdAt,
    type,
  ];
}