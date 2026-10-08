import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/saving/saving.dart';


class SavingModel extends SavingEntity {
  const SavingModel({
    required super.id,
    required super.category,
    required super.title,
    required super.amount,
    required super.message,
    required super.date,
    required super.createdAt,
  });

  factory SavingModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data() ?? {};

    final dateValue = data['date'];
    final createdAtValue = data['createdAt'];

    DateTime date;

    if (dateValue is Timestamp) {
      date = dateValue.toDate();
    } else if (dateValue is DateTime) {
      date = dateValue;
    } else if (dateValue is String) {
      date = DateTime.tryParse(dateValue) ?? DateTime.now();
    } else {
      date = DateTime.now();
    }

    DateTime createdAt;

    if (createdAtValue is Timestamp) {
      createdAt = createdAtValue.toDate();
    } else if (createdAtValue is DateTime) {
      createdAt = createdAtValue;
    } else if (createdAtValue is String) {
      createdAt =
          DateTime.tryParse(createdAtValue) ?? DateTime.now();
    } else {
      createdAt = DateTime.now();
    }

    final amountValue = data['amount'];

    double amount = 0;

    if (amountValue is num) {
      amount = amountValue.toDouble();
    } else if (amountValue is String) {
      amount = double.tryParse(amountValue) ?? 0;
    }

    return SavingModel(
      id: doc.id,
      category: data['category'] ?? '',
      title: data['title'] ?? '',
      amount: amount,
      message: data['message'] ?? '',
      date: date,
      createdAt: createdAt,
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
    };
  }
}