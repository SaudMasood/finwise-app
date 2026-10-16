
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
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
  State<SavingCategoryScreen> createState() =>
      _SavingCategoryScreenState();
}

class _SavingCategoryScreenState extends State<SavingCategoryScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<SavingsBloc>().add(
        LoadSavings(category: widget.categoryName),
      );
    });
  }

  bool get isDark =>
      Theme.of(context).brightness == Brightness.dark;

  Color get backgroundColor =>
      isDark ? AppColors.darkBackground : AppColors.primaryGreen;

  Color get surfaceColor =>
      isDark ? AppColors.darkSurface : AppColors.lightGreen;

  Color get textColor =>
      isDark ? AppColors.darkText : AppColors.darkGreen;

  Color get secondaryTextColor =>
      isDark ? AppColors.darkSecondaryText : AppColors.darkGreen;

  Color get buttonColor =>
      isDark ? AppColors.lightGreen : AppColors.primaryGreen;

  Color get buttonTextColor =>
      isDark ? AppColors.darkBackground : AppColors.darkGreen;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.width / 375).clamp(0.85, 1.15);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(height: 14 * scale),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25 * scale),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: isDark
                          ? AppColors.darkText
                          : AppColors.darkGreen,
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
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 32 * scale,
                    height: 32 * scale,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkCard
                          : AppColors.lightGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_none,
                      color: textColor,
                      size: 20 * scale,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 26 * scale),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50 * scale),
                    topRight: Radius.circular(50 * scale),
                  ),
                ),
                child: BlocBuilder<SavingsBloc, SavingsState>(
                  builder: (context, state) {
                    if (state.status == SavingsStatus.loading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: buttonColor,
                        ),
                      );
                    }

                    if (state.status == SavingsStatus.failure) {
                      return Center(
                        child: Text(
                          state.errorMessage ?? 'Something went wrong',
                          style: GoogleFonts.poppins(
                            fontSize: 12 * scale,
                            color: textColor,
                          ),
                        ),
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 35 * scale,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    _smallLabel('Goal', scale),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        '\$${goal.toStringAsFixed(2)}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 24 * scale,
                                          fontWeight: FontWeight.w600,
                                          color: textColor,
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
                                          color: buttonColor,
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
                                  color: AppColors.blue,
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
                                              backgroundColor:
                                              AppColors.white.withOpacity(
                                                0.35,
                                              ),
                                              valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                AppColors.strongBlue,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            _icon(widget.categoryName),
                                            color: AppColors.white,
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
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 22 * scale),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 35 * scale,
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final totalWidth = constraints.maxWidth;
                              final height = 26 * scale;
                              final fillWidth =
                                  totalWidth * percentage / 100;

                              return Container(
                                width: double.infinity,
                                height: height,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.darkCard
                                      : AppColors.primaryGreen,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Stack(
                                    children: [
                                      AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 500,
                                        ),
                                        curve: Curves.easeOut,
                                        width: fillWidth,
                                        height: height,
                                        padding: EdgeInsets.only(
                                          left: 12 * scale,
                                        ),
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                          color: AppColors.darkGreen,
                                          borderRadius:
                                          BorderRadius.circular(20),
                                        ),
                                        child: percentage > 0
                                            ? Text(
                                          '${percentage.toStringAsFixed(0)}%',
                                          style: GoogleFonts.poppins(
                                            fontSize: 10 * scale,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.white,
                                          ),
                                        )
                                            : null,
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
                                              color: isDark
                                                  ? AppColors.darkText
                                                  : AppColors.darkGreen,
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 35 * scale,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_box_outlined,
                                  size: 14 * scale,
                                  color: secondaryTextColor,
                                ),
                                SizedBox(width: 6 * scale),
                                Flexible(
                                  child: Text(
                                    '${percentage.toStringAsFixed(0)}% Of Your Expenses, Looks Good.',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11 * scale,
                                      color: secondaryTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 18 * scale),
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.symmetric(
                              horizontal: 35 * scale,
                            ),
                            children: _buildSavings(state, scale),
                          ),
                        ),
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
                                backgroundColor: buttonColor,
                                foregroundColor: buttonTextColor,
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

  Widget _smallLabel(String text, double scale) {
    return Row(
      children: [
        Icon(
          Icons.check_box_outlined,
          size: 12 * scale,
          color: secondaryTextColor,
        ),
        SizedBox(width: 4 * scale),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 11 * scale,
            color: secondaryTextColor,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSavings(SavingsState state, double scale) {
    if (state.savings.isEmpty) {
      return [
        SizedBox(height: 35 * scale),
        Center(
          child: Text(
            'No savings yet',
            style: GoogleFonts.poppins(
              fontSize: 12 * scale,
              color: textColor,
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
      if (lastMonth != saving.date.month ||
          lastYear != saving.date.year) {
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
                      color: textColor,
                    ),
                  ),
                ),
                if (firstHeader)
                  Container(
                    width: 30 * scale,
                    height: 30 * scale,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(10 * scale),
                    ),
                    child: Icon(
                      Icons.calendar_month_outlined,
                      size: 17 * scale,
                      color: AppColors.white,
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
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(15 * scale),
                ),
                child: Icon(
                  _icon(widget.categoryName),
                  color: AppColors.white,
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
                        color: textColor,
                      ),
                    ),
                    Text(
                      '${saving.date.hour}:${saving.date.minute.toString().padLeft(2, '0')} - ${_month(saving.date.month)} ${saving.date.day}',
                      style: GoogleFonts.poppins(
                        fontSize: 10 * scale,
                        fontWeight: FontWeight.w600,
                        color: AppColors.strongBlue,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8 * scale),
              Text(
                '\$${saving.amount.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: 12.5 * scale,
                  fontWeight: FontWeight.w500,
                  color: textColor,
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
