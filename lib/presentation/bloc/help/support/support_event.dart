
import 'package:equatable/equatable.dart';

abstract class SupportEvent extends Equatable {
  const SupportEvent();

  @override
  List<Object?> get props => [];
}

class LoadSupportChats extends SupportEvent {
  const LoadSupportChats();
}

class CreateNewSupportChat extends SupportEvent {
  final String title;

  const CreateNewSupportChat(this.title);

  @override
  List<Object?> get props => [title];
}

class OpenSupportChat extends SupportEvent {
  final String chatId;

  const OpenSupportChat(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class SendSupportMessageEvent extends SupportEvent {
  final String chatId;
  final String text;

  const SendSupportMessageEvent(this.chatId, this.text);

  @override
  List<Object?> get props => [chatId, text];
}

class EndSupportChatEvent extends SupportEvent {
  final String chatId;

  const EndSupportChatEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class SupportChatsUpdated extends SupportEvent {
  final List<dynamic> chats;

  const SupportChatsUpdated(this.chats);

  @override
  List<Object?> get props => [chats];
}

class SupportMessagesUpdated extends SupportEvent {
  final String chatId;
  final List<dynamic> messages;

  const SupportMessagesUpdated(this.chatId, this.messages);

  @override
  List<Object?> get props => [chatId, messages];
}

class SupportOperationFailed extends SupportEvent {
  final String message;

  const SupportOperationFailed(this.message);

  @override
  List<Object?> get props => [message];
}
