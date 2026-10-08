import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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

// Colors
const green = Color(0xFF00D09E);
const lightGreen = Color(0xFFF1FFF3);
const softGreen = Color(0xFFDDF5E2);
const dark = Color(0xFF063F3F);
const blue = Color(0xFF168BFF);
const lightBlue = Color(0xFF62B0FF);

// ---------------------------------------------------
// Screen: only creates the Bloc (logic is same as before)
// ---------------------------------------------------
class CategoryExpenseScreen extends StatelessWidget {
  final String categoryName;

  const CategoryExpenseScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final dataSource = CategoryDataSource(
      firestore: FirebaseFirestore.instance,
      firebaseAuth: FirebaseAuth.instance,
    );
    final repository = CategoryRepositoryImpl(dataSource: dataSource);

    return BlocProvider(
      create: (_) => CategoryBloc(
        getCategoriesUseCase: GetCategoriesUseCase(repository: repository),
        getExpensesUseCase: GetExpensesUseCase(repository: repository),
        addCategoryUseCase: AddCategoryUseCase(repository: repository),
        addExpenseUseCase: AddExpenseUseCase(repository: repository),
        addIncomeUseCase: AddIncomeUseCase(repository: repository),
        firebaseAuth: FirebaseAuth.instance,
      )..add(WatchCategoryTransactions(category: categoryName)),
      child: CategoryExpenseView(categoryName: categoryName),
    );
  }
}

// ---------------------------------------------------
// View: the UI
// ---------------------------------------------------
class CategoryExpenseView extends StatelessWidget {
  final String categoryName;

  const CategoryExpenseView({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: green,
      body: SafeArea(
        child: Column(
          children: [
            topBar(context),
            const SizedBox(height: 20),
            summary(), // balance, expense, progress bar
            const SizedBox(height: 20),

            // ----- White rounded sheet -----
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
                ),
                child: sheet(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----- Top bar: back arrow, title, bell -----
  Widget topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 27),
          ),
          Expanded(
            child: Text(
              categoryName,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                color: dark,
              ),
            ),
          ),
          const CircleAvatar(
            radius: 16,
            backgroundColor: lightGreen,
            child: Icon(Icons.notifications_none, color: dark, size: 20),
          ),
        ],
      ),
    );
  }

  // ----- Total Balance | Total Expense + progress bar -----
  Widget summary() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        final income = state.totalIncome;
        final expense = state.totalExpense;
        final balance = income - expense;

        // How much of the income is spent (0 - 100)
        final percent = income == 0 ? 0.0 : expense / income * 100;

        // Size of the dark part of the bar (kept between 15 and 85)
        final darkFlex = percent.clamp(15, 85).toInt();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance (left) and Expense (right)
              Row(
                children: [
                  Expanded(
                    child: amountColumn(
                      'Total Balance',
                      '\$${balance.toStringAsFixed(2)}',
                      Colors.white,
                    ),
                  ),
                  Container(width: 1, height: 45, color: Colors.white),
                  const SizedBox(width: 20),
                  Expanded(
                    child: amountColumn(
                      'Total Expense',
                      '-\$${expense.toStringAsFixed(2)}',
                      blue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 28,
                  child: Row(
                    children: [
                      // Dark part with percent
                      Expanded(
                        flex: darkFlex,
                        child: Container(
                          color: dark,
                          alignment: Alignment.center,
                          child: Text(
                            '${percent.toStringAsFixed(0)}%',
                            style: GoogleFonts.poppins(
                                fontSize: 10, color: Colors.white),
                          ),
                        ),
                      ),
                      // White part with income amount
                      Expanded(
                        flex: 100 - darkFlex,
                        child: Container(
                          color: Colors.white,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 12),
                          child: Text(
                            '\$${income.toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(
                                fontSize: 10, color: dark),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Small message under the bar
              Row(
                children: [
                  const Icon(Icons.check_box_outlined, size: 16, color: dark),
                  const SizedBox(width: 6),
                  Text(
                    '${percent.toStringAsFixed(0)}% Of Your Expenses, Looks Good.',
                    style: GoogleFonts.poppins(fontSize: 11, color: dark),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Small title + big amount (used for balance and expense)
  Widget amountColumn(String title, String amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(fontSize: 10, color: dark)),
        Text(
          amount,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  // ----- Inside the white sheet: list + buttons -----
  Widget sheet() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        // Error
        if (state.status == CategoryStatus.failure) {
          return Center(
            child: Text(
              state.errorMessage ?? 'Something went wrong',
              textAlign: TextAlign.center,
            ),
          );
        }

        final transactions = state.transactions;

        return Column(
          children: [
            // ----- List of transactions -----
            Expanded(
              child: transactions.isEmpty
                  ? Center(
                child: Text(
                  'No transactions found',
                  style: GoogleFonts.poppins(fontSize: 12, color: dark),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(30, 25, 30, 10),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final t = transactions[index];
                  final income = t.type == 'income';

                  // Show month title (March, February...)
                  // when the month changes
                  final showMonth = index == 0 ||
                      transactions[index - 1].date.month != t.date.month;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showMonth) monthTitle(t.date, index == 0),
                      transactionRow(t, income),
                    ],
                  );
                },
              ),
            ),

            // ----- Buttons -----
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 5, 30, 25),
              child: Row(
                children: [
                  Expanded(
                    child: greenButton('Add Expenses', () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AddExpenseScreen(categoryName: categoryName),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: greenButton('Add Income', () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AddIncomeScreen(categoryName: categoryName),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // ----- Month title (and calendar icon on the first one) -----
  Widget monthTitle(DateTime date, bool showCalendarIcon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('MMMM').format(date),
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: dark,
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
              child: const Icon(Icons.calendar_month_outlined,
                  color: dark, size: 18),
            ),
        ],
      ),
    );
  }

  // ----- One transaction row -----
  Widget transactionRow(dynamic t, bool income) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          // Icon box
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: income ? green : lightBlue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              income ? Icons.arrow_upward : Icons.directions_bus_outlined,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 14),

          // Title and date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: dark,
                  ),
                ),
                Text(
                  DateFormat('HH:mm - MMMM dd').format(t.date),
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: blue,
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            '${income ? '+' : '-'}\$${t.amount.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: income ? dark : blue,
            ),
          ),
        ],
      ),
    );
  }

  // ----- Green rounded button -----
  Widget greenButton(String text, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: green,
        foregroundColor: dark,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(text, style: GoogleFonts.poppins(fontSize: 12)),
    );
  }
}