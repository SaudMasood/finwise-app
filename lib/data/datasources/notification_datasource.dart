import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  NotificationDataSource({
    required this.firestore,
    required this.firebaseAuth,
  });

  CollectionReference<Map<String, dynamic>> get _collection {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('Please log in to access notifications.');
    }

    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('notifications');
  }

  Stream<List<Map<String, dynamic>>> watchNotifications() {
    return _collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
        return {
          ...doc.data(),
          'id': doc.id,
        };
      }).toList(),
    );
  }

  Future<String> createNotification({
    required String title,
    required String message,
    required String type,
    String details = '',
    DateTime? scheduledAt,
    String? sourceId,
  }) async {
    if (sourceId != null && sourceId.isNotEmpty) {
      final existing = await _collection
          .where('sourceId', isEqualTo: sourceId)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        return existing.docs.first.id;
      }
    }

    final doc = await _collection.add({
      'title': title,
      'message': message,
      'details': details,
      'type': type,
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
      'scheduledAt': scheduledAt == null
          ? null
          : Timestamp.fromDate(scheduledAt),
      'sourceId': sourceId,
    });

    return doc.id;
  }

  Future<void> markNotificationRead(String notificationId) async {
    await _collection.doc(notificationId).update({
      'isRead': true,
    });
  }

  Future<void> markAllNotificationsRead(
      List<String> notificationIds,
      ) async {
    for (var i = 0; i < notificationIds.length; i += 450) {
      final batch = firestore.batch();
      final end = (i + 450 < notificationIds.length)
          ? i + 450
          : notificationIds.length;

      for (final id in notificationIds.sublist(i, end)) {
        batch.update(_collection.doc(id), {'isRead': true});
      }

      await batch.commit();
    }
  }

  Future<void> deleteAllNotifications() async {
    while (true) {
      final snapshot = await _collection.limit(450).get();

      if (snapshot.docs.isEmpty) return;

      final batch = firestore.batch();

      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    }
  }
}