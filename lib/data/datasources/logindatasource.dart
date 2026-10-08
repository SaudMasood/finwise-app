import 'package:firebase_auth/firebase_auth.dart';

class LoginDataSource {
  final FirebaseAuth firebaseAuth;

  LoginDataSource({
    required this.firebaseAuth,
  });

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}