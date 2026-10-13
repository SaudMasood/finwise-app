import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/notification/notification.dart';


class NotificationModel extends AppNotification {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.details,
    required super.type,
    required super.createdAt,
    required super.isRead,
  });

  factory NotificationModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> document,
      ) {
    final data = document.data() ?? {};

    final rawDate = data['createdAt'];

    DateTime date = DateTime.now();

    if (rawDate is Timestamp) {
      date = rawDate.toDate();
    } else if (rawDate is DateTime) {
      date = rawDate;
    } else if (rawDate is String) {
      date = DateTime.tryParse(rawDate) ?? DateTime.now();
    }

    return NotificationModel(
      id: document.id,
      title: data['title']?.toString() ?? 'Notification',
      message: data['message']?.toString() ?? '',
      details: data['details']?.toString() ?? '',
      type: data['type']?.toString() ?? 'general',
      createdAt: date,
      isRead: data['isRead'] == true,
    );
  }
}