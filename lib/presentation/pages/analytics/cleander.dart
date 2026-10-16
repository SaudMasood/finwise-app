
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/color/app_color.dart';
import '../../../data/datasources/clenderdatasorce.dart';
import '../../../data/repositories/analytics/clnder_repo_impp.dart';
import '../../../domain/usecases/analytics/get_clender_tran.dart';
import '../../bloc/analytics/clender_bloc.dart';
import '../../bloc/analytics/clender_event.dart';
import '../../bloc/analytics/clender_state.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataSource = CalendarDataSource(
      firestore: FirebaseFirestore.instance,
      firebaseAuth: FirebaseAuth.instance,
    );

    final repository = CalendarRepositoryImpl(dataSource: dataSource);
    final useCase = GetCalendarTransactionsUseCase(
      repository: repository,
    );

    return BlocProvider(
      create: (_) => CalendarBloc(
        getCalendarTransactionsUseCase: useCase,
      )..add(SelectCalendarDate(date: DateTime.now())),
      child: const CalendarView(),
    );
  }
}

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  bool showSpends = true;
  DateTime visibleMonth = DateTime.now();

  bool get isDark =>
      Theme.of(context).brightness == Brightness.dark;

  Color get green => AppColors.primaryGreen;

  Color get panelColor => isDark
      ? Theme.of(context).colorScheme.surface
      : AppColors.lightBackground;

  Color get cardColor => isDark
      ? Theme.of(context).colorScheme.surfaceContainerHighest
      : AppColors.softGreen;

  Color get textColor => isDark
      ? Theme.of(context).colorScheme.onSurface
      : AppColors.darkGreen;

  Color get secondaryTextColor => isDark
      ? AppColors.darkSecondaryText
      : AppColors.darkGreen.withOpacity(0.65);

  Color get blue => AppColors.calendarBlue;

  Color get screenBackground => isDark
      ? Theme.of(context).scaffoldBackgroundColor
      : AppColors.primaryGreen;

  Color get activeTextColor =>
      isDark ? AppColors.darkBackground : Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackground,
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: isDark ? textColor : Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Calendar',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: isDark ? textColor : Colors.white,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 17,
                    backgroundColor: panelColor,
                    child: Icon(
                      Icons.notifications_none,
                      color: textColor,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: panelColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    monthYearRow(),
                    const SizedBox(height: 8),
                    calendarGrid(),
                    const SizedBox(height: 16),
                    tabButtons(),
                    const SizedBox(height: 16),
                    Expanded(child: content()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget monthYearRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                visibleMonth = DateTime(
                  visibleMonth.year,
                  visibleMonth.month - 1,
                );
              });
            },
            child: Row(
              children: [
                Text(
                  DateFormat('MMMM').format(visibleMonth),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: green,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: green,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                visibleMonth = DateTime(
                  visibleMonth.year + 1,
                  visibleMonth.month,
                );
              });
            },
            child: Row(
              children: [
                Text(
                  '${visibleMonth.year}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: green,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget calendarGrid() {
    final firstDay = DateTime(
      visibleMonth.year,
      visibleMonth.month,
      1,
    );

    final daysInMonth =
        DateTime(visibleMonth.year, visibleMonth.month + 1, 0).day;

    final emptyCells = firstDay.weekday - 1;

    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Row(
            children: [
              for (final name in names)
                Expanded(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 9,
                      color: blue,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: emptyCells + daysInMonth,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.4,
            ),
            itemBuilder: (context, index) {
              if (index < emptyCells) {
                return const SizedBox();
              }

              final day = index - emptyCells + 1;
              final date = DateTime(
                visibleMonth.year,
                visibleMonth.month,
                day,
              );

              return BlocBuilder<CalendarBloc, CalendarState>(
                builder: (context, state) {
                  final selected =
                  DateUtils.isSameDay(date, state.selectedDate);

                  return GestureDetector(
                    onTap: () {
                      context.read<CalendarBloc>().add(
                        SelectCalendarDate(date: date),
                      );
                    },
                    child: Center(
                      child: Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected ? green : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$day',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: selected
                                ? activeTextColor
                                : textColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget tabButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Expanded(child: tabButton('Spends', showSpends)),
          const SizedBox(width: 12),
          Expanded(child: tabButton('Categories', !showSpends)),
        ],
      ),
    );
  }

  Widget tabButton(String text, bool active) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showSpends = text == 'Spends';
        });
      },
      child: Container(
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? green : cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: active ? activeTextColor : textColor,
          ),
        ),
      ),
    );
  }

  Widget content() {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        if (state.status == CalendarStatus.loading) {
          return Center(
            child: CircularProgressIndicator(color: green),
          );
        }

        if (state.status == CalendarStatus.failure) {
          return Center(
            child: Text(
              state.errorMessage ?? 'Something went wrong',
              style: GoogleFonts.poppins(color: textColor),
            ),
          );
        }

        return showSpends
            ? spendsList(state)
            : categoriesChart(state);
      },
    );
  }

  Widget spendsList(CalendarState state) {
    if (state.transactions.isEmpty) {
      return Center(
        child: Text(
          'No transactions on this date',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: textColor,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      itemCount: state.transactions.length,
      itemBuilder: (context, index) {
        final transaction = state.transactions[index];
        final income =
            transaction.type.toLowerCase() == 'income';

        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: income
                      ? const Color(0xFF6FB6FF)
                      : blue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  categoryIcon(transaction.category),
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title.isEmpty
                          ? transaction.category
                          : transaction.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    Text(
                      DateFormat('HH:mm - MMMM dd')
                          .format(transaction.date),
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 36,
                color: green.withOpacity(0.7),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  transaction.category,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: textColor,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 36,
                color: green.withOpacity(0.7),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '${income ? '' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: income ? green : blue,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget categoriesChart(CalendarState state) {
    final Map<String, double> totals = {};

    for (final transaction in state.transactions) {
      totals[transaction.category] =
          (totals[transaction.category] ?? 0) + transaction.amount;
    }

    if (totals.isEmpty) {
      return Center(
        child: Text(
          'No categories on this date',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: textColor,
          ),
        ),
      );
    }

    const colors = [
      Color(0xFF1E88FF),
      Color(0xFF6FB6FF),
      Color(0xFF3399FF),
      Color(0xFF9CCDFF),
    ];

    final names = totals.keys.toList();
    final values = totals.values.toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          SizedBox(
            width: 220,
            height: 110,
            child: CustomPaint(
              painter: HalfPie(values, colors),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 24,
            runSpacing: 8,
            children: [
              for (int i = 0; i < names.length; i++)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 4,
                      backgroundColor: colors[i % colors.length],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      names[i],
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  IconData categoryIcon(String category) {
    final name = category.toLowerCase();

    if (name.contains('food') || name.contains('grocer')) {
      return Icons.shopping_basket_outlined;
    }

    if (name.contains('transport')) {
      return Icons.directions_bus_outlined;
    }

    if (name.contains('rent')) {
      return Icons.key_outlined;
    }

    if (name.contains('medicine') || name.contains('health')) {
      return Icons.medication_outlined;
    }

    if (name.contains('saving')) {
      return Icons.savings_outlined;
    }

    return Icons.category_outlined;
  }
}

class HalfPie extends CustomPainter {
  final List<double> values;
  final List<Color> colors;

  HalfPie(this.values, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold<double>(0, (a, b) => a + b);

    if (total == 0 || colors.isEmpty) return;

    final radius = size.width / 2;
    final center = Offset(radius, size.height);
    final rect = Rect.fromCircle(
      center: center,
      radius: radius,
    );

    double start = math.pi;

    for (int i = 0; i < values.length; i++) {
      final sweep = values[i] / total * math.pi;

      canvas.drawArc(
        rect,
        start,
        sweep,
        true,
        Paint()..color = colors[i % colors.length],
      );

      canvas.drawArc(
        rect,
        start,
        sweep,
        true,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );

      final mid = start + sweep / 2;

      final pos = Offset(
        center.dx + math.cos(mid) * radius * 0.65,
        center.dy + math.sin(mid) * radius * 0.65,
      );

      final text = TextPainter(
        text: TextSpan(
          text: '${(values[i] / total * 100).toStringAsFixed(0)}%',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();

      text.paint(
        canvas,
        pos - Offset(text.width / 2, text.height / 2),
      );

      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
