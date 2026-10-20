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

  static const List<String> defaultCategories = [
    'Travel',
    'New House',
    'Car',
    'Wedding',
    'Emergency Fund',
  ];

  String get _userId {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw StateError('Please sign in before using Savings.');
    }
    return user.uid;
  }

  DocumentReference<Map<String, dynamic>> get _userDocument =>
      firestore.collection('users').doc(_userId);

  CollectionReference<Map<String, dynamic>>
  get _categoriesCollection =>
      _userDocument.collection('saving_categories');

  String _categoryId(String name) {
    return name
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
  }

  /// Creates the user profile if necessary and adds any missing
  /// default categories. Existing category goals are never overwritten.
  Future<void> initializeSavings() async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw StateError('Please sign in before using Savings.');
    }

    final userRef = _userDocument;
    final userSnapshot = await userRef.get();

    if (!userSnapshot.exists) {
      await userRef.set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    final batch = firestore.batch();

    for (final categoryName in defaultCategories) {
      final categoryRef =
      _categoriesCollection.doc(_categoryId(categoryName));
      final snapshot = await categoryRef.get();

      if (!snapshot.exists) {
        batch.set(categoryRef, {
          'name': categoryName,
          'goal': 0.0,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'isDefault': true,
        });
      }
    }

    await batch.commit();
  }

  /// Emits category names from this user's Firestore documents.
  /// Initialization happens before the live category stream starts.
  Stream<List<String>> watchSavingCategories() {
    return Stream<void>.fromFuture(initializeSavings()).asyncExpand(
          (_) => _categoriesCollection
          .orderBy('createdAt')
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
            .map((doc) {
          final data = doc.data();
          return (data['name'] as String?) ?? doc.id;
        })
            .toList(),
      ),
    );
  }

  /// Creates a new category with its own goal.
  Future<void> addSavingCategory({
    required String name,
    double goal = 0,
  }) async {
    final cleanName = name.trim();

    if (cleanName.isEmpty) {
      throw ArgumentError('Category name cannot be empty.');
    }
    if (!goal.isFinite || goal < 0) {
      throw ArgumentError('Goal must be a valid non-negative amount.');
    }

    await initializeSavings();

    final categoryId = _categoryId(cleanName);
    if (categoryId.isEmpty) {
      throw ArgumentError('Please enter a valid category name.');
    }

    final categoryRef = _categoriesCollection.doc(categoryId);
    final existing = await categoryRef.get();

    if (existing.exists) {
      throw StateError('This saving category already exists.');
    }

    await categoryRef.set({
      'name': cleanName,
      'goal': goal,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'isDefault': false,
    });
  }

  /// Returns the saved goal for a category.
  Future<double> getGoal(String category) async {
    await initializeSavings();

    final snapshot =
    await _categoriesCollection.doc(_categoryId(category)).get();

    if (!snapshot.exists) return 0.0;

    final value = snapshot.data()?['goal'];
    if (value is num) return value.toDouble();

    return 0.0;
  }

  /// Emits goal updates when the category document changes.
  Stream<double> watchGoal(String category) {
    return _categoriesCollection
        .doc(_categoryId(category))
        .snapshots()
        .map((snapshot) {
      final value = snapshot.data()?['goal'];
      return value is num ? value.toDouble() : 0.0;
    });
  }

  /// Reads only transactions belonging to the selected category.
  Stream<List<SavingModel>> watchSavings(String category) {
    final categoryId = _categoryId(category);

    return _categoriesCollection
        .doc(categoryId)
        .collection('savings')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return SavingModel.fromFirestore(
          doc,
          category: category,
        );
      }).toList();
    });
  }

  /// Adds a transaction inside its category's nested savings collection.
  Future<void> addSaving(SavingModel saving) async {
    await initializeSavings();

    final categoryName = saving.category.trim();
    if (categoryName.isEmpty) {
      throw ArgumentError('Select a saving category.');
    }
    if (!saving.amount.isFinite || saving.amount <= 0) {
      throw ArgumentError('Amount must be greater than zero.');
    }

    final categoryRef =
    _categoriesCollection.doc(_categoryId(categoryName));
    final categorySnapshot = await categoryRef.get();

    if (!categorySnapshot.exists) {
      throw StateError(
        'The category "$categoryName" does not exist. '
            'Please create it first.',
      );
    }

    final transactionData = saving.toFirestore()
      ..['category'] = categoryName
      ..['createdAt'] = FieldValue.serverTimestamp();

    await categoryRef.collection('savings').add(transactionData);
  }
}