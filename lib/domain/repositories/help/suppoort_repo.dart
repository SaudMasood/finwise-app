
import '../../entities/help/support_chat.dart';
import '../../entities/help/support_messge.dart';

abstract class SupportRepository {
  Stream<List<SupportChat>> watchChats();

  Stream<List<SupportMessage>> watchMessages(String chatId);

  Future<String> createChat(String title);

  Future<void> sendMessage(String chatId, String text);

  Future<void> endChat(String chatId);
}
