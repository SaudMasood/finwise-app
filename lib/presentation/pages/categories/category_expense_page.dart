
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
import 'add_expense_page.dart';
import 'addincome.dart';

const green = AppColors.primaryGreen;
const lightGreen = AppColors.lightGreen;
const softGreen = AppColors.softGreen;
const dark = AppColors.darkGreen;
const blue = AppColors.strongBlue;
const lightBlue = AppColors.blue;

class CategoryExpenseScreen extends StatelessWidget {
  final String categoryName;

  const CategoryExpenseScreen({
    super.key,
    required this.categoryName,
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

    return BlocProvider(
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
      )..add(
        WatchCategoryTransactions(category: categoryName),
      ),
      child: CategoryExpenseView(
        categoryName: categoryName,
      ),
    );
  }
}

class CategoryExpenseView extends StatelessWidget {
  final String categoryName;

  const CategoryExpenseView({
    super.key,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final backgroundColor =
    isDark ? AppColors.darkBackground : green;
    final sheetColor =
    isDark ? AppColors.darkSurface : lightGreen;
    final textColor =
    isDark ? AppColors.darkText : dark;
    final secondaryTextColor =
    isDark ? AppColors.darkSecondaryText : dark;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context, isDark, textColor),
            const SizedBox(height: 20),
            _summary(
              isDark,
              textColor,
              secondaryTextColor,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: sheetColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(45),
                  ),
                ),
                child: _sheet(
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(
      BuildContext context,
      bool isDark,
      Color textColor,
      ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: isDark ? AppColors.darkText : AppColors.white,
              size: 27,
            ),
          ),
          Expanded(
            child: Text(
              categoryName,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
          CircleAvatar(
            radius: 16,
            backgroundColor:
            isDark ? AppColors.darkCard : lightGreen,
            child: Icon(
              Icons.notifications_none,
              color: textColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summary(
      bool isDark,
      Color textColor,
      Color secondaryTextColor,
      ) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        final income = state.totalIncome;
        final expense = state.totalExpense;
        final balance = income - expense;

        final percent = income > 0
            ? (expense / income * 100).clamp(0.0, 100.0)
            : 0.0;

        final darkFlex =
        percent.clamp(15.0, 85.0).toInt();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _amountColumn(
                      'Total Balance',
                      '\$${balance.toStringAsFixed(2)}',
                      isDark ? AppColors.darkText : AppColors.white,
                      secondaryTextColor,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 45,
                    color: isDark
                        ? AppColors.darkDivider
                        : AppColors.white,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _amountColumn(
                      'Total Expense',
                      '-\$${expense.toStringAsFixed(2)}',
                      blue,
                      secondaryTextColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Progress bar: green fill, black dark-mode
              // track, and white amount text in dark mode.
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 28,
                  child: Row(
                    children: [
                      Expanded(
                        flex: darkFlex,
                        child: Container(
                          color: dark,
                          alignment: Alignment.center,
                          child: Text(
                            '${percent.toStringAsFixed(0)}%',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 100 - darkFlex,
                        child: Container(
                          color: isDark
                              ? Colors.black
                              : Colors.white,
                          alignment: Alignment.centerRight,
                          padding:
                          const EdgeInsets.only(right: 12),
                          child: Text(
                            '\$${income.toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.darkGreen,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.check_box_outlined,
                    size: 16,
                    color: isDark
                        ? AppColors.lightGreen
                        : dark,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${percent.toStringAsFixed(0)}% Of Your Expenses, Looks Good.',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _amountColumn(
      String title,
      String amount,
      Color amountColor,
      Color labelColor,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: labelColor,
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            amount,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: amountColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _sheet(
      bool isDark,
      Color textColor,
      Color secondaryTextColor,
      ) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state.status == CategoryStatus.failure) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                state.errorMessage ?? 'Something went wrong',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: textColor,
                ),
              ),
            ),
          );
        }

        final transactions = state.transactions;

        return Column(
          children: [
            Expanded(
              child: transactions.isEmpty
                  ? Center(
                child: Text(
                  state.status == CategoryStatus.loading
                      ? 'Loading transactions...'
                      : 'No transactions found',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: textColor,
                  ),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  30,
                  25,
                  30,
                  10,
                ),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  final isIncome =
                      transaction.type == 'income';

                  final showMonth = index == 0 ||
                      transactions[index - 1].date.month !=
                          transaction.date.month ||
                      transactions[index - 1].date.year !=
                          transaction.date.year;

                  return Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      if (showMonth)
                        _monthTitle(
                          transaction.date,
                          index == 0,
                          isDark,
                          textColor,
                        ),
                      _transactionRow(
                        transaction,
                        isIncome,
                        isDark,
                        textColor,
                        secondaryTextColor,
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                30,
                5,
                30,
                25,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _greenButton(
                      'Add Expenses',
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddExpenseScreen(
                              categoryName: categoryName,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _greenButton(
                      'Add Income',
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddIncomeScreen(
                              categoryName: categoryName,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _monthTitle(
      DateTime date,
      bool showCalendarIcon,
      bool isDark,
      Color textColor,
      ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
        top: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('MMMM yyyy').format(date),
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          if (showCalendarIcon)
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.calendar_month_outlined,
                color: dark,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }

  Widget _transactionRow(
      dynamic transaction,
      bool isIncome,
      bool isDark,
      Color textColor,
      Color secondaryTextColor,
      ) {
    final amountColor = isIncome
        ? (isDark ? AppColors.lightGreen : dark)
        : blue;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isIncome ? green : lightBlue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              isIncome
                  ? Icons.arrow_upward
                  : Icons.directions_bus_outlined,
              color: AppColors.white,
            ),
          ),
          const SizedBox(width: 14),
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
                    color: textColor,
                  ),
                ),
                Text(
                  DateFormat('HH:mm - MMMM dd')
                      .format(transaction.date),
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${isIncome ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _greenButton(
      String text,
      VoidCallback onTap,
      ) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: green,
        foregroundColor: AppColors.darkGreen,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 12),
      ),
    );
  }
}
