
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
import '../../../data/datasources/categoriesdatasorces.dart';
import '../../../data/repositories/categories/categories_repository_impl.dart';
import '../../../domain/usecases/categories/addcategryusecase.dart';
import '../../../domain/usecases/categories/addexpnseusecse.dart';
import '../../../domain/usecases/categories/addincome.dart';
import '../../../domain/usecases/categories/getcategories_usecase.dart';
import '../../../domain/usecases/categories/getexpenseusecase.dart';
import '../../bloc/categories/categories_bloc.dart';
import '../../bloc/categories/categories_event.dart';
import '../../bloc/categories/categories_state.dart';
import '../notification/notification.dart';
import 'category_expense_page.dart';

class CategoriesScreen extends StatelessWidget {
  final void Function({
  required double totalBalance,
  required double totalExpense,
  required double totalIncome,
  }) onOpenSavings;

  const CategoriesScreen({
    super.key,
    required this.onOpenSavings,
  });

  @override
  Widget build(BuildContext context) {
    final dataSource = CategoryDataSource(
      firestore: FirebaseFirestore.instance,
      firebaseAuth: FirebaseAuth.instance,
    );

    final repository = CategoryRepositoryImpl(
      dataSource: dataSource,
    );

    return BlocProvider<CategoryBloc>(
      create: (_) => CategoryBloc(
        getCategoriesUseCase:
        GetCategoriesUseCase(repository: repository),
        getExpensesUseCase:
        GetExpensesUseCase(repository: repository),
        addCategoryUseCase:
        AddCategoryUseCase(repository: repository),
        addExpenseUseCase:
        AddExpenseUseCase(repository: repository),
        addIncomeUseCase:
        AddIncomeUseCase(repository: repository),
        firebaseAuth: FirebaseAuth.instance,
      )
        ..add(const WatchCategories())
        ..add(const WatchAllTransactions()),
      child: CategoriesView(
        onOpenSavings: onOpenSavings,
      ),
    );
  }
}

class CategoriesView extends StatefulWidget {
  final void Function({
  required double totalBalance,
  required double totalExpense,
  required double totalIncome,
  }) onOpenSavings;

  const CategoriesView({
    super.key,
    required this.onOpenSavings,
  });

  static const mainGreen = AppColors.primaryGreen;
  static const lightGreen = AppColors.lightGreen;
  static const softGreen = AppColors.softGreen;
  static const darkGreen = AppColors.darkGreen;
  static const blue = AppColors.blue;
  static const selectedBlue = AppColors.strongBlue;

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? AppColors.darkBackground
        : CategoriesView.mainGreen;

    final sheetColor = isDark
        ? AppColors.darkSurface
        : CategoriesView.lightGreen;

    final textColor = isDark
        ? AppColors.darkText
        : CategoriesView.darkGreen;

    final secondaryTextColor = isDark
        ? AppColors.darkSecondaryText
        : CategoriesView.darkGreen;

    final trackColor =
    isDark ? Colors.black : AppColors.white;

    final fieldColor = isDark
        ? AppColors.darkSearchField
        : CategoriesView.softGreen;

    return BlocListener<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state.status == CategoryStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Something went wrong',
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
        }

        if (state.status == CategoryStatus.saved &&
            state.savedType == 'category') {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Category added successfully'),
                behavior: SnackBarBehavior.floating,
              ),
            );
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const SizedBox(height: 14),

              // Header
              Row(
                children: [
                  const SizedBox(width: 25),
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: isDark
                          ? AppColors.darkText
                          : AppColors.white,
                      size: 28,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Categories',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkText
                              : CategoriesView.darkGreen,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 34,
                    height: 34,
                    margin: const EdgeInsets.only(right: 25),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkCard
                          : CategoriesView.lightGreen,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const NotificationScreen(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.notifications_none,
                        color: isDark
                            ? AppColors.darkText
                            : CategoriesView.darkGreen,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Balance summary
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _summaryItem(
                            label: 'Total Balance',
                            value:
                            '\$${state.totalBalance.toStringAsFixed(2)}',
                            valueColor: isDark
                                ? AppColors.darkText
                                : AppColors.white,
                            labelColor: secondaryTextColor,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 42,
                          color: isDark
                              ? AppColors.darkDivider
                              : AppColors.white,
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: _summaryItem(
                            label: 'Total Expense',
                            value:
                            '-\$${state.totalExpense.toStringAsFixed(2)}',
                            valueColor:
                            CategoriesView.selectedBlue,
                            labelColor: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 14),

              // Expense progress bar
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  final income = state.totalIncome;
                  final expense = state.totalExpense;

                  final percentage = income > 0
                      ? (expense / income * 100)
                      .clamp(0.0, 100.0)
                      : 0.0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final totalWidth =
                            constraints.maxWidth;
                        const barHeight = 26.0;

                        var fillWidth =
                            totalWidth * percentage / 100;

                        if (fillWidth > 0 && fillWidth < 54) {
                          fillWidth = 54;
                        }

                        if (fillWidth > totalWidth) {
                          fillWidth = totalWidth;
                        }

                        final amountOnGreen =
                            fillWidth > totalWidth - 110;

                        return Container(
                          width: double.infinity,
                          height: barHeight,
                          decoration: BoxDecoration(
                            color: trackColor,
                            borderRadius:
                            BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius:
                            BorderRadius.circular(20),
                            child: Stack(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(
                                    milliseconds: 500,
                                  ),
                                  curve: Curves.easeOut,
                                  width: fillWidth,
                                  height: barHeight,
                                  padding:
                                  const EdgeInsets.only(
                                    left: 12,
                                  ),
                                  alignment:
                                  Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    color:
                                    CategoriesView.darkGreen,
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${percentage.toStringAsFixed(0)}%',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 14,
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: Text(
                                      '\$${income.toStringAsFixed(2)}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight:
                                        FontWeight.w600,
                                        color: amountOnGreen
                                            ? Colors.white
                                            : (isDark
                                            ? Colors.white
                                            : CategoriesView
                                            .darkGreen),
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
                  );
                },
              ),

              const SizedBox(height: 10),

              // Expense percentage message
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  final income = state.totalIncome;

                  final percentage = income > 0
                      ? (state.totalExpense / income * 100)
                      .clamp(0.0, 100.0)
                      : 0.0;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_box_outlined,
                        size: 15,
                        color: isDark
                            ? AppColors.lightGreen
                            : CategoriesView.darkGreen,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          '${percentage.toStringAsFixed(0)}% Of Your Expenses, Looks Good.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.darkText
                                : CategoriesView.darkGreen,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 22),

              // Categories grid
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: sheetColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      final categories = <String>[
                        ...state.categories,
                      ];

                      if (!categories.any(
                            (category) =>
                        category.toLowerCase() == 'saving',
                      )) {
                        categories.add('Saving');
                      }

                      return Stack(
                        children: [
                          GridView.builder(
                            padding: const EdgeInsets.fromLTRB(
                              35,
                              30,
                              35,
                              120,
                            ),
                            itemCount: categories.length + 1,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 22,
                              childAspectRatio: .78,
                            ),
                            itemBuilder: (context, index) {
                              // Add category tile
                              if (index == categories.length) {
                                return GestureDetector(
                                  onTap: () {
                                    _showAddCategoryDialog(
                                      context,
                                      fieldColor,
                                      textColor,
                                      isDark,
                                    );
                                  },
                                  child: _CategoryItem(
                                    icon: Icons.add,
                                    label: 'More',
                                    selected: false,
                                    isDark: isDark,
                                  ),
                                );
                              }

                              final category =
                              categories[index];

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });

                                  if (category.toLowerCase() ==
                                      'saving') {
                                    widget.onOpenSavings(
                                      totalBalance:
                                      state.totalBalance,
                                      totalExpense:
                                      state.totalExpense,
                                      totalIncome:
                                      state.totalIncome,
                                    );
                                    return;
                                  }

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          CategoryExpenseScreen(
                                            categoryName: category,
                                          ),
                                    ),
                                  );
                                },
                                child: _CategoryItem(
                                  icon: _icon(category),
                                  label: category,
                                  selected:
                                  selectedIndex == index,
                                  isDark: isDark,
                                ),
                              );
                            },
                          ),

                          if (state.status ==
                              CategoryStatus.loading &&
                              state.categories.isEmpty)
                            const Center(
                              child: CircularProgressIndicator(),
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
      ),
    );
  }

  Widget _summaryItem({
    required String label,
    required String value,
    required Color valueColor,
    required Color labelColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 12,
                color: labelColor,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: labelColor,
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
                fontSize: 22,
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

    if (name.contains('food')) return Icons.restaurant;

    if (name.contains('transport') || name.contains('travel')) {
      return Icons.directions_bus_outlined;
    }

    if (name.contains('medicine') || name.contains('health')) {
      return Icons.medication_outlined;
    }

    if (name.contains('grocer')) {
      return Icons.shopping_basket_outlined;
    }

    if (name.contains('rent')) return Icons.key_outlined;

    if (name.contains('gift')) {
      return Icons.card_giftcard_outlined;
    }

    if (name.contains('saving')) {
      return Icons.savings_outlined;
    }

    if (name.contains('entertainment') ||
        name.contains('ticket')) {
      return Icons.confirmation_number_outlined;
    }

    if (name.contains('drink')) {
      return Icons.local_bar_outlined;
    }

    if (name.contains('sport') || name.contains('ball')) {
      return Icons.sports_soccer_outlined;
    }

    return Icons.category_outlined;
  }

  void _showAddCategoryDialog(
      BuildContext context,
      Color fieldColor,
      Color textColor,
      bool isDark,
      ) {
    // Capture the existing BLoC before opening the dialog.
    final categoryBloc = context.read<CategoryBloc>();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider<CategoryBloc>.value(
          value: categoryBloc,
          child: _AddCategoryDialog(
            fieldColor: fieldColor,
            textColor: textColor,
            isDark: isDark,
          ),
        );
      },
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final bool isDark;

  const _CategoryItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = isDark
        ? AppColors.darkText
        : CategoriesView.darkGreen;

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: selected
                ? CategoriesView.selectedBlue
                : CategoriesView.blue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: AppColors.white,
            size: 44,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: labelColor,
          ),
        ),
      ],
    );
  }
}

class _AddCategoryDialog extends StatefulWidget {
  final Color fieldColor;
  final Color textColor;
  final bool isDark;

  const _AddCategoryDialog({
    required this.fieldColor,
    required this.textColor,
    required this.isDark,
  });

  @override
  State<_AddCategoryDialog> createState() =>
      _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<_AddCategoryDialog> {
  late final TextEditingController _controller;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveCategory() {
    if (_isSaving) return;

    final name = _controller.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a category name.'),
        ),
      );
      return;
    }

    // This succeeds because the existing CategoryBloc is
    // provided to this dialog by BlocProvider.value.
    final bloc = context.read<CategoryBloc>();

    final exists = bloc.state.categories.any(
          (category) =>
      category.trim().toLowerCase() == name.toLowerCase(),
    );

    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This category already exists.'),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    bloc.add(AddNewCategory(category: name));

    // Close only the dialog route.
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.isDark
          ? AppColors.darkSurface
          : AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Center(
        child: Text(
          'New Category',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: widget.textColor,
          ),
        ),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        enabled: !_isSaving,
        style: TextStyle(color: widget.textColor),
        decoration: InputDecoration(
          hintText: 'Enter category name',
          hintStyle: TextStyle(
            color: widget.isDark
                ? AppColors.darkSecondaryText
                : AppColors.lightSecondaryText,
          ),
          filled: true,
          fillColor: widget.fieldColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
        onSubmitted: (_) => _saveCategory(),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving
              ? null
              : () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(color: widget.textColor),
          ),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _saveCategory,
          style: ElevatedButton.styleFrom(
            backgroundColor: CategoriesView.mainGreen,
            foregroundColor: AppColors.darkGreen,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: _isSaving
              ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          )
              : const Text('Save'),
        ),
      ],
    );
  }
}
