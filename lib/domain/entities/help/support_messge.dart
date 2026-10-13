
class SupportMessage {
  final String id;
  final String text;
  final String sender;
  final DateTime createdAt;

  const SupportMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.createdAt,
  });

  bool get isUser => sender == 'user';
}
