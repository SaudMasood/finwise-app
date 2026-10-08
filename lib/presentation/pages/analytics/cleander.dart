import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../data/datasources/clenderdatasorce.dart';
import '../../../data/repositories/analytics/clnder_repo_impp.dart';
import '../../../domain/usecases/analytics/get_clender_tran.dart';
import '../../bloc/analytics/clender_bloc.dart';
import '../../bloc/analytics/clender_event.dart';
import '../../bloc/analytics/clender_state.dart';

// Colors
const green = Color(0xFF00D09E);
const lightGreen = Color(0xFFF1FFF3);
const softGreen = Color(0xFFDDF5E2);
const dark = Color(0xFF052224);
const blue = Color(0xFF168BFF);

// ---------------------------------------------------
// Screen: only creates the Bloc (logic is same as before)
// ---------------------------------------------------
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataSource = CalendarDataSource(
      firestore: FirebaseFirestore.instance,
      firebaseAuth: FirebaseAuth.instance,
    );
    final repository = CalendarRepositoryImpl(dataSource: dataSource);
    final useCase = GetCalendarTransactionsUseCase(repository: repository);

    return BlocProvider(
      create: (_) => CalendarBloc(getCalendarTransactionsUseCase: useCase)
        ..add(SelectCalendarDate(date: DateTime.now())),
      child: const CalendarView(),
    );
  }
}

// ---------------------------------------------------
// View: the UI
// ---------------------------------------------------
class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  bool showSpends = true; // true = Spends, false = Categories
  DateTime visibleMonth = DateTime.now(); // month shown in calendar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: green,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ----- Top bar -----
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: dark),
                  ),
                  Expanded(
                    child: Text(
                      'Calendar',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: dark,
                      ),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 17,
                    backgroundColor: lightGreen,
                    child: Icon(Icons.notifications_none, color: dark, size: 20),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40), // green space like Figma

            // ----- White rounded sheet -----
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
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
                    bottomBar(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----- Month (left) and Year (right) -----
  Widget monthYearRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tap month = previous month
          GestureDetector(
            onTap: () {
              setState(() {
                visibleMonth = DateTime(visibleMonth.year, visibleMonth.month - 1);
              });
            },
            child: Row(
              children: [
                Text(DateFormat('MMMM').format(visibleMonth),
                    style: GoogleFonts.poppins(fontSize: 12, color: green)),
                const Icon(Icons.keyboard_arrow_down, size: 18, color: green),
              ],
            ),
          ),
          // Tap year = next year
          GestureDetector(
            onTap: () {
              setState(() {
                visibleMonth = DateTime(visibleMonth.year + 1, visibleMonth.month);
              });
            },
            child: Row(
              children: [
                Text('${visibleMonth.year}',
                    style: GoogleFonts.poppins(fontSize: 12, color: green)),
                const Icon(Icons.keyboard_arrow_down, size: 18, color: green),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----- Calendar days -----
  Widget calendarGrid() {
    final firstDay = DateTime(visibleMonth.year, visibleMonth.month, 1);
    final daysInMonth = DateTime(visibleMonth.year, visibleMonth.month + 1, 0).day;
    final emptyCells = firstDay.weekday - 1; // Monday = 0 empty cells

    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          // Week day names
          Row(
            children: [
              for (final n in names)
                Expanded(
                  child: Text(
                    n,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 9, color: blue),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),

          // Dates (7 columns)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: emptyCells + daysInMonth,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.4,
            ),
            itemBuilder: (context, index) {
              if (index < emptyCells) return const SizedBox(); // empty cell

              final day = index - emptyCells + 1;
              final date = DateTime(visibleMonth.year, visibleMonth.month, day);

              return BlocBuilder<CalendarBloc, CalendarState>(
                builder: (context, state) {
                  final selected = DateUtils.isSameDay(date, state.selectedDate);

                  return GestureDetector(
                    onTap: () {
                      context.read<CalendarBloc>().add(SelectCalendarDate(date: date));
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
                            color: selected ? Colors.white : dark,
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

  // ----- Spends / Categories buttons -----
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
          showSpends = (text == 'Spends');
        });
      },
      child: Container(
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? green : softGreen,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text, style: GoogleFonts.poppins(fontSize: 11, color: dark)),
      ),
    );
  }

  // ----- Loading / Error / List / Chart -----
  Widget content() {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        if (state.status == CalendarStatus.loading) {
          return const Center(child: CircularProgressIndicator(color: green));
        }

        if (state.status == CalendarStatus.failure) {
          return Center(child: Text(state.errorMessage ?? 'Something went wrong'));
        }

        return showSpends ? spendsList(state) : categoriesChart(state);
      },
    );
  }

  // ----- Spends list -----
  Widget spendsList(CalendarState state) {
    if (state.transactions.isEmpty) {
      return Center(
        child: Text('No transactions on this date',
            style: GoogleFonts.poppins(fontSize: 12, color: dark)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      itemCount: state.transactions.length,
      itemBuilder: (context, index) {
        final t = state.transactions[index];
        final income = t.type.toLowerCase() == 'income';

        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            children: [
              // Icon box
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: income ? const Color(0xFF6FB6FF) : blue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(categoryIcon(t.category), color: Colors.white),
              ),
              const SizedBox(width: 12),

              // Title and time
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.title.isEmpty ? t.category : t.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontSize: 12, fontWeight: FontWeight.w600, color: dark),
                    ),
                    Text(
                      DateFormat('HH:mm - MMMM dd').format(t.date),
                      style: GoogleFonts.poppins(fontSize: 9, color: blue),
                    ),
                  ],
                ),
              ),

              Container(width: 1, height: 36, color: green), // line

              // Category
              Expanded(
                flex: 2,
                child: Text(
                  t.category,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(fontSize: 10, color: dark),
                ),
              ),

              Container(width: 1, height: 36, color: green), // line

              // Amount
              Expanded(
                flex: 2,
                child: Text(
                  '${income ? '' : '-'}\$${t.amount.toStringAsFixed(2)}',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: income ? dark : blue,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ----- Categories chart -----
  Widget categoriesChart(CalendarState state) {
    // Add up amount of each category
    final Map<String, double> totals = {};
    for (final t in state.transactions) {
      totals[t.category] = (totals[t.category] ?? 0) + t.amount;
    }

    if (totals.isEmpty) {
      return Center(
        child: Text('No categories on this date',
            style: GoogleFonts.poppins(fontSize: 12, color: dark)),
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
      child: Column(
        children: [
          // Half pie chart
          SizedBox(
            width: 220,
            height: 110,
            child: CustomPaint(painter: HalfPie(values, colors)),
          ),
          const SizedBox(height: 14),

          // Legend (dot + name)
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
                    Text(names[i],
                        style: GoogleFonts.poppins(
                            fontSize: 10, fontWeight: FontWeight.w600, color: dark)),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ----- Bottom bar (design only) -----
  Widget bottomBar() {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: softGreen,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          navIcon(Icons.home_outlined, false),
          navIcon(Icons.search, true), // active
          navIcon(Icons.swap_horiz, false),
          navIcon(Icons.layers_outlined, false),
          navIcon(Icons.person_outline, false),
        ],
      ),
    );
  }

  Widget navIcon(IconData icon, bool active) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: active ? green : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: dark, size: 26),
    );
  }

  // ----- Icon for each category -----
  IconData categoryIcon(String category) {
    final name = category.toLowerCase();

    if (name.contains('food') || name.contains('grocer')) {
      return Icons.shopping_basket_outlined;
    }
    if (name.contains('transport')) return Icons.directions_bus_outlined;
    if (name.contains('rent')) return Icons.key_outlined;
    if (name.contains('medicine') || name.contains('health')) {
      return Icons.medication_outlined;
    }
    if (name.contains('saving')) return Icons.savings_outlined;

    return Icons.category_outlined;
  }
}

// ---------------------------------------------------
// Half pie chart painter
// ---------------------------------------------------
class HalfPie extends CustomPainter {
  final List<double> values;
  final List<Color> colors;

  HalfPie(this.values, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold<double>(0, (a, b) => a + b);
    if (total == 0) return;

    final radius = size.width / 2;
    final center = Offset(radius, size.height);
    final rect = Rect.fromCircle(center: center, radius: radius);

    double start = math.pi; // start from the left side

    for (int i = 0; i < values.length; i++) {
      final sweep = values[i] / total * math.pi; // size of this slice

      // Colored slice
      canvas.drawArc(rect, start, sweep, true,
          Paint()..color = colors[i % colors.length]);

      // White border
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

      // Percentage text in the middle of the slice
      final mid = start + sweep / 2;
      final pos = Offset(
        center.dx + math.cos(mid) * radius * 0.65,
        center.dy + math.sin(mid) * radius * 0.65,
      );
      final text = TextPainter(
        text: TextSpan(
          text:
          '${(values[i] / total * 100).toStringAsFixed(0)}%',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();

      text.paint(canvas, pos - Offset(text.width / 2, text.height / 2));

      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}