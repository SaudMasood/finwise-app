import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/home/home.dart';

class HomeActivityModel extends HomeActivityEntity {
  const HomeActivityModel({
    required super.id,
    required super.title,
    required super.category,
    required super.type,
    required super.amount,
    required super.date,
  });

  factory HomeActivityModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> document,
      ) {
    final data = document.data() ?? {};

    final amountValue = data['amount'];

    double amount = 0;

    if (amountValue is num) {
      amount = amountValue.toDouble();
    } else if (amountValue is String) {
      amount =
          double.tryParse(amountValue) ?? 0;
    }

    DateTime date = DateTime.now();

    final dateValue = data['date'];

    if (dateValue is Timestamp) {
      date = dateValue.toDate();
    } else if (dateValue is DateTime) {
      date = dateValue;
    } else if (dateValue is String) {
      date =
          DateTime.tryParse(dateValue) ??
              DateTime.now();
    }

    return HomeActivityModel(
      id: document.id,
      title: data['title']?.toString() ?? '',
      category:
      data['category']?.toString() ?? '',
      type:
      data['type']?.toString() ?? 'expense',
      amount: amount,
      date: date,
    );
  }
}