
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/help/support_chat.dart';
import '../../../../domain/entities/help/support_messge.dart';


class SupportState extends Equatable {
  final bool isLoading;
  final bool isSending;
  final String? errorMessage;
  final List<SupportChat> chats;
  final List<SupportMessage> messages;
  final String? selectedChatId;

  const SupportState({
    this.isLoading = false,
    this.isSending = false,
    this.errorMessage,
    this.chats = const [],
    this.messages = const [],
    this.selectedChatId,
  });

  SupportState copyWith({
    bool? isLoading,
    bool? isSending,
    String? errorMessage,
    bool clearError = false,
    List<SupportChat>? chats,
    List<SupportMessage>? messages,
    String? selectedChatId,
  }) {
    return SupportState(
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      errorMessage: clearError
          ? null
          : errorMessage ?? this.errorMessage,
      chats: chats ?? this.chats,
      messages: messages ?? this.messages,
      selectedChatId: selectedChatId ?? this.selectedChatId,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSending,
    errorMessage,
    chats,
    messages,
    selectedChatId,
  ];
}
