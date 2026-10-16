import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
import '../../../data/datasources/saving.dart';
import '../../../data/repositories/saving/saving_repo_imp.dart';
import '../../../domain/usecases/saving/add_saving_category_usecase.dart';
import '../../../domain/usecases/saving/add_saving_usecase.dart';
import '../../../domain/usecases/saving/get _saving_usecas.dart';
import '../../../domain/usecases/saving/get_saving_goal_usecase.dart';
import '../../../domain/usecases/saving/get_savings_categories_usecase.dart';
import '../../bloc/saving/saving_bloc.dart';
import '../../bloc/saving/saving_event.dart';
import '../../bloc/saving/saving_state.dart';
import 'saving_category_screen.dart';

class SavingsScreen extends StatelessWidget {
  final double totalBalance;
  final double totalExpense;
  final double totalIncome;
  final VoidCallback onBack;

  const SavingsScreen({
    super.key,
    required this.totalBalance,
    required this.totalExpense,
    required this.totalIncome,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final dataSource = SavingsDataSource(
      firestore: FirebaseFirestore.instance,
      firebaseAuth: FirebaseAuth.instance,
    );

    final repository = SavingsRepositoryImpl(
      dataSource: dataSource,
    );

    return BlocProvider(
      create: (_) => SavingsBloc(
        getSavingsUseCase: GetSavingsUseCase(
          repository: repository,
        ),
        getSavingsCategoriesUseCase: GetSavingsCategoriesUseCase(
          repository: repository,
        ),
        getSavingGoalUseCase: GetSavingGoalUseCase(
          repository: repository,
        ),
        addSavingUseCase: AddSavingUseCase(
          repository: repository,
        ),
        addSavingCategoryUseCase: AddSavingCategoryUseCase(
          repository: repository,
        ),
      )..add(const LoadSavingsCategories()),
      child: SavingsView(
        totalBalance: totalBalance,
        totalExpense: totalExpense,
        totalIncome: totalIncome,
        onBack: onBack,
      ),
    );
  }
}

class SavingsView extends StatefulWidget {
  final double totalBalance;
  final double totalExpense;
  final double totalIncome;
  final VoidCallback onBack;

  const SavingsView({
    super.key,
    required this.totalBalance,
    required this.totalExpense,
    required this.totalIncome,
    required this.onBack,
  });

  @override
  State<SavingsView> createState() => _SavingsViewState();
}

class _SavingsViewState extends State<SavingsView> {
  int selectedIndex = 0;

  bool get isDark =>
      Theme.of(context).brightness == Brightness.dark;

  Color get backgroundColor =>
      isDark ? AppColors.darkBackground : AppColors.primaryGreen;

  Color get headerTextColor =>
      isDark ? AppColors.darkText : AppColors.darkGreen;

  Color get panelColor =>
      isDark ? AppColors.darkSurface : AppColors.lightGreen;

  Color get cardTextColor =>
      isDark ? AppColors.darkText : AppColors.darkGreen;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.width / 375).clamp(0.85, 1.15);

    double percentage = 0;

    if (widget.totalIncome > 0) {
      percentage =
          (widget.totalExpense / widget.totalIncome) * 100;
    }

    percentage = percentage.clamp(0.0, 100.0);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(height: 14 * scale),

            // Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 25 * scale,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onBack,
                    child: Icon(
                      Icons.arrow_back,
                      color: headerTextColor,
                      size: 26 * scale,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Savings',
                        style: GoogleFonts.poppins(
                          fontSize: 18 * scale,
                          fontWeight: FontWeight.w600,
                          color: headerTextColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 32 * scale,
                    height: 32 * scale,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkCard
                          : AppColors.lightGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_none,
                      color: headerTextColor,
                      size: 20 * scale,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 22 * scale),

            // Summary
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 30 * scale,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _summaryItem(
                      scale: scale,
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'Total Balance',
                      value:
                      '\$${widget.totalBalance.toStringAsFixed(2)}',
                      valueColor:
                      isDark ? AppColors.darkText : AppColors.white,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 42 * scale,
                    color: isDark
                        ? AppColors.darkDivider
                        : AppColors.white,
                  ),
                  SizedBox(width: 16 * scale),
                  Expanded(
                    child: _summaryItem(
                      scale: scale,
                      icon: Icons.check_box_outlined,
                      label: 'Total Expense',
                      value:
                      '-\$${widget.totalExpense.toStringAsFixed(2)}',
                      valueColor: isDark
                          ? AppColors.calendarBlue
                          : AppColors.strongBlue,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12 * scale),

            // Expense progress
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 30 * scale,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final totalWidth = constraints.maxWidth;
                  final height = 26 * scale;

                  final fillWidth =
                      totalWidth * percentage / 100;

                  final amountOnDark =
                      fillWidth > totalWidth - 110 * scale;

                  return Container(
                    width: double.infinity,
                    height: height,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkCard
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          AnimatedContainer(
                            duration:
                            const Duration(milliseconds: 500),
                            curve: Curves.easeOut,
                            width: fillWidth,
                            height: height,
                            padding: EdgeInsets.only(
                              left: 12 * scale,
                            ),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.lightGreen
                                  : AppColors.darkGreen,
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                            child: percentage > 0
                                ? Text(
                              '${percentage.toStringAsFixed(0)}%',
                              style: GoogleFonts.poppins(
                                fontSize: 10 * scale,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? AppColors.darkBackground
                                    : AppColors.white,
                              ),
                            )
                                : const SizedBox.shrink(),
                          ),
                          Positioned(
                            right: 14 * scale,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: Text(
                                '\$${widget.totalIncome.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 10 * scale,
                                  fontWeight: FontWeight.w600,
                                  color: amountOnDark
                                      ? (isDark
                                      ? AppColors.darkBackground
                                      : AppColors.white)
                                      : (isDark
                                      ? AppColors.darkText
                                      : AppColors.darkGreen),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 10 * scale),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 30 * scale,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_box_outlined,
                      size: 14 * scale,
                      color: headerTextColor,
                    ),
                    SizedBox(width: 6 * scale),
                    Flexible(
                      child: Text(
                        '${percentage.toStringAsFixed(0)}% Of Your Expenses, Looks Good.',
                        style: GoogleFonts.poppins(
                          fontSize: 11 * scale,
                          color: headerTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20 * scale),

            // Categories panel
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: panelColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50 * scale),
                    topRight: Radius.circular(50 * scale),
                  ),
                ),
                child: BlocBuilder<SavingsBloc, SavingsState>(
                  builder: (context, state) {
                    if (state.status == SavingsStatus.loading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: isDark
                              ? AppColors.lightGreen
                              : AppColors.primaryGreen,
                        ),
                      );
                    }

                    if (state.status == SavingsStatus.failure) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(24 * scale),
                          child: Text(
                            state.errorMessage ??
                                'Something went wrong',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 12 * scale,
                              color: cardTextColor,
                            ),
                          ),
                        ),
                      );
                    }

                    final categories = state.savingCategories;

                    if (categories.isEmpty) {
                      return Column(
                        children: [
                          const Spacer(),
                          Icon(
                            Icons.savings_outlined,
                            size: 48 * scale,
                            color: isDark
                                ? AppColors.darkSecondaryText
                                : AppColors.darkGreen,
                          ),
                          SizedBox(height: 10 * scale),
                          Text(
                            'No saving categories yet',
                            style: GoogleFonts.poppins(
                              fontSize: 13 * scale,
                              color: cardTextColor,
                            ),
                          ),
                          const Spacer(),
                          _addMoreButton(context, scale),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: GridView.builder(
                            physics:
                            const BouncingScrollPhysics(),
                            padding: EdgeInsets.fromLTRB(
                              35 * scale,
                              30 * scale,
                              35 * scale,
                              10 * scale,
                            ),
                            itemCount: categories.length,
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 16 * scale,
                              mainAxisSpacing: 22 * scale,
                              childAspectRatio: 0.82,
                            ),
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              final isSelected =
                                  selectedIndex == index;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });

                                  final bloc =
                                  context.read<SavingsBloc>();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          BlocProvider.value(
                                            value: bloc,
                                            child: SavingCategoryScreen(
                                              categoryName: category,
                                            ),
                                          ),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      width: 80 * scale,
                                      height: 80 * scale,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.strongBlue
                                            : (isDark
                                            ? AppColors.darkCard
                                            : AppColors.blue),
                                        borderRadius:
                                        BorderRadius.circular(
                                          20 * scale,
                                        ),
                                        border: isDark && isSelected
                                            ? Border.all(
                                          color: AppColors
                                              .calendarBlue,
                                        )
                                            : null,
                                      ),
                                      child: Icon(
                                        _icon(category),
                                        color: isDark && !isSelected
                                            ? AppColors.darkText
                                            : AppColors.white,
                                        size: 44 * scale,
                                      ),
                                    ),
                                    SizedBox(height: 6 * scale),
                                    Text(
                                      category,
                                      maxLines: 1,
                                      overflow:
                                      TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12 * scale,
                                        fontWeight: FontWeight.w500,
                                        color: cardTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        _addMoreButton(context, scale),
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

  Widget _addMoreButton(BuildContext context, double scale) {
    return GestureDetector(
      onTap: () => _showAddSavingCategoryDialog(context),
      child: Container(
        width: 120 * scale,
        height: 34 * scale,
        margin: EdgeInsets.only(bottom: 24 * scale),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkCard
              : AppColors.primaryGreen,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            'Add More',
            style: GoogleFonts.poppins(
              fontSize: 11 * scale,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.darkText
                  : AppColors.darkGreen,
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryItem({
    required double scale,
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 4 * scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 12 * scale,
                color: headerTextColor,
              ),
              SizedBox(width: 4 * scale),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 11 * scale,
                    color: headerTextColor,
                  ),
                ),
              ),
            ],
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 22 * scale,
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static IconData _icon(String category) {
    final name = category.toLowerCase();

    if (name.contains('travel')) {
      return Icons.flight_outlined;
    }

    if (name.contains('house')) {
      return Icons.home_work_outlined;
    }

    if (name.contains('car')) {
      return Icons.directions_car_outlined;
    }

    if (name.contains('wedding')) {
      return Icons.celebration_outlined;
    }

    return Icons.savings_outlined;
  }

  void _showAddSavingCategoryDialog(BuildContext context) {
    final nameController = TextEditingController();
    final goalController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final darkMode =
            Theme.of(dialogContext).brightness == Brightness.dark;

        final dialogBackground = darkMode
            ? AppColors.darkSurface
            : AppColors.white;
        final textColor = darkMode
            ? AppColors.darkText
            : AppColors.darkGreen;
        final fieldColor = darkMode
            ? AppColors.darkSearchField
            : AppColors.softGreen;

        return AlertDialog(
          backgroundColor: dialogBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Add Saving Category',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Category name',
                  hintStyle: TextStyle(
                    color: darkMode
                        ? AppColors.darkSecondaryText
                        : AppColors.darkGreen.withValues(alpha: 0.6),
                  ),
                  filled: true,
                  fillColor: fieldColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: goalController,
                keyboardType:
                const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Goal amount',
                  hintStyle: TextStyle(
                    color: darkMode
                        ? AppColors.darkSecondaryText
                        : AppColors.darkGreen.withValues(alpha: 0.6),
                  ),
                  filled: true,
                  fillColor: fieldColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: SizedBox(
                width: 150,
                height: 35,
                child: ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final goal =
                        double.tryParse(goalController.text.trim()) ??
                            0;

                    if (name.isEmpty) {
                      return;
                    }

                    context.read<SavingsBloc>().add(
                      AddSavingCategory(
                        name: name,
                        goal: goal,
                      ),
                    );

                    Navigator.pop(dialogContext);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: AppColors.darkGreen,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ).then((_) {
      nameController.dispose();
      goalController.dispose();
    });
  }
}