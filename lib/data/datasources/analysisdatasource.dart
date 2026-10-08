import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/analytics/analytics_model.dart';


class AnalysisDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  AnalysisDataSource({
    required this.firestore,
    required this.firebaseAuth,
  });

  Future<AnalysisModel> getAnalysis() async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    final uid = user.uid;

    final profileSnapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('profile')
        .doc('data')
        .get();

    final profileData = profileSnapshot.data() ?? {};

    final double openingBalance =
    _toDouble(profileData['openingBalance']);

    final double budget =
    _toDouble(profileData['budget']);

    final transactionSnapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .get();

    final List<AnalysisTransactionModel> transactions = [];

    for (final doc in transactionSnapshot.docs) {
      final data = doc.data();

      final transaction = AnalysisTransactionModel(
        title: data['title']?.toString() ?? '',
        category: data['category']?.toString() ?? '',
        type: data['type']?.toString().toLowerCase() ??
            'expense',
        amount: _toDouble(data['amount']),
        date: _getDate(data['date']),
      );

      transactions.add(transaction);
    }

    transactions.sort(
          (a, b) => b.date.compareTo(a.date),
    );

    double totalIncome = 0.0;
    double totalExpense = 0.0;

    for (final transaction in transactions) {
      if (transaction.type == 'income') {
        totalIncome += transaction.amount;
      } else {
        totalExpense += transaction.amount;
      }
    }

    final double totalBalance =
        openingBalance + totalIncome - totalExpense;

    double expensePercentage = 0.0;

    if (budget > 0.0) {
      expensePercentage =
          (totalExpense / budget) * 100.0;
    }

    if (!expensePercentage.isFinite) {
      expensePercentage = 0.0;
    }

    final DateTime now = DateTime.now();

    final DateTime sevenDaysAgo = now.subtract(
      const Duration(days: 7),
    );

    double revenueLastWeek = 0.0;
    double foodLastWeek = 0.0;

    for (final transaction in transactions) {
      if (transaction.date.isAfter(sevenDaysAgo) &&
          transaction.date.isBefore(
            now.add(const Duration(days: 1)),
          )) {
        if (transaction.type == 'income') {
          revenueLastWeek += transaction.amount;
        }

        if (transaction.category.toLowerCase() ==
            'food') {
          foodLastWeek += transaction.amount;
        }
      }
    }

    final List<double> chartValues =
    _createMonthlyChart(
      transactions,
      now,
    );

    return AnalysisModel(
      totalBalance: totalBalance,
      totalExpense: totalExpense,
      budget: budget,
      expensePercentage: expensePercentage,
      revenueLastWeek: revenueLastWeek,
      foodLastWeek: foodLastWeek,
      transactions: transactions,
      chartValues: chartValues,
    );
  }

  List<double> _createMonthlyChart(
      List<AnalysisTransactionModel> transactions,
      DateTime date,
      ) {
    final List<double> values = [];

    final int daysInMonth = DateTime(
      date.year,
      date.month + 1,
      0,
    ).day;

    for (int week = 0; week < 4; week++) {
      final int startDay = (week * 7) + 1;

      int endDay = startDay + 6;

      if (endDay > daysInMonth) {
        endDay = daysInMonth;
      }

      double expense = 0.0;

      for (final transaction in transactions) {
        final bool sameYear =
            transaction.date.year == date.year;

        final bool sameMonth =
            transaction.date.month == date.month;

        final bool insideWeek =
            transaction.date.day >= startDay &&
                transaction.date.day <= endDay;

        if (sameYear &&
            sameMonth &&
            insideWeek &&
            transaction.type != 'income') {
          expense += transaction.amount;
        }
      }

      values.add(expense);
    }

    return values;
  }

  double _toDouble(dynamic value) {
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

  DateTime _getDate(dynamic value) {
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