
import '../../../domain/entities/analytics/serchtrans.dart';

class SearchTransactionModel extends SearchTransactionEntity {
  const SearchTransactionModel({
    required super.id,
    required super.title,
    required super.category,
    required super.type,
    required super.amount,
    required super.date,
  });

  factory SearchTransactionModel.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return SearchTransactionModel(
      id: id,
      title: map['title']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      type: map['type']?.toString().toLowerCase() ?? 'expense',
      amount: _toDouble(map['amount']),
      date: _getDate(map['date']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) {
      return 0.0;
    }

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }

    return 0.0;
  }

  static DateTime _getDate(dynamic value) {
    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }

    try {
      return value.toDate();
    } catch (_) {
      return DateTime.now();
    }
  }
}