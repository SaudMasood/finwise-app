import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/datasources/faq_contact_hlp.dart';
import '../../../data/repositories/help/faq_contact_repository_impl.dart';
import '../../../domain/entities/home/contact.dart';
import '../../../domain/usecases/help/faq_usecase.dart';
import '../../bloc/help/faq_contact_bloc.dart';
import '../../bloc/help/faq_contact_event.dart.dart';
import '../../bloc/help/faq_contact_state.dart';
import '../notification/notification.dart';
import 'online_support.dart';

class FaqContactScreen extends StatelessWidget {
  const FaqContactScreen({super.key});

  static const Color mainGreen = Color(0xFF00D09E);
  static const Color lightGreen = Color(0xFFF1FFF3);
  static const Color softGreen = Color(0xFFDDF5E2);
  static const Color darkGreen = Color(0xFF063F3F);

  static const List<String> categories = ['General', 'Account', 'Services'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FaqBloc>(
      create: (_) => FaqBloc(
        GetHelpContentUseCase(HelpRepositoryImpl(HelpRemoteDataSource())),
      )..add(LoadHelpContent()),
      child: const _FaqContactView(),
    );
  }
}

class _FaqContactView extends StatelessWidget {
  const _FaqContactView();

  static const Color mainGreen = FaqContactScreen.mainGreen;
  static const Color lightGreen = FaqContactScreen.lightGreen;
  static const Color softGreen = FaqContactScreen.softGreen;
  static const Color darkGreen = FaqContactScreen.darkGreen;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FaqBloc, FaqState>(
      builder: (context, state) {
        final bloc = context.read<FaqBloc>();

        return Scaffold(
          backgroundColor: mainGreen,
          body: SafeArea(
            child: Column(
              children: [
                _header(context),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: lightGreen,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(45),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(22, 26, 22, 28),
                      child: Column(
                        children: [
                          Text(
                            'How Can We Help You?',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: darkGreen,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _mainTabs(state, bloc),
                          const SizedBox(height: 8),
                          _categoryTabs(state, bloc),
                          const SizedBox(height: 8),
                          _searchField(bloc),
                          const SizedBox(height: 18),
                          if (state.isLoading)
                            const Padding(
                              padding: EdgeInsets.all(25),
                              child: CircularProgressIndicator(
                                color: mainGreen,
                              ),
                            )
                          else if (state.errorMessage != null)
                            Column(
                              children: [
                                Text(
                                  state.errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: Colors.red,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => bloc.add(LoadHelpContent()),
                                  child: const Text('Retry'),
                                ),
                              ],
                            )
                          else if (!state.isContact)
                              _buildFaqs(state, bloc)
                            else
                              _buildContacts(context, state),
                        ],
                      ),
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
                    'Help & FAQS',
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

  Widget _mainTabs(FaqState state, FaqBloc bloc) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: softGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _tab(
            title: 'FAQ',
            selected: !state.isContact,
            onTap: () => bloc.add(ChangeHelpTab(false)),
          ),
          _tab(
            title: 'Contact Us',
            selected: state.isContact,
            onTap: () => bloc.add(ChangeHelpTab(true)),
          ),
        ],
      ),
    );
  }

  Widget _tab({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: selected ? mainGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(13),
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

  Widget _categoryTabs(FaqState state, FaqBloc bloc) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: softGreen,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          for (final category in FaqContactScreen.categories)
            Expanded(
              child: GestureDetector(
                onTap: () => bloc.add(ChangeHelpCategory(category)),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: state.selectedCategory == category
                        ? mainGreen
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    category,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: darkGreen,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _searchField(FaqBloc bloc) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: softGreen,
        border: Border.all(color: mainGreen),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        onChanged: (value) => bloc.add(SearchHelpContent(value)),
        style: GoogleFonts.poppins(fontSize: 11, color: darkGreen),
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: GoogleFonts.poppins(fontSize: 10, color: darkGreen),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  Widget _buildFaqs(FaqState state, FaqBloc bloc) {
    final faqs = state.filteredFaqs;

    if (faqs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'No questions found.',
          style: GoogleFonts.poppins(fontSize: 11, color: darkGreen),
        ),
      );
    }

    return Column(
      children: [
        for (final faq in faqs)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => bloc.add(ToggleFaq(faq.question)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            faq.question,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                              color: darkGreen,
                            ),
                          ),
                        ),
                        Icon(
                          state.openedQuestion == faq.question
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 24,
                          color: darkGreen,
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.openedQuestion == faq.question)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 7),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: softGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      faq.answer,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        height: 1.6,
                        color: darkGreen,
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildContacts(BuildContext context, FaqState state) {
    if (state.filteredContacts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'No contact options found.',
          style: GoogleFonts.poppins(fontSize: 11, color: darkGreen),
        ),
      );
    }

    return Column(
      children: [
        for (final contact in state.filteredContacts)
          _contactRow(context, contact),
      ],
    );
  }

  Widget _contactRow(BuildContext context, ContactOption contact) {
    final icon = switch (contact.type) {
      'customer_service' => Icons.support_agent,
      'website' => Icons.language,
      'facebook' => Icons.facebook,
      'whatsapp' => Icons.chat,
      'instagram' => Icons.camera_alt_outlined,
      _ => Icons.contact_support_outlined,
    };

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        if (contact.type == 'customer_service') {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const OnlineSupportScreen(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${contact.title} link has not been configured yet.',
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: mainGreen,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, size: 18, color: darkGreen),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                contact.title,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: darkGreen,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 24, color: darkGreen),
          ],
        ),
      ),
    );
  }
}