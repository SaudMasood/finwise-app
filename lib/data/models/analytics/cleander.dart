import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/analytics/clender.dart';


class CalendarTransactionModel
    extends CalendarTransactionEntity {
  const CalendarTransactionModel({
    required super.id,
    required super.title,
    required super.category,
    required super.type,
    required super.amount,
    required super.message,
    required super.date,
  });

  factory CalendarTransactionModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data() ?? {};

    final amountValue = data['amount'];

    double amount = 0;

    if (amountValue is num) {
      amount = amountValue.toDouble();
    } else if (amountValue is String) {
      amount = double.tryParse(amountValue) ?? 0;
    }

    DateTime date = DateTime.now();

    final dateValue = data['date'];

    if (dateValue is Timestamp) {
      date = dateValue.toDate();
    } else if (dateValue is DateTime) {
      date = dateValue;
    } else if (dateValue is String) {
      date = DateTime.tryParse(dateValue) ??
          DateTime.now();
    }

    return CalendarTransactionModel(
      id: doc.id,
      title: data['title']?.toString() ?? '',
      category: data['category']?.toString() ?? '',
      type: data['type']?.toString() ?? 'expense',
      amount: amount,
      message: data['message']?.toString() ?? '',
      date: date,
    );
  }
}