import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/transactions/transactions_model.dart';

class TransactionDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  TransactionDataSource({
    required this.firestore,
    required this.firebaseAuth,
  });

  Future<List<TransactionModel>> getTransactions() async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    final snapshot = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return TransactionModel.fromMap(
        doc.id,
        doc.data(),
      );
    }).toList();
  }
}