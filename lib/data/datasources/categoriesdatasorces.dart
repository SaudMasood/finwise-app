import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/categories/expensemodel.dart';

class CategoryDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  CategoryDataSource({
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

  CollectionReference<Map<String, dynamic>>
  get categoriesCollection {
    return firestore
        .collection('users')
        .doc(uid)
        .collection('categories');
  }

  CollectionReference<Map<String, dynamic>>
  get transactionsCollection {
    return firestore
        .collection('users')
        .doc(uid)
        .collection('transactions');
  }

  Stream<List<String>> watchCategories() {
    return categoriesCollection.snapshots().map(
          (snapshot) {
        final categories = snapshot.docs
            .map(
              (doc) =>
          doc.data()['name']?.toString().trim() ?? '',
        )
            .where(
              (name) => name.isNotEmpty,
        )
            .toSet()
            .toList();

        categories.sort(
              (a, b) => a.toLowerCase().compareTo(
            b.toLowerCase(),
          ),
        );

        return categories;
      },
    );
  }

  Stream<List<ExpenseModel>> watchTransactions({
    String? category,
  }) {
    Query<Map<String, dynamic>> query =
        transactionsCollection;

    if (category != null && category.trim().isNotEmpty) {
      query = query.where(
        'category',
        isEqualTo: category.trim(),
      );
    }

    return query.snapshots().map(
          (snapshot) {
        final transactions = snapshot.docs
            .map(
              (doc) => ExpenseModel.fromFirestore(doc),
        )
            .toList();

        transactions.sort(
              (a, b) => b.date.compareTo(a.date),
        );

        return transactions;
      },
    );
  }

  Future<void> addCategory({
    required String category,
  }) async {
    final name = category.trim();

    if (name.isEmpty) {
      throw Exception('Category name cannot be empty');
    }

    final existing = await categoriesCollection
        .where(
      'name',
      isEqualTo: name,
    )
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      throw Exception(
        'Category "$name" already exists',
      );
    }

    await categoriesCollection.add({
      'name': name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addExpense({
    required ExpenseModel expense,
  }) async {
    await transactionsCollection.add(
      expense.toFirestore(),
    );
  }

  Future<void> addIncome({
    required ExpenseModel income,
  }) async {
    await transactionsCollection.add(
      income.toFirestore(),
    );
  }
}