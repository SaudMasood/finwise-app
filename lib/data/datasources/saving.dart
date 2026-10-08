import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/saving/saving.dart';

class SavingsDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  SavingsDataSource({
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
  get savingsCollection {
    return firestore
        .collection('users')
        .doc(uid)
        .collection('savings');
  }

  CollectionReference<Map<String, dynamic>>
  get savingCategoriesCollection {
    return firestore
        .collection('users')
        .doc(uid)
        .collection('saving_categories');
  }

  Future<void> ensureDefaultSavingCategories() async {
    final snapshot =
    await savingCategoriesCollection.get();

    if (snapshot.docs.isNotEmpty) {
      return;
    }

    final defaults = [
      {
        'name': 'Travel',
        'goal': 1962.93,
      },
      {
        'name': 'New House',
        'goal': 569200.00,
      },
      {
        'name': 'Car',
        'goal': 14390.00,
      },
      {
        'name': 'Wedding',
        'goal': 34700.00,
      },
    ];

    final batch = firestore.batch();

    for (final item in defaults) {
      final ref =
      savingCategoriesCollection.doc();

      batch.set(ref, {
        'name': item['name'],
        'goal': item['goal'],
        'createdAt':
        FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  Stream<List<String>> watchSavingCategories() async* {
    await ensureDefaultSavingCategories();

    yield* savingCategoriesCollection
        .orderBy('createdAt')
        .snapshots()
        .map(
          (snapshot) {
        return snapshot.docs
            .map(
              (doc) =>
          doc.data()['name']?.toString() ??
              '',
        )
            .where(
              (name) => name.isNotEmpty,
        )
            .toList();
      },
    );
  }

  Future<void> addSavingCategory({
    required String name,
    double goal = 0,
  }) async {
    await savingCategoriesCollection.add({
      'name': name,
      'goal': goal,
      'createdAt':
      FieldValue.serverTimestamp(),
    });
  }

  Future<double> getGoal(
      String category,
      ) async {
    final snapshot =
    await savingCategoriesCollection
        .where(
      'name',
      isEqualTo: category,
    )
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return 0;
    }

    final value =
    snapshot.docs.first.data()['goal'];

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0;
    }

    return 0;
  }

  Stream<List<SavingModel>> watchSavings(
      String category,
      ) {
    return savingsCollection
        .where(
      'category',
      isEqualTo: category,
    )
        .snapshots()
        .map(
          (snapshot) {
        final savings = snapshot.docs
            .map(
              (doc) =>
              SavingModel.fromFirestore(doc),
        )
            .toList();

        savings.sort(
              (a, b) =>
              b.date.compareTo(a.date),
        );

        return savings;
      },
    );
  }

  Future<void> addSaving(
      SavingModel saving,
      ) async {
    await savingsCollection.add(
      saving.toFirestore(),
    );
  }
}