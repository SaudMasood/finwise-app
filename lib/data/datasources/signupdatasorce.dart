import 'package:firebase_auth/firebase_auth.dart';

class SignupDataSource {
  final FirebaseAuth firebaseAuth;

  SignupDataSource({
    required this.firebaseAuth,
  });

  Future<UserCredential> signup({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}