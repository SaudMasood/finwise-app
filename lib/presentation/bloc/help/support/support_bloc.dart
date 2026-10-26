
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/help/support_chat.dart';
import '../../../../domain/entities/help/support_messge.dart';
import '../../../../domain/usecases/help/get_support.dart';
import 'support_event.dart';
import 'support_state.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  final WatchSupportChats watchChats;
  final WatchSupportMessages watchMessages;
  final CreateSupportChat createChat;
  final SendSupportMessage sendMessage;
  final EndSupportChat endChat;

  StreamSubscription<List<SupportChat>>? _chatsSubscription;
  StreamSubscription<List<SupportMessage>>? _messagesSubscription;

  SupportBloc({
    required this.watchChats,
    required this.watchMessages,
    required this.createChat,
    required this.sendMessage,
    required this.endChat,
  }) : super(const SupportState()) {
    on<LoadSupportChats>(_loadChats);
    on<CreateNewSupportChat>(_createChat);
    on<OpenSupportChat>(_openChat);
    on<SendSupportMessageEvent>(_sendMessage);
    on<EndSupportChatEvent>(_endChat);
    on<SupportChatsUpdated>(_chatsUpdated);
    on<SupportMessagesUpdated>(_messagesUpdated);
    on<SupportOperationFailed>(_operationFailed);
  }

  Future<void> _loadChats(
      LoadSupportChats event,
      Emitter<SupportState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    await _chatsSubscription?.cancel();

    _chatsSubscription = watchChats().listen(
          (chats) => add(SupportChatsUpdated(chats)),
      onError: (Object error) {
        add(SupportOperationFailed(error.toString()));
      },
    );

    emit(state.copyWith(isLoading: false));
  }


  Future<void> _createChat(
      CreateNewSupportChat event,
      Emitter<SupportState> emit,
      ) async {
    try {
      emit(state.copyWith(
        isLoading: true,
        clearError: true,
      ));

      final chatId = await createChat(event.title);

      emit(state.copyWith(
        isLoading: false,
        selectedChatId: chatId,
      ));

      add(OpenSupportChat(chatId));
    } catch (error) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      ));
    }
  }


  Future<void> _openChat(
      OpenSupportChat event,
      Emitter<SupportState> emit,
      ) async {
    await _messagesSubscription?.cancel();

    emit(state.copyWith(
      selectedChatId: event.chatId,
      messages: [],
      clearError: true,
    ));

    _messagesSubscription = watchMessages(event.chatId).listen(
          (messages) {
        add(SupportMessagesUpdated(event.chatId, messages));
      },
      onError: (Object error) {
        add(SupportOperationFailed(error.toString()));
      },
    );
  }

  Future<void> _sendMessage(
      SendSupportMessageEvent event,
      Emitter<SupportState> emit,
      ) async {
    if (event.text.trim().isEmpty) return;

    try {
      emit(state.copyWith(isSending: true, clearError: true));

      await sendMessage(event.chatId, event.text);

      emit(state.copyWith(isSending: false));
    } catch (error) {
      emit(state.copyWith(
        isSending: false,
        errorMessage: error.toString(),
      ));
    }
  }


  Future<void> _endChat(
      EndSupportChatEvent event,
      Emitter<SupportState> emit,
      ) async {
    try {
      await endChat(event.chatId);
      await _messagesSubscription?.cancel();
      _messagesSubscription = null;

      emit(state.copyWith(
        clearSelectedChatId: true,
        messages: [],
        clearError: true,
      ));
    } catch (error) {
      emit(state.copyWith(errorMessage: error.toString()));
    }
  }


  void _chatsUpdated(
      SupportChatsUpdated event,
      Emitter<SupportState> emit,
      ) {
    emit(state.copyWith(
      chats: event.chats.cast<SupportChat>(),
      isLoading: false,
      clearError: true,
    ));
  }

  void _messagesUpdated(
      SupportMessagesUpdated event,
      Emitter<SupportState> emit,
      ) {
    if (state.selectedChatId != event.chatId) return;

    emit(state.copyWith(
      messages: event.messages.cast<SupportMessage>(),
      clearError: true,
    ));
  }

  void _operationFailed(
      SupportOperationFailed event,
      Emitter<SupportState> emit,
      ) {
    emit(state.copyWith(
      isLoading: false,
      isSending: false,
      errorMessage: event.message,
    ));
  }

  @override
  Future<void> close() async {
    await _chatsSubscription?.cancel();
    await _messagesSubscription?.cancel();
    return super.close();
  }
}
