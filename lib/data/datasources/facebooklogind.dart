import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookLoginDataSource {
  final FirebaseAuth firebaseAuth;

  FacebookLoginDataSource({
    required this.firebaseAuth,
  });

  Future<UserCredential> loginWithFacebook() async {
    final LoginResult result =
    await FacebookAuth.instance.login();

    if (result.status != LoginStatus.success) {
      throw Exception('Facebook login cancelled');
    }

    final accessToken = result.accessToken;

    if (accessToken == null) {
      throw Exception('Facebook access token not found');
    }

    final credential = FacebookAuthProvider.credential(
      accessToken.tokenString,
    );

    return await firebaseAuth.signInWithCredential(
      credential,
    );
  }
}