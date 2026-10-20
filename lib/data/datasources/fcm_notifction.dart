
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FcmService {
  final FirebaseMessaging messaging;
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  FcmService({
    FirebaseMessaging? messaging,
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : messaging = messaging ?? FirebaseMessaging.instance,
        firestore = firestore ?? FirebaseFirestore.instance,
        auth = auth ?? FirebaseAuth.instance;

  Future<void> registerDevice() async {
    final user = auth.currentUser;

    if (user == null) {
      debugPrint('FCM registration skipped: user is not logged in.');
      return;
    }

    await messaging.requestPermission();

    final token = await messaging.getToken();

    if (token == null) {
      debugPrint('FCM token unavailable.');
      return;
    }

    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('fcmTokens')
        .doc(token)
        .set({
      'token': token,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    debugPrint('FCM device registered successfully.');
    debugPrint('FCM DEVICE TOKEN: $token');
  }

  Future<void> printFcmToken() async {
    await messaging.requestPermission();

    final token = await messaging.getToken();

    if (token == null) {
      debugPrint('FCM token unavailable.');
      return;
    }

    debugPrint('FCM DEVICE TOKEN: $token');
  }

  Future<void> unregisterDevice() async {
    final user = auth.currentUser;
    final token = await messaging.getToken();

    if (user == null || token == null) return;

    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('fcmTokens')
        .doc(token)
        .delete();
  }

  Future<void> deleteDeviceToken() async {
    await messaging.deleteToken();
  }
}