
import '../../../domain/entities/help/support_chat.dart';
import '../../../domain/entities/help/support_messge.dart';
import '../../../domain/repositories/help/suppoort_repo.dart';
import '../../datasources/support_datasorce.dart';

class SupportRepositoryImpl implements SupportRepository {
  final SupportRemoteDataSource dataSource;

  SupportRepositoryImpl(this.dataSource);

  @override
  Stream<List<SupportChat>> watchChats() {
    return dataSource.watchChats();
  }

  @override
  Stream<List<SupportMessage>> watchMessages(String chatId) {
    return dataSource.watchMessages(chatId);
  }

  @override
  Future<String> createChat(String title) {
    return dataSource.createChat(title);
  }

  @override
  Future<void> sendMessage(String chatId, String text) {
    return dataSource.sendMessage(chatId, text);
  }

  @override
  Future<void> endChat(String chatId) {
    return dataSource.endChat(chatId);
  }
}
