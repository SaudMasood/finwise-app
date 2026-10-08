import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/datasources/transctiondatasorce.dart';
import '../../../data/repositories/transactions/transactions_repository_impl.dart';
import '../../../domain/entities/transactions/transactions.dart';
import '../../../domain/usecases/transactions/get_transactions_usecase.dart';
import '../../bloc/transactions/transactions_bloc.dart';
import '../../bloc/transactions/transactions_event.dart';
import '../../bloc/transactions/transactions_state.dart';

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

    const mainGreen = Color(0xFF00D09E);
    const lightGreen = Color(0xFFF1FFF3);
    const darkGreen = Color(0xFF063F3F);
    const blue = Color(0xFF168BFF);

    return Scaffold(
      backgroundColor: mainGreen,
      body: SafeArea(
        child: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }

            if (state is TransactionFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 45,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
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
                if (transaction.type.toLowerCase() ==
                    'income') {
                  totalIncome += transaction.amount;
                } else {
                  totalExpense += transaction.amount;
                }
              }

              final balance =
                  totalIncome - totalExpense;

              return Column(
                children: [
                  SizedBox(
                    height: height * 0.36,
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            const SizedBox(width: 25),
                            GestureDetector(
                              onTap: () {
                                Navigator.maybePop(context);
                              },
                              child: const Icon(
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
                                    fontSize: 19,
                                    fontWeight:
                                    FontWeight.w600,
                                    color: darkGreen,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 32,
                              height: 32,
                              margin:
                              const EdgeInsets.only(
                                right: 25,
                              ),
                              decoration:
                              const BoxDecoration(
                                shape: BoxShape.circle,
                                color: lightGreen,
                              ),
                              child: const Icon(
                                Icons.notifications_none,
                                size: 21,
                                color: darkGreen,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: width * 0.82,
                          height: 62,
                          decoration: BoxDecoration(
                            color: lightGreen,
                            borderRadius:
                            BorderRadius.circular(14),
                          ),
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Text(
                                'Total Balance',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: darkGreen,
                                ),
                              ),
                              Text(
                                '\$${balance.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 21,
                                  fontWeight:
                                  FontWeight.w600,
                                  color: darkGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            const SizedBox(width: 34),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  context
                                      .read<TransactionBloc>()
                                      .add(
                                    SelectTransactionType(
                                      type:
                                      state.selectedType ==
                                          'income'
                                          ? null
                                          : 'income',
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 84,
                                  decoration: BoxDecoration(
                                    color:
                                    state.selectedType ==
                                        'income'
                                        ? blue
                                        : lightGreen,
                                    borderRadius:
                                    BorderRadius.circular(
                                        13),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                    children: [
                                      Container(
                                        width: 22,
                                        height: 22,
                                        decoration:
                                        BoxDecoration(
                                          border: Border.all(
                                            color: state
                                                .selectedType ==
                                                'income'
                                                ? Colors.white
                                                : mainGreen,
                                            width: 2,
                                          ),
                                          borderRadius:
                                          BorderRadius
                                              .circular(5),
                                        ),
                                        child: Icon(
                                          Icons.arrow_outward,
                                          size: 15,
                                          color: state
                                              .selectedType ==
                                              'income'
                                              ? Colors.white
                                              : mainGreen,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Income',
                                        style:
                                        GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: state
                                              .selectedType ==
                                              'income'
                                              ? Colors.white
                                              : darkGreen,
                                        ),
                                      ),
                                      Text(
                                        '\$${totalIncome.toStringAsFixed(2)}',
                                        style:
                                        GoogleFonts.poppins(
                                          fontSize: 17,
                                          fontWeight:
                                          FontWeight.w600,
                                          color: state
                                              .selectedType ==
                                              'income'
                                              ? Colors.white
                                              : darkGreen,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 13),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  context
                                      .read<TransactionBloc>()
                                      .add(
                                    SelectTransactionType(
                                      type:
                                      state.selectedType ==
                                          'expense'
                                          ? null
                                          : 'expense',
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 84,
                                  decoration: BoxDecoration(
                                    color:
                                    state.selectedType ==
                                        'expense'
                                        ? blue
                                        : lightGreen,
                                    borderRadius:
                                    BorderRadius.circular(
                                        13),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                    children: [
                                      Container(
                                        width: 22,
                                        height: 22,
                                        decoration:
                                        BoxDecoration(
                                          border: Border.all(
                                            color: state
                                                .selectedType ==
                                                'expense'
                                                ? Colors.white
                                                : blue,
                                            width: 2,
                                          ),
                                          borderRadius:
                                          BorderRadius
                                              .circular(5),
                                        ),
                                        child: Icon(
                                          Icons.arrow_downward,
                                          size: 15,
                                          color: state
                                              .selectedType ==
                                              'expense'
                                              ? Colors.white
                                              : blue,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Expense',
                                        style:
                                        GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: state
                                              .selectedType ==
                                              'expense'
                                              ? Colors.white
                                              : darkGreen,
                                        ),
                                      ),
                                      Text(
                                        '\$${totalExpense.toStringAsFixed(2)}',
                                        style:
                                        GoogleFonts.poppins(
                                          fontSize: 17,
                                          fontWeight:
                                          FontWeight.w600,
                                          color: state
                                              .selectedType ==
                                              'expense'
                                              ? Colors.white
                                              : blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 34),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: lightGreen,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context
                              .read<TransactionBloc>()
                              .add(const LoadTransactions());
                        },
                        child: SingleChildScrollView(
                          physics:
                          const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.07,
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text(
                                      state.selectedDate !=
                                          null
                                          ? _formatDate(
                                          state.selectedDate!)
                                          : state.selectedType ==
                                          'income'
                                          ? 'Income Transactions'
                                          : state.selectedType ==
                                          'expense'
                                          ? 'Expense Transactions'
                                          : 'All Transactions',
                                      style:
                                      GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight:
                                        FontWeight.w500,
                                        color: darkGreen,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        if (state.selectedType !=
                                            null ||
                                            state.selectedDate !=
                                                null)
                                          GestureDetector(
                                            onTap: () {
                                              context
                                                  .read<
                                                  TransactionBloc>()
                                                  .add(
                                                const ClearTransactionFilters(),
                                              );
                                            },
                                            child: Container(
                                              width: 28,
                                              height: 28,
                                              margin:
                                              const EdgeInsets
                                                  .only(
                                                right: 8,
                                              ),
                                              decoration:
                                              BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius
                                                    .circular(8),
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                size: 17,
                                                color: darkGreen,
                                              ),
                                            ),
                                          ),
                                        GestureDetector(
                                          onTap: () async {
                                            final date =
                                            await showDatePicker(
                                              context: context,
                                              initialDate:
                                              state.selectedDate ??
                                                  DateTime.now(),
                                              firstDate:
                                              DateTime(2020),
                                              lastDate:
                                              DateTime(2035),
                                            );

                                            if (date != null &&
                                                context.mounted) {
                                              context
                                                  .read<
                                                  TransactionBloc>()
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
                                            decoration:
                                            BoxDecoration(
                                              color: mainGreen,
                                              borderRadius:
                                              BorderRadius
                                                  .circular(8),
                                            ),
                                            child: const Icon(
                                              Icons
                                                  .calendar_month_outlined,
                                              size: 18,
                                              color: darkGreen,
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
                                    padding:
                                    const EdgeInsets.only(
                                      top: 80,
                                    ),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          const Icon(
                                            Icons
                                                .receipt_long_outlined,
                                            size: 55,
                                            color: blue,
                                          ),
                                          const SizedBox(
                                              height: 12),
                                          Text(
                                            'No transactions found',
                                            style: GoogleFonts
                                                .poppins(
                                              fontSize: 14,
                                              fontWeight:
                                              FontWeight.w500,
                                              color: darkGreen,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                else
                                  _buildTransactions(
                                    transactions,
                                    darkGreen,
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
      List<TransactionEntity> transactions,
      Color darkGreen,
      ) {
    final grouped =
    <String, List<TransactionEntity>>{};

    for (final transaction in transactions) {
      final key = _monthName(transaction.date.month);

      grouped.putIfAbsent(
        key,
            () => [],
      );

      grouped[key]!.add(transaction);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: grouped.entries.map((entry) {
        return Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            if (entry != grouped.entries.first)
              const SizedBox(height: 10),
            Text(
              entry.key,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: darkGreen,
              ),
            ),
            const SizedBox(height: 14),
            ...entry.value.map(
                  (transaction) => Padding(
                padding:
                const EdgeInsets.only(bottom: 15),
                child: _transactionItem(transaction),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _transactionItem(
      TransactionEntity transaction,
      ) {
    const mainGreen = Color(0xFF00D09E);
    const darkGreen = Color(0xFF063F3F);
    const blue = Color(0xFF168BFF);

    final isIncome =
        transaction.type.toLowerCase() == 'income';

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

    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isIncome
                ? const Color(0xFF62B0FF)
                : blue,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 25,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
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
                '$time - ${_monthName(transaction.date.month)} ${transaction.date.day}',
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: blue,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 1,
          height: 35,
          color: mainGreen,
        ),
        const SizedBox(width: 15),
        SizedBox(
          width: 45,
          child: Text(
            transaction.category,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 9,
              color: darkGreen,
            ),
          ),
        ),
        Container(
          width: 1,
          height: 35,
          color: mainGreen,
        ),
        const SizedBox(width: 15),
        Text(
          '${isIncome ? '' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isIncome ? darkGreen : blue,
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