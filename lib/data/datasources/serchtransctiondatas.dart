import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/analytics/serchmodl.dart';


class SearchDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  SearchDataSource({
    required this.firestore,
    required this.firebaseAuth,
  });

  Future<List<SearchTransactionModel>> getTransactions() async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    final snapshot = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .get();

    final List<SearchTransactionModel> transactions = [];

    for (final doc in snapshot.docs) {
      transactions.add(
        SearchTransactionModel.fromMap(
          doc.id,
          doc.data(),
        ),
      );
    }

    transactions.sort(
          (a, b) => b.date.compareTo(a.date),
    );

    return transactions;
  }

  Future<List<String>> getCategories() async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    final snapshot = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .get();

    final Set<String> categorySet = {};

    for (final doc in snapshot.docs) {
      final data = doc.data();

      final category =
          data['category']?.toString().trim() ?? '';

      if (category.isNotEmpty) {
        categorySet.add(category);
      }
    }

    final categories = categorySet.toList();

    categories.sort();

    return categories;
  }
}