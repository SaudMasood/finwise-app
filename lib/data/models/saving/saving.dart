
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
      DocumentSnapshot<Map<String, dynamic>> document, {
        required String category,
      }) {
    final data = document.data() ?? <String, dynamic>{};

    final dateValue = data['date'];
    final createdAtValue = data['createdAt'];

    return SavingModel(
      id: document.id,
      category: category,
      title: data['title'] as String? ?? '',
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      message: data['message'] as String? ?? '',
      date: _toDateTime(dateValue),
      createdAt: _toDateTime(createdAtValue),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'amount': amount,
      'message': message,
      'date': Timestamp.fromDate(date),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static DateTime _toDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }

    return DateTime.now();
  }
}
