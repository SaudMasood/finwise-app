import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
import '../../../data/datasources/transctiondatasorce.dart';
import '../../../data/repositories/transactions/transactions_repository_impl.dart';
import '../../../domain/entities/transactions/transactions.dart';
import '../../../domain/usecases/transactions/get_transactions_usecase.dart';
import '../../bloc/transactions/transactions_bloc.dart';
import '../../bloc/transactions/transactions_event.dart';
import '../../bloc/transactions/transactions_state.dart';
import '../notification/notification.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataSource = TransactionDataSource(
      firestore: FirebaseFirestore.instance,
      firebaseAuth: FirebaseAuth.instance,
    );

    final repository = TransactionRepositoryImpl(
      dataSource: dataSource,
    );

    final useCase = GetTransactionsUseCase(
      repository: repository,
    );

    return BlocProvider(
      create: (_) => TransactionBloc(
        getTransactionsUseCase: useCase,
      )..add(const LoadTransactions()),
      child: const TransactionView(),
    );
  }
}

class TransactionView extends StatelessWidget {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Colors matched to the Figma design (dark teal screen, mint cards).
    const darkPageBackground = Color(0xFF073B35);
    const darkPanelBackground = Color(0xFF0C4740);
    const summaryCardColor = Color(0xFFE9FFF0);
    const summaryTextColor = Color(0xFF073B35);
    const incomeBlue = Color(0xFF087BFF);
    const expenseBlue = Color(0xFF087BFF);

    final pageBackground =
    isDark ? darkPageBackground : AppColors.primaryGreen;
    final panelBackground =
    isDark ? darkPanelBackground : AppColors.lightGreen;
    final primaryText = isDark ? Colors.white : AppColors.darkGreen;
    final secondaryText = isDark ? Colors.white : AppColors.darkGreen;
    final dividerColor = AppColors.primaryGreen;

    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
        child: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: isDark ? AppColors.lightGreen : Colors.white,
                ),
              );
            }

            if (state is TransactionFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.redAccent,
                        size: 45,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: isDark ? AppColors.darkText : Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<TransactionBloc>()
                              .add(const LoadTransactions());
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is TransactionSuccess) {
              final transactions = state.transactions;
              final allTransactions = state.allTransactions;

              double totalIncome = 0;
              double totalExpense = 0;

              for (final transaction in allTransactions) {
                if (transaction.type.toLowerCase() == 'income') {
                  totalIncome += transaction.amount;
                } else {
                  totalExpense += transaction.amount;
                }
              }

              final balance = totalIncome - totalExpense;

              return Column(
                children: [
                  SizedBox(
                    height: height * 0.36,
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Row(
                          children: [
                            const SizedBox(width: 25),
                            GestureDetector(
                              onTap: () => Navigator.maybePop(context),
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 27,
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Transaction',
                                  style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 32,
                              height: 32,
                              margin: const EdgeInsets.only(right: 25),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark
                                    ? summaryCardColor
                                    : AppColors.lightGreen,
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints:
                                const BoxConstraints(),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const NotificationScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.notifications_none,
                                  color: Color(0xFF063F3F),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),


                        Container(
                          width: width * 0.76,
                          height: 66,
                          decoration: BoxDecoration(
                            color: isDark
                                ? summaryCardColor
                                : AppColors.lightGreen,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Total Balance',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: summaryTextColor,
                                ),
                              ),
                              Text(
                                '\$${balance.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: summaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            SizedBox(width: width * 0.12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  context.read<TransactionBloc>().add(
                                    SelectTransactionType(
                                      type: state.selectedType == 'income'
                                          ? null
                                          : 'income',
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 88,
                                  decoration: BoxDecoration(
                                    color: state.selectedType == 'income'
                                        ? incomeBlue
                                        : isDark
                                        ? summaryCardColor
                                        : AppColors.lightGreen,
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: state.selectedType == 'income'
                                                ? Colors.white
                                                : AppColors.primaryGreen,
                                            width: 2,
                                          ),
                                          borderRadius:
                                          BorderRadius.circular(6),
                                        ),
                                        child: Icon(
                                          Icons.arrow_outward,
                                          size: 15,
                                          color: state.selectedType == 'income'
                                              ? Colors.white
                                              : AppColors.primaryGreen,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Income',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: state.selectedType == 'income'
                                              ? Colors.white
                                              : summaryTextColor,
                                        ),
                                      ),
                                      Text(
                                        '\$${totalIncome.toStringAsFixed(2)}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: state.selectedType == 'income'
                                              ? Colors.white
                                              : summaryTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  context.read<TransactionBloc>().add(
                                    SelectTransactionType(
                                      type: state.selectedType == 'expense'
                                          ? null
                                          : 'expense',
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 88,
                                  decoration: BoxDecoration(
                                    color: state.selectedType == 'expense'
                                        ? expenseBlue
                                        : isDark
                                        ? summaryCardColor
                                        : AppColors.lightGreen,
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: state.selectedType == 'expense'
                                                ? Colors.white
                                                : AppColors.blue,
                                            width: 2,
                                          ),
                                          borderRadius:
                                          BorderRadius.circular(6),
                                        ),
                                        child: Icon(
                                          Icons.arrow_downward,
                                          size: 15,
                                          color: state.selectedType == 'expense'
                                              ? Colors.white
                                              : AppColors.blue,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Expense',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: state.selectedType == 'expense'
                                              ? Colors.white
                                              : summaryTextColor,
                                        ),
                                      ),
                                      Text(
                                        '\$${totalExpense.toStringAsFixed(2)}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: state.selectedType == 'expense'
                                              ? Colors.white
                                              : expenseBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: width * 0.12),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: panelBackground,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(45),
                          topRight: Radius.circular(45),
                        ),
                      ),
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context
                              .read<TransactionBloc>()
                              .add(const LoadTransactions());
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.08,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        state.selectedDate != null
                                            ? _formatDate(state.selectedDate!)
                                            : state.selectedType == 'income'
                                            ? 'Income Transactions'
                                            : state.selectedType == 'expense'
                                            ? 'Expense Transactions'
                                            : 'All Transactions',
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: primaryText,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        if (state.selectedType != null ||
                                            state.selectedDate != null)
                                          GestureDetector(
                                            onTap: () {
                                              context
                                                  .read<TransactionBloc>()
                                                  .add(
                                                const ClearTransactionFilters(),
                                              );
                                            },
                                            child: Container(
                                              width: 28,
                                              height: 28,
                                              margin: const EdgeInsets.only(
                                                right: 8,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isDark
                                                    ? AppColors.darkCard
                                                    : AppColors.white,
                                                borderRadius:
                                                BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons.close,
                                                size: 17,
                                                color: primaryText,
                                              ),
                                            ),
                                          ),
                                        GestureDetector(
                                          onTap: () async {
                                            final date = await showDatePicker(
                                              context: context,
                                              initialDate:
                                              state.selectedDate ??
                                                  DateTime.now(),
                                              firstDate: DateTime(2020),
                                              lastDate: DateTime(2035),
                                              builder: (context, child) {
                                                return Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                    colorScheme: ColorScheme
                                                        .fromSeed(
                                                      seedColor:
                                                      AppColors.primaryGreen,
                                                      brightness: isDark
                                                          ? Brightness.dark
                                                          : Brightness.light,
                                                      surface: isDark
                                                          ? AppColors.darkSurface
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                  child: child!,
                                                );
                                              },
                                            );

                                            if (date != null &&
                                                context.mounted) {
                                              context
                                                  .read<TransactionBloc>()
                                                  .add(
                                                SelectTransactionDate(
                                                  date: date,
                                                ),
                                              );
                                            }
                                          },
                                          child: Container(
                                            width: 28,
                                            height: 28,
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryGreen,
                                              borderRadius:
                                              BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.calendar_month_outlined,
                                              size: 18,
                                              color: Color(0xFF073B35),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                if (transactions.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 80),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.receipt_long_outlined,
                                            size: 55,
                                            color: isDark
                                                ? AppColors.lightGreen
                                                : AppColors.blue,
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            'No transactions found',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: primaryText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                else
                                  _buildTransactions(
                                    transactions,
                                    isDark: isDark,
                                    primaryText: primaryText,
                                    secondaryText: secondaryText,
                                    dividerColor: dividerColor,
                                  ),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildTransactions(
      List<TransactionEntity> transactions, {
        required bool isDark,
        required Color primaryText,
        required Color secondaryText,
        required Color dividerColor,
      }) {
    final grouped = <String, List<TransactionEntity>>{};

    for (final transaction in transactions) {
      final key = _monthName(transaction.date.month);
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(transaction);
    }

    final entries = grouped.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (entry != entries.first) const SizedBox(height: 14),
            Text(
              entry.key,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 14),
            ...entry.value.map(
                  (transaction) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _transactionItem(
                  transaction,
                  isDark: isDark,
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                  dividerColor: dividerColor,
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _transactionItem(
      TransactionEntity transaction, {
        required bool isDark,
        required Color primaryText,
        required Color secondaryText,
        required Color dividerColor,
      }) {
    final isIncome = transaction.type.toLowerCase() == 'income';

    IconData icon = Icons.layers_outlined;

    switch (transaction.title.toLowerCase()) {
      case 'groceries':
        icon = Icons.shopping_bag_outlined;
        break;
      case 'rent':
        icon = Icons.volunteer_activism_outlined;
        break;
      case 'transport':
        icon = Icons.directions_bus_outlined;
        break;
      case 'food':
        icon = Icons.restaurant_outlined;
        break;
      case 'salary':
        icon = Icons.layers_outlined;
        break;
    }

    final time =
        '${transaction.date.hour.toString().padLeft(2, '0')}:${transaction.date.minute.toString().padLeft(2, '0')}';

    const lightBlueCircle = Color(0xFF4DA3FF);
    const timeBlue = Color(0xFF2F9BFF);

    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: lightBlueCircle,
          ),
          child: Icon(
            icon,
            color: AppColors.white,
            size: 25,
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
                  fontWeight: FontWeight.w600,
                  color: primaryText,
                ),
              ),
              Text(
                '$time - ${_monthName(transaction.date.month)} ${transaction.date.day}',
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: isDark ? timeBlue : AppColors.blue,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 1,
          height: 35,
          color: dividerColor,
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 52,
          child: Text(
            transaction.category,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 9,
              color: secondaryText,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 1,
          height: 35,
          color: dividerColor,
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 62,
          child: Text(
            '${isIncome ? '' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isIncome
                  ? (isDark ? Colors.white : AppColors.darkGreen)
                  : (isDark ? timeBlue : AppColors.blue),
            ),
          ),
        ),
      ],
    );
  }

  String _monthName(int month) {
    const months = [
      '',
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

    return months[month];
  }

  String _formatDate(DateTime date) {
    return '${_monthName(date.month)} ${date.day}, ${date.year}';
  }
}