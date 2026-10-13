import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finwise/presentation/pages/help/suport_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/datasources/support_datasorce.dart';
import '../../../data/repositories/help/support_repo_impl.dart';
import '../../../domain/entities/help/support_chat.dart';
import '../../../domain/usecases/help/get_support.dart';
import '../../../domain/usecases/help/support_keyword_response.dart';
import '../../bloc/help/support/support_bloc.dart';
import '../../bloc/help/support/support_event.dart';
import '../../bloc/help/support/support_state.dart';
import '../notification/notification.dart';

class OnlineSupportScreen extends StatelessWidget {
  const OnlineSupportScreen({super.key});

  static const Color green = Color(0xFF00D09E);
  static const Color background = Color(0xFFF1FFF3);
  static const Color cardGreen = Color(0xFFDDF5E2);
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
      )..add(const LoadSupportChats()),
      child: const _SupportHistoryView(),
    );
  }
}

class _SupportHistoryView extends StatelessWidget {
  const _SupportHistoryView();

  static const Color green = OnlineSupportScreen.green;
  static const Color background = OnlineSupportScreen.background;
  static const Color cardGreen = OnlineSupportScreen.cardGreen;
  static const Color darkGreen = OnlineSupportScreen.darkGreen;

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: green,
          body: SafeArea(
            child: Column(
              children: [
                _header(context),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                    decoration: const BoxDecoration(
                      color: background,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(45),
                      ),
                    ),
                    child: state.isLoading
                        ? const Center(
                      child: CircularProgressIndicator(color: green),
                    )
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle('Active Chats'),
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              for (final chat
                              in state.chats.where((c) => c.isActive))
                                _chatTile(context, chat),
                              const SizedBox(height: 14),
                              _sectionTitle('Ended Chats'),
                              for (final chat in state.chats
                                  .where((c) => !c.isActive))
                                _chatTile(context, chat),
                              if (state.chats.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 24,
                                  ),
                                  child: Text(
                                    'No chats yet. Start a new chat!',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: darkGreen,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: SizedBox(
                            width: 165,
                            height: 38,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: green,
                                foregroundColor: darkGreen,
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

  Widget _header(BuildContext context) {
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
                  color: background,
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

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: darkGreen,
        ),
      ),
    );
  }

  Widget _chatTile(BuildContext context, SupportChat chat) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
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
          color: cardGreen,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: green,
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.support_agent,
                size: 26,
                color: darkGreen,
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
                      color: darkGreen,
                    ),
                  ),
                  Text(
                    chat.preview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: 10, color: darkGreen),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}