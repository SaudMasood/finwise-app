import 'package:equatable/equatable.dart';

class SavingEntity extends Equatable {
  final String id;
  final String category;
  final String title;
  final double amount;
  final String message;
  final DateTime date;
  final DateTime createdAt;

  const SavingEntity({
    required this.id,
    required this.category,
    required this.title,
    required this.amount,
    required this.message,
    required this.date,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    category,
    title,
    amount,
    message,
    date,
    createdAt,
  ];
}