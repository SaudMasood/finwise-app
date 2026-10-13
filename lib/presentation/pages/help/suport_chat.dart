import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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

  const SupportChatScreen({super.key, required this.chatId});

  static const Color mainGreen = Color(0xFF00D09E);
  static const Color lightGreen = Color(0xFFF1FFF3);
  static const Color softGreen = Color(0xFFDDF5E2);
  static const Color darkGreen = Color(0xFF063F3F);

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
      )..add(OpenSupportChat(chatId)),
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
  static const Color mainGreen = SupportChatScreen.mainGreen;
  static const Color lightGreen = SupportChatScreen.lightGreen;
  static const Color softGreen = SupportChatScreen.softGreen;
  static const Color darkGreen = SupportChatScreen.darkGreen;

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _helpCenterSelected = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(SupportBloc bloc) {
    final text = _messageController.text.trim();

    if (text.isEmpty || bloc.state.isSending) return;

    bloc.add(SendSupportMessageEvent(widget.chatId, text));
    _messageController.clear();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SupportBloc, SupportState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
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

        return Scaffold(
          backgroundColor: mainGreen,
          body: SafeArea(
            child: Column(
              children: [
                _header(),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
                    decoration: const BoxDecoration(
                      color: lightGreen,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(45),
                      ),
                    ),
                    child: Column(
                      children: [
                        _tabs(),
                        const SizedBox(height: 16),
                        Expanded(
                          child: _helpCenterSelected
                              ? _buildHelpCenter()
                              : _messages(state),
                        ),
                        _composer(state, bloc),
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

  Widget _header() {
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Online Support',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: darkGreen,
                    ),
                  ),
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: lightGreen,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const NotificationScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.notifications_none,
                    size: 20,
                    color: darkGreen,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabs() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: softGreen,
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
            color: selected ? mainGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: darkGreen,
            ),
          ),
        ),
      ),
    );
  }

  Widget _messages(SupportState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator(color: mainGreen));
    }

    if (state.messages.isEmpty) {
      return Center(
        child: Text(
          'Welcome! How can I help you today?',
          style: GoogleFonts.poppins(fontSize: 12, color: darkGreen),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 12),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final message = state.messages[index];

        return Align(
          alignment:
          message.isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: message.isUser
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
                    color: message.isUser ? mainGreen : softGreen,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    message.text,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      height: 1.4,
                      color: darkGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _formatTime(message.createdAt),
                  style: GoogleFonts.poppins(fontSize: 8, color: darkGreen),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _iconBox({required IconData icon, required VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: lightGreen,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: darkGreen),
      ),
    );
  }

  Widget _composer(SupportState state, SupportBloc bloc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: mainGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _iconBox(
            icon: Icons.camera_alt_outlined,
            onTap: () => _showMessage('Attachment support is not configured yet.'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 32,
              child: TextField(
                controller: _messageController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(bloc),
                style: GoogleFonts.poppins(fontSize: 11, color: darkGreen),
                decoration: InputDecoration(
                  hintText: 'Write Here...',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 9,
                    color: Colors.grey.shade600,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
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
            onTap: () => _showMessage('Voice messages are not configured yet.'),
          ),
          const SizedBox(width: 6),
          _iconBox(
            icon: Icons.send_outlined,
            onTap: state.isSending ? null : () => _sendMessage(bloc),
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
            color: darkGreen,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select a topic to read a quick answer.',
          style: GoogleFonts.poppins(fontSize: 11, color: darkGreen),
        ),
        const SizedBox(height: 12),
        for (final item in helpItems)
          Card(
            color: softGreen,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ExpansionTile(
              shape: const Border(),
              collapsedShape: const Border(),
              title: Text(
                item.$1,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: darkGreen,
                ),
              ),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              children: [
                Text(
                  item.$2,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    height: 1.5,
                    color: darkGreen,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}