
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
import '../../../data/datasources/serchtransctiondatas.dart';
import '../../../data/repositories/analytics/serchtransrepo.dart';
import '../../../domain/usecases/analytics/serchtra.dart';
import '../../bloc/analytics/serchtrans_bloc.dart';
import '../../bloc/analytics/serchtrans_event.dart';
import '../../bloc/analytics/serchtrans_state.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataSource = SearchDataSource(
      firestore: FirebaseFirestore.instance,
      firebaseAuth: FirebaseAuth.instance,
    );

    final repository = SearchRepositoryImpl(dataSource: dataSource);
    final useCase = SearchTransactionsUseCase(
      repository: repository,
    );

    return BlocProvider(
      create: (_) => SearchBloc(
        searchTransactionsUseCase: useCase,
      )..add(const LoadSearchData()),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final TextEditingController searchController = TextEditingController();

  String selectedCategory = '';
  String selectedType = 'expense';
  DateTime? selectedDate;

  bool get isDark =>
      Theme.of(context).brightness == Brightness.dark;

  Color get mainGreen => AppColors.primaryGreen;

  Color get lightGreen => isDark
      ? Theme.of(context).colorScheme.surface
      : AppColors.lightBackground;

  Color get softGreen => isDark
      ? Theme.of(context).colorScheme.surfaceContainerHighest
      : AppColors.softGreen;

  Color get darkGreen => isDark
      ? Theme.of(context).colorScheme.onSurface
      : AppColors.darkGreen;

  Color get blue => AppColors.blue;

  Color get strongBlue => AppColors.strongBlue;

  Color get screenBackground => isDark
      ? Theme.of(context).scaffoldBackgroundColor
      : AppColors.primaryGreen;

  Color get searchFieldColor => isDark
      ? AppColors.darkSearchField
      : Colors.white;

  Color get headerTextColor =>
      isDark ? darkGreen : Colors.white;

  Color get buttonTextColor =>
      isDark ? AppColors.darkBackground : AppColors.darkGreen;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        List<String> categories = [];

        if (state is SearchDataLoaded) {
          categories = state.categories;
        }

        if (state is SearchSuccess) {
          categories = state.categories;
        }

        return Scaffold(
          backgroundColor: screenBackground,
          body: SafeArea(
            bottom: true,
            child: Column(
              children: [
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back,
                          color: headerTextColor,
                          size: 28,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Search',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: headerTextColor,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: lightGreen,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications_none,
                          size: 20,
                          color: darkGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: searchFieldColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: searchController,
                      textAlignVertical: TextAlignVertical.center,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkText
                            : AppColors.darkGreen,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkSecondaryText
                              : AppColors.darkGreen.withOpacity(0.6),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: lightGreen,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(
                        32,
                        32,
                        32,
                        32,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Categories'),
                          const SizedBox(height: 8),
                          _buildCategoryField(categories),
                          const SizedBox(height: 24),
                          _buildLabel('Date'),
                          const SizedBox(height: 8),
                          _buildDateField(),
                          const SizedBox(height: 24),
                          _buildLabel('Report'),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _buildRadio('Income', 'income'),
                              const SizedBox(width: 35),
                              _buildRadio('Expense', 'expense'),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                context.read<SearchBloc>().add(
                                  PerformSearch(
                                    searchText: searchController.text,
                                    category: selectedCategory,
                                    date: selectedDate,
                                    type: selectedType,
                                  ),
                                );
                              },
                              child: Container(
                                width: 130,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: mainGreen,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    'Search',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: buttonTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          if (state is SearchLoading)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: CircularProgressIndicator(
                                  color: mainGreen,
                                ),
                              ),
                            ),
                          if (state is SearchFailure)
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Center(
                                child: Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                            ),
                          if (state is SearchSuccess)
                            _buildResults(state),
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: darkGreen,
      ),
    );
  }

  Widget _buildCategoryField(List<String> categories) {
    return GestureDetector(
      onTap: () async {
        if (categories.isEmpty) return;

        final result = await showModalBottomSheet<String>(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (sheetContext) {
            return Container(
              decoration: BoxDecoration(
                color: lightGreen,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SafeArea(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text(
                      'Select Category',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: darkGreen,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ...categories.map(
                          (category) => ListTile(
                        title: Text(
                          category,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: darkGreen,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(sheetContext, category);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );

        if (!mounted) return;

        if (result != null) {
          setState(() => selectedCategory = result);
        }
      },
      child: Container(
        width: double.infinity,
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: softGreen,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedCategory.isEmpty
                    ? 'Select the category'
                    : selectedCategory,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: selectedCategory.isEmpty
                      ? darkGreen.withOpacity(0.5)
                      : darkGreen,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: mainGreen,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
          builder: (context, child) {
            final theme = Theme.of(context);

            return Theme(
              data: theme.copyWith(
                colorScheme: theme.colorScheme.copyWith(
                  primary: mainGreen,
                  surface: lightGreen,
                  onSurface: darkGreen,
                ),
                dialogTheme: DialogThemeData(
                  backgroundColor: lightGreen,
                ),
              ),
              child: child!,
            );
          },
        );

        if (!mounted) return;

        if (date != null) {
          setState(() => selectedDate = date);
        }
      },
      child: Container(
        width: double.infinity,
        height: 38,
        padding: const EdgeInsets.only(left: 16, right: 10),
        decoration: BoxDecoration(
          color: softGreen,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedDate == null
                    ? 'Select date'
                    : _formatDate(selectedDate!),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: darkGreen,
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: mainGreen,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.calendar_month_outlined,
                size: 15,
                color: buttonTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadio(String label, String value) {
    final bool selected = selectedType == value;

    return GestureDetector(
      onTap: () => setState(() => selectedType = value),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: mainGreen,
                width: 1.5,
              ),
            ),
            child: selected
                ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: mainGreen,
                ),
              ),
            )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: darkGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(SearchSuccess state) {
    if (state.results.isEmpty) {
      return Center(
        child: Text(
          'No transactions found',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: darkGreen,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${state.results.length} transaction(s) found',
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: darkGreen,
          ),
        ),
        const SizedBox(height: 14),
        ...state.results.map((transaction) {
          final bool income =
              transaction.type.toLowerCase() == 'income';

          final String time =
              '${transaction.date.hour.toString().padLeft(2, '0')}:'
              '${transaction.date.minute.toString().padLeft(2, '0')}';

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: softGreen,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: blue,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    income
                        ? Icons.layers_outlined
                        : Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: darkGreen,
                        ),
                      ),
                      Text(
                        '$time - ${_monthName(transaction.date.month)} '
                            '${transaction.date.day}',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: strongBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  income
                      ? '+\$${transaction.amount.toStringAsFixed(2)}'
                      : '-\$${transaction.amount.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: income ? darkGreen : strongBlue,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }

  String _formatDate(DateTime date) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];

    return '${date.day.toString().padLeft(2, '0')} / '
        '${months[date.month - 1]} / ${date.year}';
  }
}
