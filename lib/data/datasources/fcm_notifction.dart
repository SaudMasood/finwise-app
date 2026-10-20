
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalDataSource {
  final FirebaseAuth auth;

  OneSignalDataSource({
    FirebaseAuth? auth,
  }) : auth = auth ?? FirebaseAuth.instance;

  /// Call after the user logs in.
  Future<void> registerDevice() async {
    final user = auth.currentUser;

    if (user == null) {
      debugPrint('OneSignal: user is not logged in.');
      return;
    }

    // Associates this OneSignal subscription with the
    // authenticated FinWise user.
    OneSignal.login(user.uid);

    debugPrint('OneSignal user linked: ${user.uid}');
    debugPrint(
      'OneSignal subscription ID: '
          '${OneSignal.User.pushSubscription.id}',
    );
  }

  /// Optional: print subscription information for debugging.
  void printSubscriptionInfo() {
    debugPrint(
      'OneSignal subscription ID: '
          '${OneSignal.User.pushSubscription.id}',
    );
    debugPrint(
      'Push token: ${OneSignal.User.pushSubscription.token}',
    );
    debugPrint(
      'Push opted in: ${OneSignal.User.pushSubscription.optedIn}',
    );
  }

  //Call when the user logs out.
  void unregisterDevice() {
    OneSignal.logout();
  }
}
