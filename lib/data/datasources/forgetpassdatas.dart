import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordDataSource {
  final FirebaseAuth firebaseAuth;

  ForgotPasswordDataSource({
    required this.firebaseAuth,
  });

  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    await firebaseAuth.sendPasswordResetEmail(
      email: email,
    );
  }
}