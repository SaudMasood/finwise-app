import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bloc/saving/saving_bloc.dart';
import '../../bloc/saving/saving_event.dart';
import '../../bloc/saving/saving_state.dart';
import 'add_saving_page.dart';

class SavingCategoryScreen extends StatefulWidget {
  final String categoryName;

  const SavingCategoryScreen({
    super.key,
    required this.categoryName,
  });

  @override
  State<SavingCategoryScreen> createState() => _SavingCategoryScreenState();
}

class _SavingCategoryScreenState extends State<SavingCategoryScreen> {
  static const mainGreen = Color(0xFF00D09E);
  static const lightGreen = Color(0xFFF1FFF3);
  static const blue = Color(0xFF6DB6FE);
  static const selectedBlue = Color(0xFF0068FF);
  static const darkGreen = Color(0xFF052224);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SavingsBloc>().add(
        LoadSavings(category: widget.categoryName),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.width / 375).clamp(0.85, 1.15);

    return Scaffold(
      backgroundColor: mainGreen,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(height: 14 * scale),

            // ================= APP BAR =================
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25 * scale),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 26 * scale,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.categoryName,
                        style: GoogleFonts.poppins(
                          fontSize: 18 * scale,
                          fontWeight: FontWeight.w600,
                          color: darkGreen,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 32 * scale,
                    height: 32 * scale,
                    decoration: const BoxDecoration(
                      color: lightGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_none,
                      color: darkGreen,
                      size: 20 * scale,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 26 * scale),

            // ================= BODY =================
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50 * scale),
                    topRight: Radius.circular(50 * scale),
                  ),
                ),
                child: BlocBuilder<SavingsBloc, SavingsState>(
                  builder: (context, state) {
                    if (state.status == SavingsStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(color: mainGreen),
                      );
                    }

                    final totalSaved = state.savings.fold<double>(
                      0,
                          (sum, saving) => sum + saving.amount,
                    );

                    final goal = state.goal;

                    double percentage = 0;
                    if (goal > 0) {
                      percentage = (totalSaved / goal) * 100;
                    }
                    percentage = percentage.clamp(0.0, 100.0);

                    return Column(
                      children: [
                        SizedBox(height: 28 * scale),

                        // ===== Goal / Amount saved + category card =====
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 35 * scale),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _smallLabel('Goal', scale),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        '\$${goal.toStringAsFixed(2)}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 24 * scale,
                                          fontWeight: FontWeight.w600,
                                          color: darkGreen,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 14 * scale),
                                    _smallLabel('Amount Saved', scale),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        '\$${totalSaved.toStringAsFixed(2)}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 24 * scale,
                                          fontWeight: FontWeight.w600,
                                          color: mainGreen,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10 * scale),
                              Container(
                                width: 140 * scale,
                                height: 140 * scale,
                                decoration: BoxDecoration(
                                  color: blue,
                                  borderRadius:
                                  BorderRadius.circular(32 * scale),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 84 * scale,
                                      height: 84 * scale,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SizedBox(
                                            width: 84 * scale,
                                            height: 84 * scale,
                                            child: CircularProgressIndicator(
                                              value: percentage / 100,
                                              strokeWidth: 3,
                                              backgroundColor: Colors.white
                                                  .withOpacity(0.7),
                                              valueColor:
                                              const AlwaysStoppedAnimation(
                                                selectedBlue,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            _icon(widget.categoryName),
                                            color: Colors.white,
                                            size: 42 * scale,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 6 * scale),
                                    Text(
                                      widget.categoryName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12 * scale,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 22 * scale),

                        // ===== Progress bar =====
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 35 * scale),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final totalWidth = constraints.maxWidth;
                              final height = 26 * scale;

                              double fillWidth = totalWidth * percentage / 100;
                              if (fillWidth < 52 * scale) {
                                fillWidth = 52 * scale;
                              }
                              if (fillWidth > totalWidth) {
                                fillWidth = totalWidth;
                              }

                              return Container(
                                width: double.infinity,
                                height: height,
                                decoration: BoxDecoration(
                                  color: mainGreen,
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
                                        padding:
                                        EdgeInsets.only(left: 12 * scale),
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                          color: darkGreen,
                                          borderRadius:
                                          BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          '${percentage.toStringAsFixed(0)}%',
                                          style: GoogleFonts.poppins(
                                            fontSize: 10 * scale,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 14 * scale,
                                        top: 0,
                                        bottom: 0,
                                        child: Center(
                                          child: Text(
                                            '\$${goal.toStringAsFixed(2)}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 10 * scale,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
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

                        // ===== Message =====
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 35 * scale),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_box_outlined,
                                  size: 14 * scale,
                                  color: darkGreen,
                                ),
                                SizedBox(width: 6 * scale),
                                Text(
                                  '${percentage.toStringAsFixed(0)}% Of Your Expenses, Looks Good.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11 * scale,
                                    color: darkGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 18 * scale),

                        // ===== Savings list =====
                        Expanded(
                          child: ListView(
                            padding:
                            EdgeInsets.symmetric(horizontal: 35 * scale),
                            children: [
                              ..._buildSavings(state, scale),
                            ],
                          ),
                        ),

                        // ===== Add Savings button =====
                        Padding(
                          padding: EdgeInsets.only(
                            top: 8 * scale,
                            bottom: 24 * scale,
                          ),
                          child: SizedBox(
                            width: 125 * scale,
                            height: 32 * scale,
                            child: ElevatedButton(
                              onPressed: () {
                                final bloc = context.read<SavingsBloc>();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: bloc,
                                      child: AddSavingsPage(
                                        categoryName: widget.categoryName,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainGreen,
                                foregroundColor: darkGreen,
                                elevation: 0,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Add Savings',
                                style: GoogleFonts.poppins(
                                  fontSize: 12 * scale,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
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
    );
  }

  // ================= SMALL LABEL (Goal / Amount Saved) =================
  Widget _smallLabel(String text, double scale) {
    return Row(
      children: [
        Icon(
          Icons.check_box_outlined,
          size: 12 * scale,
          color: darkGreen,
        ),
        SizedBox(width: 4 * scale),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 11 * scale,
            color: darkGreen,
          ),
        ),
      ],
    );
  }

  // ================= SAVINGS LIST (grouped by month) =================
  List<Widget> _buildSavings(SavingsState state, double scale) {
    if (state.savings.isEmpty) {
      return [
        SizedBox(height: 35 * scale),
        Center(
          child: Text(
            'No savings yet',
            style: GoogleFonts.poppins(
              fontSize: 12 * scale,
              color: darkGreen,
            ),
          ),
        ),
      ];
    }

    final List<Widget> widgets = [];
    int? lastMonth;
    int? lastYear;
    bool firstHeader = true;

    for (final saving in state.savings) {
      if (lastMonth != saving.date.month || lastYear != saving.date.year) {
        lastMonth = saving.date.month;
        lastYear = saving.date.year;

        widgets.add(
          Padding(
            padding: EdgeInsets.only(bottom: 14 * scale),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _month(saving.date.month),
                    style: GoogleFonts.poppins(
                      fontSize: 12 * scale,
                      fontWeight: FontWeight.w500,
                      color: darkGreen,
                    ),
                  ),
                ),
                if (firstHeader)
                  Container(
                    width: 30 * scale,
                    height: 30 * scale,
                    decoration: BoxDecoration(
                      color: mainGreen,
                      borderRadius: BorderRadius.circular(10 * scale),
                    ),
                    child: Icon(
                      Icons.calendar_month_outlined,
                      size: 17 * scale,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        );

        firstHeader = false;
      }

      widgets.add(
        Padding(
          padding: EdgeInsets.only(bottom: 16 * scale),
          child: Row(
            children: [
              Container(
                width: 50 * scale,
                height: 50 * scale,
                decoration: BoxDecoration(
                  color: blue,
                  borderRadius: BorderRadius.circular(15 * scale),
                ),
                child: Icon(
                  _icon(widget.categoryName),
                  color: Colors.white,
                  size: 28 * scale,
                ),
              ),
              SizedBox(width: 14 * scale),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      saving.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 12.5 * scale,
                        fontWeight: FontWeight.w500,
                        color: darkGreen,
                      ),
                    ),
                    Text(
                      '${saving.date.hour}:${saving.date.minute.toString().padLeft(2, '0')} - ${_month(saving.date.month)} ${saving.date.day}',
                      style: GoogleFonts.poppins(
                        fontSize: 10 * scale,
                        fontWeight: FontWeight.w600,
                        color: selectedBlue,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '\$${saving.amount.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: 12.5 * scale,
                  fontWeight: FontWeight.w500,
                  color: darkGreen,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return widgets;
  }

  static IconData _icon(String category) {
    final name = category.toLowerCase();

    if (name.contains('travel')) return Icons.flight_outlined;
    if (name.contains('house')) return Icons.home_work_outlined;
    if (name.contains('car')) return Icons.directions_car_outlined;
    if (name.contains('wedding')) return Icons.celebration_outlined;

    return Icons.savings_outlined;
  }

  String _month(int month) {
    const months = [
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

    return months[month - 1];
  }
}