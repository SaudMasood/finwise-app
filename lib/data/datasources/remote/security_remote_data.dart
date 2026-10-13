
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SecurityRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  SecurityRemoteDataSource({
    required this.firestore,
    required this.auth,
  });

  CollectionReference<Map<String, dynamic>> _securityCollection() {
    final user = auth.currentUser;

    if (user == null) {
      throw Exception('Please sign in again.');
    }

    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('security');
  }

  Future<DocumentReference<Map<String, dynamic>>> _getSecurityDocument({
    bool createIfMissing = false,
  }) async {
    final collection = _securityCollection();
    final snapshot = await collection.get();

    if (snapshot.docs.isNotEmpty) {
      final currentUser = auth.currentUser!;

      for (final document in snapshot.docs) {
        if (document.id == currentUser.uid) {
          return document.reference;
        }
      }

      if (snapshot.docs.length == 1) {
        return snapshot.docs.first.reference;
      }

      throw Exception(
        'Multiple security documents found. Keep only the correct PIN document.',
      );
    }

    if (createIfMissing) {
      final user = auth.currentUser!;

      return collection.doc(user.uid);
    }

    throw Exception('No PIN is configured. Please set up your PIN first.');
  }

  String _hashPin(String pin, String salt) {
    return sha256.convert(utf8.encode('$salt:$pin')).toString();
  }

  String _generateSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));

    return base64UrlEncode(bytes);
  }

  Future<bool> hasPin() async {
    final collection = _securityCollection();
    final snapshot = await collection.get();

    for (final document in snapshot.docs) {
      final data = document.data();

      if (data['pinHash'] != null && data['pinSalt'] != null) {
        return true;
      }
    }

    return false;
  }

  Future<void> changePin({
    required String currentPin,
    required String newPin,
  }) async {
    if (!RegExp(r'^\d{4}$').hasMatch(newPin)) {
      throw Exception('PIN must contain exactly 4 digits.');
    }

    final collection = _securityCollection();
    final snapshot = await collection.get();

    DocumentReference<Map<String, dynamic>> documentReference;
    Map<String, dynamic>? existingData;

    if (snapshot.docs.isNotEmpty) {
      QueryDocumentSnapshot<Map<String, dynamic>>? existingDocument;

      final uid = auth.currentUser!.uid;

      for (final document in snapshot.docs) {
        if (document.id == uid) {
          existingDocument = document;
          break;
        }
      }

      existingDocument ??= snapshot.docs.length == 1
          ? snapshot.docs.first
          : null;

      if (existingDocument == null) {
        throw Exception(
          'Multiple security documents found. Please check Firestore.',
        );
      }

      documentReference = existingDocument.reference;
      existingData = existingDocument.data();
    } else {
      documentReference = await _getSecurityDocument(
        createIfMissing: true,
      );
    }

    final existingHash = existingData?['pinHash'] as String?;
    final existingSalt = existingData?['pinSalt'] as String?;

    if (existingHash != null && existingSalt != null) {
      if (currentPin.isEmpty) {
        throw Exception('Please enter your current PIN.');
      }

      final enteredHash = _hashPin(currentPin, existingSalt);

      if (enteredHash != existingHash) {
        throw Exception('Current PIN is incorrect.');
      }
    } else if (currentPin.isNotEmpty) {
      throw Exception('No PIN is configured. Leave Current PIN empty.');
    }

    final newSalt = _generateSalt();
    final newHash = _hashPin(newPin, newSalt);

    await documentReference.set({
      'uid': auth.currentUser!.uid,
      'pinHash': newHash,
      'pinSalt': newSalt,
      'pinUpdatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
