import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/transactions/transactions.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.title,
    required super.category,
    required super.type,
    required super.amount,
    required super.date,
  });

  factory TransactionModel.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    double amount = 0;

    final amountValue = map['amount'];

    if (amountValue is num) {
      amount = amountValue.toDouble();
    } else if (amountValue is String) {
      amount = double.tryParse(amountValue) ?? 0;
    }

    DateTime date = DateTime.now();

    final dateValue = map['date'];

    if (dateValue is Timestamp) {
      date = dateValue.toDate();
    } else if (dateValue is String) {
      date = DateTime.tryParse(dateValue) ?? DateTime.now();
    }

    return TransactionModel(
      id: id,
      title: map['title']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      type: map['type']?.toString().toLowerCase() ?? 'expense',
      amount: amount,
      date: date,
    );
  }
}