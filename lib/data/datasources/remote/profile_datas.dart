
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/profile/profile_model.dart';

class ProfileRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ProfileRemoteDataSource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : firestore = firestore ?? FirebaseFirestore.instance,
        auth = auth ?? FirebaseAuth.instance;

  Future<UserProfileModel> getProfile() async {
    final user = auth.currentUser;

    if (user == null) {
      throw Exception('Please log in to view your profile.');
    }

    final document =
    await firestore.collection('users').doc(user.uid).get();

    final data = document.data() ?? <String, dynamic>{};

    final name = (data['name'] ??
        user.displayName ??
        user.email?.split('@').first ??
        'Your Name')
        .toString();

    return UserProfileModel(
      uid: user.uid,
      name: name,
      email: user.email ?? (data['email'] ?? '').toString(),
      phone: (data['phone'] ?? user.phoneNumber ?? '').toString(),
    );
  }

  Future<void> saveProfile(UserProfileModel profile) async {
    final user = auth.currentUser;

    if (user == null) {
      throw Exception('Please log in to update your profile.');
    }

    final name = profile.name.trim();
    final phone = profile.phone.trim();
    final newEmail = profile.email.trim();
    final currentEmail = user.email ?? '';

    if (name.isEmpty) {
      throw Exception('Username cannot be empty.');
    }

    if (newEmail.isEmpty ||
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(newEmail)) {
      throw Exception('Please enter a valid email address.');
    }

    if (newEmail.toLowerCase() != currentEmail.toLowerCase()) {
      try {
        await user.verifyBeforeUpdateEmail(newEmail);
      } on FirebaseAuthException catch (error) {
        if (error.code == 'requires-recent-login') {
          throw Exception(
            'Please log out and log in again before changing your email.',
          );
        }
        throw Exception(error.message ?? 'Unable to update email.');
      }
    }

    await user.updateDisplayName(name);

    await firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'name': name,
      'email': newEmail.toLowerCase() == currentEmail.toLowerCase()
          ? currentEmail
          : newEmail,
      'phone': phone,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
