import 'package:firebase_auth/firebase_auth.dart';

class PasswordRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  PasswordRemoteDataSource({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('Please sign in again.');
    }

    final email = user.email;

    if (email == null || email.isEmpty) {
      throw Exception(
        'Password changes are not available for this account method.',
      );
    }

    final credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);

    await user.updatePassword(newPassword);
  }
}