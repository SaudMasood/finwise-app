
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/config/social_login_config.dart';

class GoogleLoginDataSource {
  final FirebaseAuth firebaseAuth;

  GoogleLoginDataSource({
    required this.firebaseAuth,
  });

  static Future<void>? _initializeFuture;

  Future<void> _initializeGoogleSignIn() {
    return _initializeFuture ??= GoogleSignIn.instance.initialize(
      serverClientId: SocialLoginConfig.googleServerClientId,
    );
  }

  Future<UserCredential> loginWithGoogle() async {
    await _initializeGoogleSignIn();

    final GoogleSignInAccount googleUser =
    await GoogleSignIn.instance.authenticate();

    final GoogleSignInAuthentication googleAuth =
        googleUser.authentication;

    final String? idToken = googleAuth.idToken;

    if (idToken == null) {
      throw Exception(
        'Google ID token not found. Check your Google OAuth configuration.',
      );
    }

    final OAuthCredential credential =
    GoogleAuthProvider.credential(
      idToken: idToken,
    );

    return firebaseAuth.signInWithCredential(credential);
  }
}
