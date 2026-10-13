import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/datasources/homedatasource.dart';
import '../../../data/datasources/local_notification.dart';
import '../../../data/repositories/home/home_repository_impl.dart';
import '../../../domain/entities/home/home.dart';
import '../../../domain/usecases/home/home_usecase.dart';
import '../../bloc/home/home_bloc.dart';
import '../../bloc/home/home_event.dart';
import '../../bloc/home/home_state.dart';
import '../notification/notification.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataSource = HomeDataSource(
      firestore: FirebaseFirestore.instance,
      firebaseAuth: FirebaseAuth.instance,
    );

    final repository = HomeRepositoryImpl(
      dataSource: dataSource,
    );

    final useCase = GetHomeUseCase(
      repository: repository,
    );

    return BlocProvider(
      create: (_) => HomeBloc(
        getHomeUseCase: useCase,
      )..add(
        const LoadHome(),
      ),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const mainGreen = Color(0xFF00D09E);
  static const lightGreen = Color(0xFFF1FFF3);
  static const softGreen = Color(0xFFDDF5E2);
  static const darkGreen = Color(0xFF063F3F);
  static const blue = Color(0xFF168BFF);
  static const incomeBlue = Color(0xFF5AAFFF);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final scale = (size.width / 375).clamp(
      0.98,
      1.20,
    );

    return Scaffold(
      backgroundColor: mainGreen,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }

            if (state is HomeFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<HomeBloc>()
                              .add(
                            const LoadHome(),
                          );
                        },
                        child: const Text(
                          'Retry',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is! HomeSuccess) {
              return const SizedBox();
            }

            final home = state.home;

            final totalIncome = home.totalIncome;
            final totalExpense = home.totalExpense;

            double percentage = 0;

            if (totalIncome > 0) {
              percentage =
                  (totalExpense / totalIncome) * 100;
            }

            percentage = percentage.clamp(
              0.0,
              100.0,
            );

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  color: mainGreen,
                  padding: EdgeInsets.fromLTRB(
                    40 * scale,
                    12 * scale,
                    40 * scale,
                    26 * scale,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hi, Welcome Back',
                                style:
                                GoogleFonts.poppins(
                                  fontSize: 19 * scale,
                                  fontWeight:
                                  FontWeight.w600,
                                  color: darkGreen,
                                  height: 1.05,
                                ),
                              ),
                              SizedBox(
                                height: 6 * scale,
                              ),
                              Text(
                                'Good Morning',
                                style:
                                GoogleFonts.poppins(
                                  fontSize:
                                  10.5 * scale,
                                  color: darkGreen,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 6,),
                          Container(
                            width: 36 * scale,
                            height: 36 * scale,
                            decoration: const BoxDecoration(
                              color: lightGreen,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const NotificationScreen(),
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

                      SizedBox(
                        height: 32 * scale,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .account_balance_wallet_outlined,
                                      size: 13 * scale,
                                      color: darkGreen,
                                    ),
                                    SizedBox(
                                      width: 6 * scale,
                                    ),
                                    Text(
                                      'Total Balance',
                                      style:
                                      GoogleFonts.poppins(
                                        fontSize:
                                        9.5 * scale,
                                        color:
                                        darkGreen,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5 * scale,
                                ),
                                Text(
                                  '\$${home.totalBalance.toStringAsFixed(2)}',
                                  style:
                                  GoogleFonts.poppins(
                                    fontSize:
                                    21.5 * scale,
                                    fontWeight:
                                    FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            width: 1,
                            height: 42 * scale,
                            color: darkGreen,
                          ),

                          SizedBox(
                            width: 19 * scale,
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .receipt_long_outlined,
                                      size: 13 * scale,
                                      color: darkGreen,
                                    ),
                                    SizedBox(
                                      width: 6 * scale,
                                    ),
                                    Text(
                                      'Total Expense',
                                      style:
                                      GoogleFonts.poppins(
                                        fontSize:
                                        9.5 * scale,
                                        color:
                                        darkGreen,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5 * scale,
                                ),
                                Text(
                                  '-\$${home.totalExpense.toStringAsFixed(2)}',
                                  style:
                                  GoogleFonts.poppins(
                                    fontSize:
                                    21.5 * scale,
                                    fontWeight:
                                    FontWeight.w600,
                                    color: blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 17 * scale,
                      ),

                      _progressBar(
                        percentage: percentage,
                        totalIncome: totalIncome,
                        scale: scale,
                      ),

                      SizedBox(
                        height: 9 * scale,
                      ),

                      Row(
                        children: [
                          Icon(
                            Icons.check_box_outlined,
                            size: 13 * scale,
                            color: darkGreen,
                          ),
                          SizedBox(
                            width: 6 * scale,
                          ),
                          Expanded(
                            child: Text(
                              '${percentage.toStringAsFixed(0)}% Of Your Expenses, Looks Good.',
                              style:
                              GoogleFonts.poppins(
                                fontSize:
                                9.5 * scale,
                                color: darkGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration:
                    const BoxDecoration(
                      color: lightGreen,
                      borderRadius:
                      BorderRadius.only(
                        topLeft:
                        Radius.circular(50),
                        topRight:
                        Radius.circular(50),
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics:
                      const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        28 * scale,
                        27 * scale,
                        28 * scale,
                        35 * scale,
                      ),
                      child: Column(
                        children: [
                          _savingsCard(
                            home,
                            scale,
                          ),

                          SizedBox(
                            height: 21 * scale,
                          ),

                          _periodSelector(
                            context,
                            state,
                            scale,
                          ),

                          SizedBox(
                            height: 24 * scale,
                          ),

                          if (home.activities.isEmpty)
                            Padding(
                              padding:
                              EdgeInsets.only(
                                top: 28 * scale,
                              ),
                              child: Text(
                                'No transactions found',
                                style:
                                GoogleFonts.poppins(
                                  fontSize:
                                  12 * scale,
                                  color: darkGreen,
                                ),
                              ),
                            )
                          else
                            ...home.activities
                                .take(5)
                                .map(
                                  (transaction) {
                                return _transaction(
                                  transaction,
                                  scale,
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _progressBar({
    required double percentage,
    required double totalIncome,
    required double scale,
  }) {
    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        final totalWidth =
            constraints.maxWidth;

        final height = 24 * scale;

        double fillWidth =
            totalWidth *
                percentage /
                100;

        final minimumFill =
            48 * scale;

        if (fillWidth > 0 &&
            fillWidth < minimumFill) {
          fillWidth = minimumFill;
        }

        if (fillWidth > totalWidth) {
          fillWidth = totalWidth;
        }

        final amountOnDark =
            fillWidth >
                totalWidth -
                    (105 * scale);

        return Container(
          width: double.infinity,
          height: height,
          decoration:
          BoxDecoration(
            color: softGreen,
            borderRadius:
            BorderRadius.circular(
              20 * scale,
            ),
          ),
          child: ClipRRect(
            borderRadius:
            BorderRadius.circular(
              20 * scale,
            ),
            child: Stack(
              children: [
                AnimatedContainer(
                  duration:
                  const Duration(
                    milliseconds: 450,
                  ),
                  curve:
                  Curves.easeOut,
                  width: fillWidth,
                  height: height,
                  decoration:
                  BoxDecoration(
                    color: darkGreen,
                    borderRadius:
                    BorderRadius.circular(
                      20 * scale,
                    ),
                  ),
                  child: Align(
                    alignment:
                    Alignment.centerLeft,
                    child: Padding(
                      padding:
                      EdgeInsets.only(
                        left: 13 * scale,
                      ),
                      child: Text(
                        '${percentage.toStringAsFixed(0)}%',
                        style:
                        GoogleFonts.poppins(
                          fontSize:
                          8.5 * scale,
                          fontWeight:
                          FontWeight.w500,
                          color:
                          Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  right: 14 * scale,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Text(
                      '\$${totalIncome.toStringAsFixed(2)}',
                      style:
                      GoogleFonts.poppins(
                        fontSize:
                        8.5 * scale,
                        fontWeight:
                        FontWeight.w600,
                        color: amountOnDark
                            ? Colors.white
                            : darkGreen,
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

  Widget _savingsCard(
      HomeEntity home,
      double scale,
      ) {
    final goal = home.totalIncome > 0
        ? (home.totalBalance / home.totalIncome).clamp(0.0, 1.0).toDouble()
        : 0.0;

    return Container(
      width: double.infinity,
      height: 124 * scale,
      padding:
      EdgeInsets.all(
        13 * scale,
      ),
      decoration:
      BoxDecoration(
        color: mainGreen,
        borderRadius:
        BorderRadius.circular(
          23 * scale,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 58 * scale,
                  height: 58 * scale,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 58 * scale,
                        height: 58 * scale,
                        child: CircularProgressIndicator(
                          value: 1,
                          strokeWidth: 3 * scale,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 58 * scale,
                        height: 58 * scale,
                        child: CircularProgressIndicator(
                          value: goal,
                          strokeWidth: 3 * scale,
                          color: blue,
                        ),
                      ),
                      Icon(
                        Icons
                            .directions_car_outlined,
                        size: 32 * scale,
                        color: darkGreen,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4 * scale,
                ),
                Text(
                  'Savings',
                  style:
                  GoogleFonts.poppins(
                    fontSize:
                    9 * scale,
                    color: darkGreen,
                  ),
                ),
                Text(
                  'On Goals',
                  style:
                  GoogleFonts.poppins(
                    fontSize:
                    9 * scale,
                    color: darkGreen,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 1.2,
            height: 76 * scale,
            color: Colors.white,
          ),

          Expanded(
            flex: 6,
            child: Padding(
              padding:
              EdgeInsets.only(
                left: 14 * scale,
              ),
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.layers_outlined,
                        size: 29 * scale,
                        color: darkGreen,
                      ),
                      SizedBox(
                        width: 8 * scale,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Revenue Last Week',
                              style:
                              GoogleFonts.poppins(
                                fontSize:
                                8.5 * scale,
                                color:
                                darkGreen,
                              ),
                            ),
                            Text(
                              '\$${home.revenueLastWeek.toStringAsFixed(2)}',
                              style:
                              GoogleFonts.poppins(
                                fontSize:
                                11.5 * scale,
                                fontWeight:
                                FontWeight.w600,
                                color:
                                darkGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Divider(
                    color: Colors.white,
                    height: 15 * scale,
                  ),

                  Row(
                    children: [
                      Icon(
                        Icons.restaurant_outlined,
                        size: 29 * scale,
                        color: darkGreen,
                      ),
                      SizedBox(
                        width: 8 * scale,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Food Last Week',
                              style:
                              GoogleFonts.poppins(
                                fontSize:
                                8.5 * scale,
                                color:
                                darkGreen,
                              ),
                            ),
                            Text(
                              '-\$${home.foodLastWeek.toStringAsFixed(2)}',
                              style:
                              GoogleFonts.poppins(
                                fontSize:
                                11.5 * scale,
                                fontWeight:
                                FontWeight.w600,
                                color:
                                blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _periodSelector(
      BuildContext context,
      HomeSuccess state,
      double scale,
      ) {
    return Container(
      width: double.infinity,
      height: 48 * scale,
      decoration:
      BoxDecoration(
        color: softGreen,
        borderRadius:
        BorderRadius.circular(
          17 * scale,
        ),
      ),
      child: Row(
        children: [
          _periodButton(
            context,
            state,
            'Daily',
            scale,
          ),
          _periodButton(
            context,
            state,
            'Weekly',
            scale,
          ),
          _periodButton(
            context,
            state,
            'Monthly',
            scale,
          ),
        ],
      ),
    );
  }

  Widget _periodButton(
      BuildContext context,
      HomeSuccess state,
      String period,
      double scale,
      ) {
    final selected =
        state.selectedPeriod ==
            period;

    return Expanded(
      child: GestureDetector(
        behavior:
        HitTestBehavior.opaque,
        onTap: () {
          context
              .read<HomeBloc>()
              .add(
            SelectHomePeriod(
              period: period,
            ),
          );
        },
        child: Container(
          margin:
          EdgeInsets.all(
            4 * scale,
          ),
          decoration:
          BoxDecoration(
            color: selected
                ? mainGreen
                : Colors.transparent,
            borderRadius:
            BorderRadius.circular(
              15 * scale,
            ),
          ),
          child: Center(
            child: Text(
              period,
              style:
              GoogleFonts.poppins(
                fontSize:
                10.5 * scale,
                color:
                darkGreen,
                fontWeight: selected
                    ? FontWeight.w500
                    : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _transaction(
      HomeActivityEntity transaction,
      double scale,
      ) {
    final isIncome =
        transaction.type
            .toLowerCase() ==
            'income';

    final title =
    transaction.title
        .toLowerCase();

    final category =
    transaction.category
        .toLowerCase();

    IconData icon =
        Icons.layers_outlined;

    if (title.contains('salary') ||
        category.contains('salary')) {
      icon =
          Icons.layers_outlined;
    } else if (title.contains('grocery') ||
        title.contains('groceries') ||
        category.contains('grocery') ||
        category.contains('groceries')) {
      icon =
          Icons.shopping_bag_outlined;
    } else if (title.contains('rent') ||
        category.contains('rent')) {
      icon =
          Icons.volunteer_activism_outlined;
    } else if (title.contains('transport') ||
        category.contains('transport')) {
      icon =
          Icons.directions_bus_outlined;
    } else if (title.contains('food') ||
        category.contains('food')) {
      icon =
          Icons.restaurant_outlined;
    } else if (category.contains('drink')) {
      icon =
          Icons.local_bar_outlined;
    }

    return Padding(
      padding:
      EdgeInsets.only(
        bottom: 22 * scale,
      ),
      child: Row(
        children: [
          Container(
            width: 46 * scale,
            height: 46 * scale,
            decoration:
            BoxDecoration(
              shape: BoxShape.circle,
              color: isIncome
                  ? incomeBlue
                  : blue,
            ),
            child: Icon(
              icon,
              size: 24 * scale,
              color: Colors.white,
            ),
          ),

          SizedBox(
            width: 13 * scale,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style:
                  GoogleFonts.poppins(
                    fontSize:
                    11.5 * scale,
                    fontWeight:
                    FontWeight.w500,
                    color:
                    darkGreen,
                  ),
                ),
                SizedBox(
                  height: 4 * scale,
                ),
                Text(
                  '${transaction.date.hour.toString().padLeft(2, '0')}:${transaction.date.minute.toString().padLeft(2, '0')} - ${_month(transaction.date.month)} ${transaction.date.day}',
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style:
                  GoogleFonts.poppins(
                    fontSize:
                    8.5 * scale,
                    color: blue,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 1,
            height: 35 * scale,
            color: mainGreen,
          ),

          SizedBox(
            width: 11 * scale,
          ),

          SizedBox(
            width: 49 * scale,
            child: Text(
              transaction.category,
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
              style:
              GoogleFonts.poppins(
                fontSize:
                8.5 * scale,
                color: darkGreen,
              ),
            ),
          ),

          Container(
            width: 1,
            height: 35 * scale,
            color: mainGreen,
          ),

          SizedBox(
            width: 10 * scale,
          ),

          SizedBox(
            width: 65 * scale,
            child: Text(
              '${isIncome ? '' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
              textAlign:
              TextAlign.right,
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
              style:
              GoogleFonts.poppins(
                fontSize:
                9 * scale,
                fontWeight:
                FontWeight.w600,
                color: isIncome
                    ? darkGreen
                    : blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _month(int month) {
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

    if (month < 1 ||
        month > 12) {
      return '';
    }

    return months[month];
  }
}