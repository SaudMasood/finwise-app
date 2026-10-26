
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
import '../../../data/datasources/support_datasorce.dart';
import '../../../data/repositories/help/support_repo_impl.dart';
import '../../../domain/usecases/help/get_support.dart';
import '../../../domain/usecases/help/support_keyword_response.dart';
import '../../bloc/help/support/support_bloc.dart';
import '../../bloc/help/support/support_event.dart';
import '../../bloc/help/support/support_state.dart';
import '../notification/notification.dart';

class SupportChatScreen extends StatelessWidget {
  final String chatId;

  const SupportChatScreen({
    super.key,
    required this.chatId,
  });

  @override
  Widget build(BuildContext context) {
    final repository = SupportRepositoryImpl(
      SupportRemoteDataSource(
        firestore: FirebaseFirestore.instance,
        auth: FirebaseAuth.instance,
        responder: SupportKeywordResponder(),
      ),
    );

    return BlocProvider<SupportBloc>(
      create: (_) => SupportBloc(
        watchChats: WatchSupportChats(repository),
        watchMessages: WatchSupportMessages(repository),
        createChat: CreateSupportChat(repository),
        sendMessage: SendSupportMessage(repository),
        endChat: EndSupportChat(repository),
      )
        ..add(const LoadSupportChats())
        ..add(OpenSupportChat(chatId)),
      child: _SupportChatView(chatId: chatId),
    );
  }
}

class _SupportChatView extends StatefulWidget {
  final String chatId;

  const _SupportChatView({required this.chatId});

  @override
  State<_SupportChatView> createState() => _SupportChatViewState();
}

class _SupportChatViewState extends State<_SupportChatView> {
  final TextEditingController _messageController =
  TextEditingController();

  final ScrollController _scrollController = ScrollController();

  bool _helpCenterSelected = false;
  bool _endingChat = false;

  bool get isDark =>
      Theme.of(context).brightness == Brightness.dark;

  Color get pageBackground =>
      isDark ? AppColors.darkBackground : AppColors.primaryGreen;

  Color get surface =>
      isDark ? AppColors.darkSurface : AppColors.lightGreen;

  Color get cardColor =>
      isDark ? AppColors.darkCard : AppColors.softGreen;

  Color get textColor =>
      isDark ? AppColors.darkText : AppColors.darkGreen;

  Color get secondaryText =>
      isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText;

  bool _isChatEnded(SupportState state) {
    for (final chat in state.chats) {
      if (chat.id == widget.chatId) {
        return !chat.isActive;
      }
    }
    return false;
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showMessage(String text) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _sendMessage(SupportBloc bloc) {
    final text = _messageController.text.trim();

    if (text.isEmpty || bloc.state.isSending) return;

    if (_isChatEnded(bloc.state)) {
      _showMessage('This chat has ended. Start another chat.');
      return;
    }

    bloc.add(SendSupportMessageEvent(widget.chatId, text));
    _messageController.clear();
  }

  Future<void> _confirmEndChat() async {
    final bloc = context.read<SupportBloc>();

    if (_endingChat || _isChatEnded(bloc.state)) {
      _showMessage('This chat has already ended.');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: surface,
        title: Text(
          'End this chat?',
          style: GoogleFonts.poppins(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
        content: Text(
          'You will not be able to send more messages in this conversation.',
          style: GoogleFonts.poppins(
            color: secondaryText,
            fontSize: 12,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: textColor),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'End Chat',
              style: GoogleFonts.poppins(fontSize: 12),
            ),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;

    setState(() => _endingChat = true);

    // The BLoC updates Firestore and clears selectedChatId on success.
    bloc.add(EndSupportChatEvent(widget.chatId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SupportBloc, SupportState>(
      listenWhen: (previous, current) =>
      previous.errorMessage != current.errorMessage ||
          previous.selectedChatId != current.selectedChatId ||
          previous.messages != current.messages,
      listener: (context, state) {
        final error = state.errorMessage;

        if (error != null && error.isNotEmpty) {
          if (mounted) {
            setState(() => _endingChat = false);
          }
          _showMessage(error);
        }

        // The BLoC clears selectedChatId only after endChat succeeds.
        if (state.selectedChatId == null &&
            _endingChat &&
            state.errorMessage == null) {
          Navigator.of(context).pop();
          return;
        }

        if (state.messages.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
              );
            }
          });
        }
      },
      builder: (context, state) {
        final bloc = context.read<SupportBloc>();
        final chatEnded = _isChatEnded(state);

        return Scaffold(
          backgroundColor: pageBackground,
          body: SafeArea(
            child: Column(
              children: [
                _header(
                  chatEnded: chatEnded,
                  onEndChat: _confirmEndChat,
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      18,
                      16,
                      12,
                    ),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(45),
                      ),
                    ),
                    child: Column(
                      children: [
                        _tabs(),
                        const SizedBox(height: 16),
                        if (chatEnded)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'This conversation has ended. '
                                  'Start another chat to continue.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: textColor,
                              ),
                            ),
                          ),
                        Expanded(
                          child: _helpCenterSelected
                              ? _buildHelpCenter()
                              : _messages(state),
                        ),
                        _composer(
                          state,
                          bloc,
                          chatEnded: chatEnded,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _header({
    required bool chatEnded,
    required VoidCallback onEndChat,
  }) {
    return SizedBox(
      height: 76,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: isDark ? textColor : Colors.white,
              ),
            ),
            Expanded(
              child: Text(
                'Online Support',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? textColor : Colors.white,
                ),
              ),
            ),
            PopupMenuButton<String>(
              tooltip: 'Chat options',
              onSelected: (value) {
                if (value == 'end') {
                  onEndChat();
                } else if (value == 'notifications') {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const NotificationScreen(),
                    ),
                  );
                }
              },
              itemBuilder: (context) => [
                if (!chatEnded)
                  const PopupMenuItem<String>(
                    value: 'end',
                    child: Row(
                      children: [
                        Icon(Icons.close, color: Colors.red),
                        SizedBox(width: 10),
                        Text('End Chat'),
                      ],
                    ),
                  ),
                const PopupMenuItem<String>(
                  value: 'notifications',
                  child: Row(
                    children: [
                      Icon(Icons.notifications_none),
                      SizedBox(width: 10),
                      Text('Notifications'),
                    ],
                  ),
                ),
              ],
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.more_vert,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabs() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          _chatTab(
            title: 'Support Assistant',
            selected: !_helpCenterSelected,
            onTap: () => setState(() => _helpCenterSelected = false),
          ),
          _chatTab(
            title: 'Help Center',
            selected: _helpCenterSelected,
            onTap: () => setState(() => _helpCenterSelected = true),
          ),
        ],
      ),
    );
  }

  Widget _chatTab({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primaryGreen
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: selected ? Colors.white : textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _messages(SupportState state) {
    if (state.isLoading && state.messages.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryGreen,
        ),
      );
    }

    if (state.messages.isEmpty) {
      return Center(
        child: Text(
          'Welcome! How can I help you today?',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: textColor,
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 12),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final message = state.messages[index];
        final isUser = message.isUser;

        final bubbleTextColor = isUser
            ? Colors.white
            : (isDark ? Colors.white : textColor);

        final bubbleColor = isUser
            ? AppColors.primaryGreen
            : cardColor;

        return Align(
          alignment: isUser
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width * 0.72,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    message.text,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      height: 1.4,
                      color: bubbleTextColor,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _formatTime(message.createdAt),
                  style: GoogleFonts.poppins(
                    fontSize: 8,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _iconBox({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 17,
          color: textColor,
        ),
      ),
    );
  }

  Widget _composer(
      SupportState state,
      SupportBloc bloc, {
        required bool chatEnded,
      }) {
    if (chatEnded) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _iconBox(
            icon: Icons.camera_alt_outlined,
            onTap: () => _showMessage(
              'Attachment support is not configured yet.',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 38,
              child: TextField(
                controller: _messageController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(bloc),
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppColors.darkGreen,
                ),
                decoration: InputDecoration(
                  hintText: 'Write Here...',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 10,
                    color: AppColors.lightSecondaryText,
                  ),
                  filled: true,
                  fillColor: AppColors.softGreen,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _iconBox(
            icon: Icons.mic_none,
            onTap: () => _showMessage(
              'Voice messages are not configured yet.',
            ),
          ),
          const SizedBox(width: 6),
          _iconBox(
            icon: Icons.send_outlined,
            onTap: state.isSending
                ? null
                : () => _sendMessage(bloc),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCenter() {
    final helpItems = [
      (
      'Expenses',
      'Review your expense history and record purchases in the Expenses section.',
      ),
      (
      'Budgets',
      'Review your budget and compare planned spending with actual expenses.',
      ),
      (
      'Password and login',
      'Use Forgot Password on the login screen if you cannot sign in.',
      ),
      (
      'Transactions',
      'Open the Transactions or History section to review financial records.',
      ),
      (
      'Account settings',
      'Open Profile or Settings to review the options available to you.',
      ),
    ];

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Text(
          'Help Center',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select a topic to read a quick answer.',
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: secondaryText,
          ),
        ),
        const SizedBox(height: 12),
        for (final item in helpItems)
          Card(
            color: cardColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ExpansionTile(
              shape: const Border(),
              collapsedShape: const Border(),
              iconColor: textColor,
              collapsedIconColor: textColor,
              title: Text(
                item.$1,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              children: [
                Text(
                  item.$2,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    height: 1.5,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
