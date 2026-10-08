import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/categories/expnse.dart';

class ExpenseModel extends ExpenseEntity {
  const ExpenseModel({
    required super.id,
    required super.category,
    required super.title,
    required super.amount,
    required super.message,
    required super.date,
    required super.createdAt,
    required super.type,
  });

  factory ExpenseModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> document,
      ) {
    final data = document.data() ?? {};

    return ExpenseModel(
      id: document.id,
      category: data['category']?.toString() ?? '',
      title: data['title']?.toString() ?? '',
      amount: _toDouble(data['amount']),
      message: data['message']?.toString() ?? '',
      date: _toDate(data['date']),
      createdAt: _toDate(data['createdAt']),
      type: data['type']?.toString() ?? 'expense',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'category': category,
      'title': title,
      'amount': amount,
      'message': message,
      'date': Timestamp.fromDate(date),
      'createdAt': FieldValue.serverTimestamp(),
      'type': type,
    };
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
  }

  static DateTime _toDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value) ??
          DateTime.now();
    }

    return DateTime.now();
  }
}