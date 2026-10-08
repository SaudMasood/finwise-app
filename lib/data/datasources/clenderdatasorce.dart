import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/analytics/cleander.dart';


class CalendarDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  CalendarDataSource({
    required this.firestore,
    required this.firebaseAuth,
  });

  String get uid {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    return user.uid;
  }

  Future<List<CalendarTransactionModel>>
  getTransactionsByDate(
      DateTime date,
      ) async {
    final start = DateTime(
      date.year,
      date.month,
      date.day,
    );

    final end = start.add(
      const Duration(days: 1),
    );

    final snapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .where(
      'date',
      isGreaterThanOrEqualTo:
      Timestamp.fromDate(start),
    )
        .where(
      'date',
      isLessThan:
      Timestamp.fromDate(end),
    )
        .get();

    final transactions = snapshot.docs
        .map(
          (doc) =>
          CalendarTransactionModel
              .fromFirestore(doc),
    )
        .toList();

    transactions.sort(
          (a, b) => b.date.compareTo(a.date),
    );

    return transactions;
  }
}