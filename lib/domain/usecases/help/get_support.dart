
import '../../entities/help/support_chat.dart';
import '../../entities/help/support_messge.dart';
import '../../repositories/help/suppoort_repo.dart';

class WatchSupportChats {
  final SupportRepository repository;

  WatchSupportChats(this.repository);

  Stream<List<SupportChat>> call() {
    return repository.watchChats();
  }
}

class WatchSupportMessages {
  final SupportRepository repository;

  WatchSupportMessages(this.repository);

  Stream<List<SupportMessage>> call(String chatId) {
    return repository.watchMessages(chatId);
  }
}

class CreateSupportChat {
  final SupportRepository repository;

  CreateSupportChat(this.repository);

  Future<String> call(String title) {
    return repository.createChat(title);
  }
}

class SendSupportMessage {
  final SupportRepository repository;

  SendSupportMessage(this.repository);

  Future<void> call(String chatId, String text) {
    return repository.sendMessage(chatId, text);
  }
}

class EndSupportChat {
  final SupportRepository repository;

  EndSupportChat(this.repository);

  Future<void> call(String chatId) {
    return repository.endChat(chatId);
  }
}
