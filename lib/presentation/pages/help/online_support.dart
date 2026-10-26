import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
import '../../../data/datasources/support_datasorce.dart';
import '../../../data/repositories/help/support_repo_impl.dart';
import '../../../domain/entities/help/support_chat.dart';
import '../../../domain/usecases/help/get_support.dart';
import '../../../domain/usecases/help/support_keyword_response.dart';
import '../../bloc/help/support/support_bloc.dart';
import '../../bloc/help/support/support_event.dart';
import '../../bloc/help/support/support_state.dart';
import '../notification/notification.dart';
import 'suport_chat.dart';

class OnlineSupportScreen extends StatelessWidget {
  const OnlineSupportScreen({super.key});

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
      )..add(const LoadSupportChats()),
      child: const _SupportHistoryView(),
    );
  }
}

class _SupportHistoryView extends StatefulWidget {
  const _SupportHistoryView();

  @override
  State<_SupportHistoryView> createState() => _SupportHistoryViewState();
}

class _SupportHistoryViewState extends State<_SupportHistoryView> {
  bool _openingChat = false;
  String? _lastOpenedChatId;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _background =>
      _isDark ? AppColors.darkBackground : AppColors.primaryGreen;

  Color get _surface =>
      _isDark ? AppColors.darkSurface : AppColors.lightGreen;

  Color get _card => _isDark ? AppColors.darkCard : AppColors.softGreen;

  Color get _text => _isDark ? AppColors.darkText : AppColors.darkGreen;

  Color get _secondary =>
      _isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText;

  Color get _accent => AppColors.primaryGreen;

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final chatDay = DateTime(date.year, date.month, date.day);
    final difference = now.difference(date);

    if (difference.isNegative || difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} Min Ago';
    }

    if (chatDay == today) {
      return '${date.hour.toString().padLeft(2, '0')}:'
          '${date.minute.toString().padLeft(2, '0')}';
    }

    if (chatDay == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    }

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    // Figma style: "Feb 08 -2024"
    return '${months[date.month - 1]} '
        '${date.day.toString().padLeft(2, '0')} -${date.year}';
  }

  void _openChat(String chatId) {
    if (!mounted || _openingChat || chatId.isEmpty) return;
    if (_lastOpenedChatId == chatId) return;

    _openingChat = true;
    _lastOpenedChatId = chatId;

    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => SupportChatScreen(chatId: chatId),
      ),
    ).then((_) {
      if (!mounted) return;

      _openingChat = false;
      _lastOpenedChatId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _header(),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 30, 24, 0),
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: BlocConsumer<SupportBloc, SupportState>(
                  listenWhen: (previous, current) =>
                  previous.errorMessage != current.errorMessage ||
                      previous.selectedChatId != current.selectedChatId,
                  listener: (context, state) {
                    final error = state.errorMessage;

                    if (error != null && error.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error)),
                      );
                    }

                    // Open the chat after BLoC creates it.
                    final chatId = state.selectedChatId;

                    if (chatId != null && chatId.isNotEmpty) {
                      _openChat(chatId);
                    }
                  },
                  builder: (context, state) {
                    final activeChats =
                    state.chats.where((chat) => chat.isActive).toList();

                    final endedChats =
                    state.chats.where((chat) => !chat.isActive).toList();

                    if (state.isLoading && state.chats.isEmpty) {
                      return Center(
                        child: CircularProgressIndicator(color: _accent),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: RefreshIndicator(
                            color: _accent,
                            onRefresh: () async {
                              context
                                  .read<SupportBloc>()
                                  .add(const LoadSupportChats());

                              await Future<void>.delayed(
                                const Duration(milliseconds: 400),
                              );
                            },
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              padding: EdgeInsets.zero,
                              children: [
                                _sectionTitle('Active Chats'),
                                const SizedBox(height: 12),
                                if (activeChats.isEmpty)
                                  _emptyState(
                                    Icons.chat_bubble_outline,
                                    'No active chats',
                                    'Start a chat if you need help.',
                                  )
                                else
                                  ...activeChats.map(
                                        (chat) => _chatTile(
                                      chat,
                                      onTap: () => _openChat(chat.id),
                                    ),
                                  ),
                                const SizedBox(height: 26),
                                _sectionTitle('Ended Chats'),
                                const SizedBox(height: 12),
                                if (endedChats.isEmpty)
                                  _emptyState(
                                    Icons.history,
                                    'No previous chats',
                                    'Your completed chats appear here.',
                                  )
                                else
                                  ...endedChats.map(
                                        (chat) => _chatTile(
                                      chat,
                                      onTap: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'This chat has ended. '
                                                  'Start another chat to continue.',
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 8,
                            bottom: MediaQuery.of(context).padding.bottom + 16,
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 170,
                              height: 36,
                              child: ElevatedButton(
                                onPressed: state.isLoading
                                    ? null
                                    : () {
                                  // Create the chat in Firestore.
                                  context.read<SupportBloc>().add(
                                    const CreateNewSupportChat(
                                      'Support Assistant',
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _accent,
                                  foregroundColor: _isDark
                                      ? AppColors.darkBackground
                                      : AppColors.darkGreen,
                                  disabledBackgroundColor:
                                  _accent.withOpacity(0.5),
                                  elevation: 0,
                                  padding: EdgeInsets.zero,
                                  shape: const StadiumBorder(),
                                ),
                                child: state.isLoading
                                    ? SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: _isDark
                                        ? AppColors.darkBackground
                                        : AppColors.darkGreen,
                                  ),
                                )
                                    : Text(
                                  'Start Another Chat',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    final headerColor = _isDark ? _text : AppColors.darkGreen;

    return SizedBox(
      height: 76,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 24,
                color: _isDark ? _text : Colors.white,
              ),
            ),
            Expanded(
              child: Text(
                'Online Support',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: headerColor,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const NotificationScreen(),
                  ),
                );
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: _surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_none_rounded,
                  size: 18,
                  color: _text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: _text,
      ),
    );
  }

  Widget _emptyState(
      IconData icon,
      String title,
      String subtitle,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: _secondary),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: _secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chatTile(
      SupportChat chat, {
        required VoidCallback onTap,
      }) {
    final iconColor = _isDark ? AppColors.darkBackground : AppColors.darkGreen;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: SizedBox(
            height: 50,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(7, 0, 12, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: _accent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.support_agent_rounded,
                          size: 24,
                          color: iconColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chat.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                                color: _text,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Padding(
                              padding: const EdgeInsets.only(right: 70),
                              child: Text(
                                chat.preview.isEmpty
                                    ? 'No messages yet'
                                    : chat.preview,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  height: 1.2,
                                  color: _secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 6,
                  bottom: 5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _surface,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _formatDate(chat.updatedAt),
                      style: GoogleFonts.poppins(
                        fontSize: 8,
                        color: _secondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}