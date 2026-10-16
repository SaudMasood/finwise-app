
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
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

  static const List<String> categories = [
    'General',
    'Account',
    'Services',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FaqBloc>(
      create: (_) => FaqBloc(
        GetHelpContentUseCase(
          HelpRepositoryImpl(HelpRemoteDataSource()),
        ),
      )..add(LoadHelpContent()),
      child: const _FaqContactView(),
    );
  }
}

class _FaqContactView extends StatelessWidget {
  const _FaqContactView();

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
    final fieldColor = isDark
        ? AppColors.darkSearchField
        : AppColors.softGreen;
    final textColor = isDark
        ? AppColors.darkText
        : AppColors.darkGreen;
    final secondaryText = isDark
        ? AppColors.darkSecondaryText
        : AppColors.lightSecondaryText;
    final dividerColor = isDark
        ? AppColors.darkDivider
        : AppColors.lightDivider;

    return BlocBuilder<FaqBloc, FaqState>(
      builder: (context, state) {
        final bloc = context.read<FaqBloc>();

        return Scaffold(
          backgroundColor: background,
          body: SafeArea(
            child: Column(
              children: [
                _header(
                  context,
                  isDark: isDark,
                  surface: surface,
                  textColor: textColor,
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(45),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(
                        22, 26, 22, 28,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'How Can We Help You?',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _mainTabs(
                            state,
                            bloc,
                            isDark: isDark,
                            fieldColor: fieldColor,
                            textColor: textColor,
                          ),
                          const SizedBox(height: 8),
                          _categoryTabs(
                            state,
                            bloc,
                            isDark: isDark,
                            fieldColor: fieldColor,
                            textColor: textColor,
                          ),
                          const SizedBox(height: 8),
                          _searchField(
                            bloc,
                            fieldColor: fieldColor,
                            textColor: textColor,
                            secondaryText: secondaryText,
                            borderColor: dividerColor,
                          ),
                          const SizedBox(height: 18),
                          if (state.isLoading)
                            const Padding(
                              padding: EdgeInsets.all(25),
                              child: CircularProgressIndicator(
                                color: AppColors.primaryGreen,
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
                                    color: AppColors.error,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      bloc.add(LoadHelpContent()),
                                  child: const Text('Retry'),
                                ),
                              ],
                            )
                          else if (!state.isContact)
                              _buildFaqs(
                                state,
                                bloc,
                                isDark: isDark,
                                textColor: textColor,
                                fieldColor: fieldColor,
                              )
                            else
                              _buildContacts(
                                context,
                                state,
                                isDark: isDark,
                                textColor: textColor,
                                fieldColor: fieldColor,
                              ),
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

  Widget _header(
      BuildContext context, {
        required bool isDark,
        required Color surface,
        required Color textColor,
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
                  'Help & FAQs',
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

  Widget _mainTabs(
      FaqState state,
      FaqBloc bloc, {
        required bool isDark,
        required Color fieldColor,
        required Color textColor,
      }) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _tab(
            title: 'FAQ',
            selected: !state.isContact,
            onTap: () => bloc.add(ChangeHelpTab(false)),
            isDark: isDark,
            textColor: textColor,
          ),
          _tab(
            title: 'Contact Us',
            selected: state.isContact,
            onTap: () => bloc.add(ChangeHelpTab(true)),
            isDark: isDark,
            textColor: textColor,
          ),
        ],
      ),
    );
  }

  Widget _tab({
    required String title,
    required bool selected,
    required VoidCallback onTap,
    required bool isDark,
    required Color textColor,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primaryGreen
                : Colors.transparent,
            borderRadius: BorderRadius.circular(13),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: selected
                  ? Colors.white
                  : textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryTabs(
      FaqState state,
      FaqBloc bloc, {
        required bool isDark,
        required Color fieldColor,
        required Color textColor,
      }) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          for (final category in FaqContactScreen.categories)
            Expanded(
              child: GestureDetector(
                onTap: () =>
                    bloc.add(ChangeHelpCategory(category)),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: state.selectedCategory == category
                        ? AppColors.primaryGreen
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    category,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: state.selectedCategory == category
                          ? Colors.white
                          : textColor,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _searchField(
      FaqBloc bloc, {
        required Color fieldColor,
        required Color textColor,
        required Color secondaryText,
        required Color borderColor,
      }) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: fieldColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        onChanged: (value) =>
            bloc.add(SearchHelpContent(value)),
        style: GoogleFonts.poppins(
          fontSize: 11,
          color: textColor,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            size: 19,
            color: secondaryText,
          ),
          hintText: 'Search',
          hintStyle: GoogleFonts.poppins(
            fontSize: 10,
            color: secondaryText,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  Widget _buildFaqs(
      FaqState state,
      FaqBloc bloc, {
        required bool isDark,
        required Color textColor,
        required Color fieldColor,
      }) {
    final faqs = state.filteredFaqs;

    if (faqs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'No questions found.',
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: textColor,
          ),
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
                  onTap: () =>
                      bloc.add(ToggleFaq(faq.question)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            faq.question,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                        ),
                        Icon(
                          state.openedQuestion == faq.question
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 24,
                          color: textColor,
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
                      color: fieldColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      faq.answer,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        height: 1.6,
                        color: textColor,
                      ),
                    ),
                  ),
                Divider(
                  height: 1,
                  color: isDark
                      ? AppColors.darkDivider
                      : AppColors.lightDivider,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildContacts(
      BuildContext context,
      FaqState state, {
        required bool isDark,
        required Color textColor,
        required Color fieldColor,
      }) {
    if (state.filteredContacts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'No contact options found.',
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: textColor,
          ),
        ),
      );
    }

    return Column(
      children: [
        for (final contact in state.filteredContacts)
          _contactRow(
            context,
            contact,
            textColor: textColor,
            fieldColor: fieldColor,
          ),
      ],
    );
  }

  Widget _contactRow(
      BuildContext context,
      ContactOption contact, {
        required Color textColor,
        required Color fieldColor,
      }) {
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
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 19,
                color: AppColors.darkGreen,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                contact.title,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 24,
              color: textColor,
            ),
          ],
        ),
      ),
    );
  }
}
