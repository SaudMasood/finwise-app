import 'package:firebase_auth/firebase_auth.dart';

class LogoutRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  LogoutRemoteDataSource(this.firebaseAuth);

  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}