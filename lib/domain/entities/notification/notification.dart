import 'package:equatable/equatable.dart';

class AppNotification extends Equatable {
  final String id;
  final String title;
  final String message;
  final String details;
  final String type;
  final DateTime createdAt;
  final DateTime? scheduledAt;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    this.details = '',
    required this.type,
    required this.createdAt,
    this.scheduledAt,
    required this.isRead,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    message,
    details,
    type,
    createdAt,
    scheduledAt,
    isRead,
  ];
}