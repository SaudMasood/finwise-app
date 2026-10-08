import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginDataSource {
  final FirebaseAuth firebaseAuth;

  GoogleLoginDataSource({
    required this.firebaseAuth,
  });

  Future<UserCredential> loginWithGoogle() async {
    await GoogleSignIn.instance.initialize(
      serverClientId:
      '941520086751-uvhqomkg7tq83o4u5cmr90428big7hiv.apps.googleusercontent.com',
    );

    final GoogleSignInAccount googleUser =
    await GoogleSignIn.instance.authenticate();

    final GoogleSignInAuthentication googleAuth =
        googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return await firebaseAuth.signInWithCredential(
      credential,
    );
  }
}