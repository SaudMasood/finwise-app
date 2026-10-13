import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finwise/presentation/pages/analytics/serchpge.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/datasources/analysisdatasource.dart';
import '../../../data/repositories/analytics/analytics_repository_impl.dart';
import '../../../domain/entities/analytics/analytics.dart';
import '../../../domain/usecases/analytics/analytics_usecase.dart';
import '../../bloc/analytics/analytics_bloc.dart';
import '../../bloc/analytics/analytics_event.dart';
import '../../bloc/analytics/analytics_state.dart';
import '../notification/notification.dart';
import 'cleander.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataSource = AnalysisDataSource(
      firestore: FirebaseFirestore.instance,
      firebaseAuth: FirebaseAuth.instance,
    );

    final repository = AnalysisRepositoryImpl(
      dataSource: dataSource,
    );

    final useCase = GetAnalysisUseCase(
      repository: repository,
    );

    return BlocProvider(
      create: (_) => AnalysisBloc(
        getAnalysisUseCase: useCase,
      )..add(const LoadAnalysis()),
      child: const _AnalysisView(),
    );
  }
}

class _ChartData {
  final List<String> labels;
  final List<double> income;
  final List<double> expense;

  _ChartData({
    required this.labels,
    required this.income,
    required this.expense,
  });
}

class _AnalysisView extends StatefulWidget {
  const _AnalysisView();

  @override
  State<_AnalysisView> createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<_AnalysisView> {
  static const mainGreen = Color(0xFF00D09E);
  static const lightGreen = Color(0xFFF1FFF3);
  static const softGreen = Color(0xFFDFF7E2);
  static const darkGreen = Color(0xFF052224);
  static const blue = Color(0xFF6DB6FE);
  static const strongBlue = Color(0xFF0068FF);

  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalysisBloc, AnalysisState>(
      builder: (context, state) {
        if (state is AnalysisLoading) {
          return const Scaffold(
            backgroundColor: mainGreen,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        }

        if (state is AnalysisFailure) {
          return Scaffold(
            backgroundColor: mainGreen,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        }

        if (state is! AnalysisSuccess) {
          return const Scaffold(
            backgroundColor: mainGreen,
          );
        }

        final AnalysisEntity analysis = state.analysis;

        final List<AnalysisTransactionEntity> transactions =
            analysis.transactions;

        double totalIncome = 0;
        double totalExpense = 0;

        for (final transaction in transactions) {
          if (transaction.type.toLowerCase() == 'income') {
            totalIncome = totalIncome + transaction.amount;
          } else {
            totalExpense = totalExpense + transaction.amount;
          }
        }

        final double totalBalance = totalIncome - totalExpense;

        double percentage = 0;

        if (totalIncome > 0) {
          percentage = (totalExpense / totalIncome) * 100;
        }

        percentage = percentage.clamp(0.0, 100.0);

        final chartData = _buildChartData(transactions);

        double periodIncome = 0;
        double periodExpense = 0;

        for (final value in chartData.income) {
          periodIncome = periodIncome + value;
        }

        for (final value in chartData.expense) {
          periodExpense = periodExpense + value;
        }

        return Scaffold(
          backgroundColor: mainGreen,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                const SizedBox(height: 14),
                _buildAppBar(),
                const SizedBox(height: 24),
                _buildSummary(totalBalance, totalExpense),
                const SizedBox(height: 14),
                _buildProgressBar(percentage, totalIncome),
                const SizedBox(height: 10),
                _buildMessage(percentage),
                const SizedBox(height: 22),
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
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(30, 28, 30, 130),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTabs(),
                          const SizedBox(height: 24),
                          _buildChartCard(chartData),
                          const SizedBox(height: 24),
                          _buildTotals(periodIncome, periodExpense),
                          const SizedBox(height: 24),
                          Text(
                            'My Targets',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: darkGreen,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildTarget('Travel', 0.30),
                              const SizedBox(width: 18),
                              _buildTarget('Car', 0.50),
                            ],
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

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 28,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Analysis',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: darkGreen,
                ),
              ),
            ),
          ),
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: lightGreen,
              shape: BoxShape.circle,
            ),
            child:IconButton(
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
    );
  }

  Widget _buildSummary(double balance, double expense) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Row(
        children: [
          Expanded(
            child: _summaryItem(
              'Total Balance',
              '\$${balance.toStringAsFixed(2)}',
              Colors.white,
            ),
          ),
          Container(
            width: 1,
            height: 42,
            color: Colors.white,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: _summaryItem(
              'Total Expense',
              '-\$${expense.toStringAsFixed(2)}',
              strongBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.account_balance_wallet_outlined,
              size: 12,
              color: darkGreen,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: darkGreen,
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
    );
  }

  Widget _buildProgressBar(double percentage, double totalIncome) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double totalWidth = constraints.maxWidth;
          const double barHeight = 26;

          double fillWidth = totalWidth * percentage / 100;

          if (fillWidth < 54) {
            fillWidth = 54;
          }

          if (fillWidth > totalWidth) {
            fillWidth = totalWidth;
          }

          final bool amountOnDark = fillWidth > totalWidth - 110;

          return Container(
            width: double.infinity,
            height: barHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                    width: fillWidth,
                    height: barHeight,
                    padding: const EdgeInsets.only(left: 12),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: darkGreen,
                      borderRadius: BorderRadius.circular(20),
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
                        '\$${totalIncome.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: amountOnDark ? Colors.white : darkGreen,
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
  }

  Widget _buildMessage(double percentage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.check_box_outlined,
          size: 15,
          color: darkGreen,
        ),
        const SizedBox(width: 6),
        Text(
          '${percentage.toStringAsFixed(0)}% Of Your Expenses, Looks Good.',
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: darkGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    const names = ['Daily', 'Weekly', 'Monthly', 'Year'];

    return Container(
      height: 42,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: softGreen,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: List.generate(names.length, (index) {
          final bool selected = selectedTab == index;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedTab = index;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: selected ? mainGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    names[index],
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: darkGreen,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _smallButton(IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: mainGreen,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 17,
          color: darkGreen,
        ),
      ),
    );
  }

  Widget _buildChartCard(_ChartData data) {
    double maximum = 0;

    for (final value in data.income) {
      if (value > maximum) {
        maximum = value;
      }
    }

    for (final value in data.expense) {
      if (value > maximum) {
        maximum = value;
      }
    }

    const double plotHeight = 110;

    final yLabels = [
      _shortNumber(maximum),
      _shortNumber(maximum * 2 / 3),
      _shortNumber(maximum / 3),
      '0',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: softGreen,
        borderRadius: BorderRadius.circular(27),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Income & Expenses',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: darkGreen,
                  ),
                ),
              ),
              _smallButton(Icons.search, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              }),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const CalendarScreen(),
                    ),
                  );
                },
                child: Container(
                  width: 29,
                  height: 29,
                  decoration: BoxDecoration(
                    color: mainGreen,
                    borderRadius:
                    BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.calendar_month_outlined,
                    size: 19,
                    color: darkGreen,
                  ),
                ),
              ),            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 30,
                height: plotHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: yLabels.map((label) {
                    return Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontSize: 8,
                        color: blue,
                      ),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: plotHeight,
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(4, (index) {
                              return Container(
                                height: 1,
                                color: blue.withOpacity(0.35),
                              );
                            }),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: List.generate(data.labels.length, (i) {
                              double incomeHeight = 0;
                              double expenseHeight = 0;

                              if (maximum > 0) {
                                incomeHeight =
                                    data.income[i] / maximum * plotHeight;
                                expenseHeight =
                                    data.expense[i] / maximum * plotHeight;
                              }

                              return Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: incomeHeight,
                                      decoration: BoxDecoration(
                                        color: mainGreen,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                    const SizedBox(width: 3),
                                    Container(
                                      width: 6,
                                      height: expenseHeight,
                                      decoration: BoxDecoration(
                                        color: strongBlue,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: darkGreen,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: data.labels.map((label) {
                        return Expanded(
                          child: Text(
                            label,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 8,
                              color: darkGreen,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotals(double income, double expense) {
    return Row(
      children: [
        Expanded(
          child: _totalItem(
            icon: Icons.north_east,
            color: mainGreen,
            label: 'Income',
            value: '\$${income.toStringAsFixed(2)}',
            valueColor: darkGreen,
          ),
        ),
        Expanded(
          child: _totalItem(
            icon: Icons.south_east,
            color: strongBlue,
            label: 'Expense',
            value: '\$${expense.toStringAsFixed(2)}',
            valueColor: strongBlue,
          ),
        ),
      ],
    );
  }

  Widget _totalItem({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color, width: 1.5),
          ),
          child: Icon(
            icon,
            size: 18,
            color: color,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: darkGreen,
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTarget(String name, double value) {
    return Expanded(
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: blue,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 82,
              height: 82,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 82,
                    height: 82,
                    child: CircularProgressIndicator(
                      value: value,
                      strokeWidth: 3,
                      backgroundColor: Colors.white,
                      valueColor: const AlwaysStoppedAnimation(strongBlue),
                    ),
                  ),
                  Text(
                    '${(value * 100).toStringAsFixed(0)}%',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _ChartData _buildChartData(List<AnalysisTransactionEntity> transactions) {
    final DateTime now = DateTime.now();

    List<String> labels = [];
    List<double> income = [];
    List<double> expense = [];

    if (selectedTab == 0) {
      labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      income = List.filled(7, 0.0);
      expense = List.filled(7, 0.0);

      final DateTime today = DateTime(now.year, now.month, now.day);
      final DateTime start = today.subtract(Duration(days: now.weekday - 1));
      final DateTime end = start.add(const Duration(days: 7));

      for (final t in transactions) {
        if (t.date.isBefore(start) || !t.date.isBefore(end)) {
          continue;
        }

        final int index = t.date.weekday - 1;

        if (t.type.toLowerCase() == 'income') {
          income[index] = income[index] + t.amount;
        } else {
          expense[index] = expense[index] + t.amount;
        }
      }
    } else if (selectedTab == 1) {
      labels = ['1st Week', '2nd Week', '3rd Week', '4th Week'];
      income = List.filled(4, 0.0);
      expense = List.filled(4, 0.0);

      for (final t in transactions) {
        if (t.date.year != now.year || t.date.month != now.month) {
          continue;
        }

        int index = (t.date.day - 1) ~/ 7;

        if (index > 3) {
          index = 3;
        }

        if (t.type.toLowerCase() == 'income') {
          income[index] = income[index] + t.amount;
        } else {
          expense[index] = expense[index] + t.amount;
        }
      }
    } else if (selectedTab == 2) {
      income = List.filled(6, 0.0);
      expense = List.filled(6, 0.0);

      final List<DateTime> months = List.generate(6, (i) {
        return DateTime(now.year, now.month - 5 + i, 1);
      });

      labels = months.map((m) => _shortMonth(m.month)).toList();

      for (final t in transactions) {
        for (int i = 0; i < months.length; i++) {
          if (t.date.year == months[i].year &&
              t.date.month == months[i].month) {
            if (t.type.toLowerCase() == 'income') {
              income[i] = income[i] + t.amount;
            } else {
              expense[i] = expense[i] + t.amount;
            }
          }
        }
      }
    } else {
      income = List.filled(5, 0.0);
      expense = List.filled(5, 0.0);

      final List<int> years = List.generate(5, (i) => now.year - 4 + i);

      labels = years.map((y) => y.toString()).toList();

      for (final t in transactions) {
        final int index = years.indexOf(t.date.year);

        if (index == -1) {
          continue;
        }

        if (t.type.toLowerCase() == 'income') {
          income[index] = income[index] + t.amount;
        } else {
          expense[index] = expense[index] + t.amount;
        }
      }
    }

    return _ChartData(
      labels: labels,
      income: income,
      expense: expense,
    );
  }

  String _shortNumber(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}k';
    }

    return value.toStringAsFixed(0);
  }

  String _shortMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month - 1];
  }
}