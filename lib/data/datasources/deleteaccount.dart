import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeleteAccountRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  DeleteAccountRemoteDataSource({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> deleteAccount({
    required String password,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Please sign in again.');
    }

    final email = user.email;

    if (email == null || email.isEmpty) {
      throw Exception(
        'Password confirmation is unavailable for this sign-in method.',
      );
    }

    // 1. Re-authenticate before destructive operations.
    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    await user.reauthenticateWithCredential(credential);

    final uid = user.uid;
    final userDocument = _firestore.collection('users').doc(uid);

    // 2. Delete known user-owned subcollections.
    const subcollections = [
      'transactions',
      'budgets',
      'notifications',
    ];

    for (final name in subcollections) {
      await _deleteCollection(userDocument.collection(name));
    }

    // 3. Delete the user profile document.
    await userDocument.delete();

    // 4. Delete the Firebase Authentication account.
    await user.delete();
  }

  Future<void> _deleteCollection(
      CollectionReference<Map<String, dynamic>> collection,
      ) async {
    while (true) {
      final snapshot = await collection.limit(400).get();

      if (snapshot.docs.isEmpty) {
        break;
      }

      final batch = _firestore.batch();

      for (final document in snapshot.docs) {
        batch.delete(document.reference);
      }

      await batch.commit();
    }
  }
}