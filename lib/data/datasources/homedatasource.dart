import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/home/home_model.dart';

class HomeDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  HomeDataSource({
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

  Stream<List<HomeActivityModel>>
  watchTransactions() {
    return firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .snapshots()
        .map(
          (snapshot) {
        final transactions =
        snapshot.docs
            .map(
          HomeActivityModel
              .fromFirestore,
        )
            .toList();

        transactions.sort(
              (a, b) =>
              b.date.compareTo(a.date),
        );

        return transactions;
      },
    );
  }

  Stream<double> watchBudget() {
    return firestore
        .collection('users')
        .doc(uid)
        .collection('home')
        .doc('dashboard')
        .snapshots()
        .map(
          (snapshot) {
        final data =
        snapshot.data();

        if (data == null) {
          return 0;
        }

        final value =
        data['budget'];

        if (value is num) {
          return value.toDouble();
        }

        if (value is String) {
          return double.tryParse(value) ??
              0;
        }

        return 0;
      },
    );
  }
}