
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

class _SupportHistoryView extends StatelessWidget {
  const _SupportHistoryView();

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final background = isDark
        ? AppColors.darkBackground
        : AppColors.primaryGreen;
    final surface = isDark
        ? AppColors.darkSurface
        : AppColors.lightGreen;
    final cardColor = isDark
        ? AppColors.darkCard
        : AppColors.softGreen;
    final textColor = isDark
        ? AppColors.darkText
        : AppColors.darkGreen;
    final secondaryText = isDark
        ? AppColors.darkSecondaryText
        : AppColors.lightSecondaryText;

    return BlocConsumer<SupportBloc, SupportState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }

        if (state.selectedChatId != null) {
          final chatId = state.selectedChatId!;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;

            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => SupportChatScreen(chatId: chatId),
              ),
            );
          });
        }
      },
      builder: (context, state) {
        final bloc = context.read<SupportBloc>();

        return Scaffold(
          backgroundColor: background,
          body: SafeArea(
            child: Column(
              children: [
                _header(
                  context,
                  isDark: isDark,
                  textColor: textColor,
                  surface: surface,
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(
                      24, 28, 24, 20,
                    ),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(45),
                      ),
                    ),
                    child: state.isLoading
                        ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryGreen,
                      ),
                    )
                        : Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        _sectionTitle(
                          'Active Chats',
                          textColor,
                        ),
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              for (final chat
                              in state.chats.where(
                                    (c) => c.isActive,
                              ))
                                _chatTile(
                                  context,
                                  chat,
                                  cardColor: cardColor,
                                  iconBackground: background,
                                  textColor: textColor,
                                  secondaryText: secondaryText,
                                ),
                              const SizedBox(height: 14),
                              _sectionTitle(
                                'Ended Chats',
                                textColor,
                              ),
                              for (final chat
                              in state.chats.where(
                                    (c) => !c.isActive,
                              ))
                                _chatTile(
                                  context,
                                  chat,
                                  cardColor: cardColor,
                                  iconBackground: background,
                                  textColor: textColor,
                                  secondaryText: secondaryText,
                                ),
                              if (state.chats.isEmpty)
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(
                                    vertical: 24,
                                  ),
                                  child: Text(
                                    'No chats yet. Start a new chat!',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: secondaryText,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: SizedBox(
                            width: 175,
                            height: 42,
                            child: ElevatedButton(
                              style:
                              ElevatedButton.styleFrom(
                                backgroundColor:
                                AppColors.primaryGreen,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: const StadiumBorder(),
                              ),
                              onPressed: () {
                                bloc.add(
                                  const CreateNewSupportChat(
                                    'Support Assistant',
                                  ),
                                );
                              },
                              child: Text(
                                'Start Another Chat',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
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

  Widget _header(
      BuildContext context, {
        required bool isDark,
        required Color textColor,
        required Color surface,
      }) {
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
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
              child: Center(
                child: Text(
                  'Online Support',
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: isDark ? textColor : Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: surface,
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
                icon: Icon(
                  Icons.notifications_none,
                  size: 20,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _chatTile(
      BuildContext context,
      SupportChat chat, {
        required Color cardColor,
        required Color iconBackground,
        required Color textColor,
        required Color secondaryText,
      }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        if (!chat.isActive) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'This chat has ended. Start another chat to continue.',
              ),
            ),
          );
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => SupportChatScreen(chatId: chat.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.support_agent,
                size: 26,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.title,
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  Text(
                    chat.preview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: secondaryText,
            ),
          ],
        ),
      ),
    );
  }
}
