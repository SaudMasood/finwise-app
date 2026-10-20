
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
import '../../bloc/saving/saving_bloc.dart';
import '../../bloc/saving/saving_event.dart';
import '../../bloc/saving/saving_state.dart';
import '../analytics/cleander.dart';
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

  Color get fieldColor =>
      isDark ? AppColors.darkCard : AppColors.primaryGreen;

  Color get buttonColor =>
      isDark ? AppColors.lightGreen : AppColors.primaryGreen;

  Color get buttonTextColor =>
      isDark ? AppColors.darkBackground : AppColors.darkGreen;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadCategory();
    });
  }

  void _loadCategory() {
    final bloc = context.read<SavingsBloc>();

    bloc.add(LoadSavings(category: widget.categoryName));
    bloc.add(LoadSavingGoal(category: widget.categoryName));
  }

  void _openCalendar() {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => const CalendarScreen(),
      ),
    );
  }

  void _openAddSavings() {
    final bloc = context.read<SavingsBloc>();

    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: AddSavingsPage(
            categoryName: widget.categoryName,
          ),
        ),
      ),
    ).then((_) {
      if (mounted) _loadCategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.width / 375).clamp(0.85, 1.15).toDouble();

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
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Icon(
                        Icons.arrow_back,
                        color: isDark ? AppColors.darkText : AppColors.darkGreen,
                        size: 25 * scale,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.categoryName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 17 * scale,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkText : AppColors.darkGreen,
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
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(48 * scale),
                  ),
                ),
                child: BlocBuilder<SavingsBloc, SavingsState>(
                  builder: (context, state) {
                    if (state.status == SavingsStatus.loading &&
                        state.savings.isEmpty) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: buttonColor,
                        ),
                      );
                    }

                    if (state.status == SavingsStatus.failure &&
                        state.savings.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(24 * scale),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                state.errorMessage ??
                                    'Unable to load savings.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 12 * scale,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: _loadCategory,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final savings = state.savings
                        .where(
                          (saving) =>
                              saving.category.toLowerCase() ==
                              widget.categoryName.toLowerCase(),
                        )
                        .toList()
                      ..sort((a, b) => b.date.compareTo(a.date));

                    final totalSaved = savings.fold<double>(
                      0,
                      (sum, saving) => sum + saving.amount,
                    );

                    final goal = state.goal;
                    final percentage = goal > 0
                        ? (totalSaved / goal * 100)
                            .clamp(0.0, 100.0)
                            .toDouble()
                        : 0.0;

                    return Column(
                      children: [
                        SizedBox(height: 29 * scale),

                        // Goal and amount saved summary.
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 35 * scale,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _smallLabel('Goal', scale),
                                    SizedBox(height: 2 * scale),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '\$${goal.toStringAsFixed(2)}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 22 * scale,
                                          fontWeight: FontWeight.w700,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 12 * scale),
                                    _smallLabel('Amount Saved', scale),
                                    SizedBox(height: 2 * scale),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '\$${totalSaved.toStringAsFixed(2)}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 22 * scale,
                                          fontWeight: FontWeight.w700,
                                          color: buttonColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12 * scale),
                              Container(
                                width: 118 * scale,
                                height: 118 * scale,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.darkCard
                                      : AppColors.blue,
                                  borderRadius:
                                      BorderRadius.circular(30 * scale),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 75 * scale,
                                      height: 75 * scale,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SizedBox.expand(
                                            child: CircularProgressIndicator(
                                              value: percentage / 100,
                                              strokeWidth: 3,
                                              backgroundColor: AppColors.white
                                                  .withOpacity(0.35),
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                AppColors.strongBlue,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            _icon(widget.categoryName),
                                            color: AppColors.white,
                                            size: 38 * scale,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5 * scale),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 7 * scale,
                                      ),
                                      child: Text(
                                        widget.categoryName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontSize: 11 * scale,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20 * scale),

                        // Goal progress bar.
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 35 * scale,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SizedBox(
                              height: 25 * scale,
                              width: double.infinity,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final fillWidth = constraints.maxWidth *
                                      percentage /
                                      100;

                                  return Stack(
                                    children: [
                                      Positioned.fill(
                                        child: ColoredBox(
                                          color: isDark
                                              ? AppColors.darkCard
                                              : AppColors.primaryGreen,
                                        ),
                                      ),
                                      AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 450),
                                        curve: Curves.easeOutCubic,
                                        width: fillWidth,
                                        height: 25 * scale,
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? AppColors.lightGreen
                                              : AppColors.darkGreen,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      if (fillWidth > 38 * scale)
                                        Positioned(
                                          left: 11 * scale,
                                          top: 0,
                                          bottom: 0,
                                          child: Center(
                                            child: Text(
                                              '${percentage.toStringAsFixed(0)}%',
                                              style: GoogleFonts.poppins(
                                                fontSize: 10 * scale,
                                                fontWeight: FontWeight.w500,
                                                color: isDark
                                                    ? AppColors.darkBackground
                                                    : AppColors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      Positioned(
                                        right: 10 * scale,
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
                                  );
                                },
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 9 * scale),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 35 * scale,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_box_outlined,
                                size: 13 * scale,
                                color: secondaryTextColor,
                              ),
                              SizedBox(width: 6 * scale),
                              Expanded(
                                child: Text(
                                  goal > 0
                                      ? '${percentage.toStringAsFixed(0)}% of your saving goal completed.'
                                      : 'Set a goal to track your savings progress.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 10.5 * scale,
                                    color: secondaryTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20 * scale),

                        // Savings history.
                        Expanded(
                          child: savings.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20 * scale),
                                    child: Text(
                                      'No savings yet.\nAdd your first saving!',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12 * scale,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                )
                              : ListView(
                                  physics: const BouncingScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 30 * scale,
                                  ),
                                  children: _buildSavings(savings, scale),
                                ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(
                            top: 8 * scale,
                            bottom: 24 * scale,
                          ),
                          child: SizedBox(
                            width: 145 * scale,
                            height: 36 * scale,
                            child: ElevatedButton(
                              onPressed: _openAddSavings,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                foregroundColor: buttonTextColor,
                                elevation: 0,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
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
          size: 11 * scale,
          color: secondaryTextColor,
        ),
        SizedBox(width: 4 * scale),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 10.5 * scale,
            color: secondaryTextColor,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSavings(List<dynamic> savings, double scale) {
    final widgets = <Widget>[];
    int? lastMonth;
    int? lastYear;

    for (final saving in savings) {
      if (lastMonth != saving.date.month ||
          lastYear != saving.date.year) {
        lastMonth = saving.date.month;
        lastYear = saving.date.year;

        widgets.add(
          Padding(
            padding: EdgeInsets.only(bottom: 13 * scale),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${_month(saving.date.month)} ${saving.date.year}',
                    style: GoogleFonts.poppins(
                      fontSize: 12 * scale,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _openCalendar,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 29 * scale,
                      height: 29 * scale,
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(9 * scale),
                      ),
                      child: Icon(
                        Icons.calendar_month_outlined,
                        size: 17 * scale,
                        color: buttonTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      widgets.add(
        Padding(
          padding: EdgeInsets.only(bottom: 15 * scale),
          child: Row(
            children: [
              Container(
                width: 43 * scale,
                height: 43 * scale,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.blue,
                  borderRadius: BorderRadius.circular(14 * scale),
                ),
                child: Icon(
                  _icon(widget.categoryName),
                  color: AppColors.white,
                  size: 25 * scale,
                ),
              ),
              SizedBox(width: 12 * scale),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      saving.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 12 * scale,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                    Text(
                      '${saving.date.hour.toString().padLeft(2, '0')}:'
                      '${saving.date.minute.toString().padLeft(2, '0')} - '
                      '${_month(saving.date.month)} ${saving.date.day}',
                      style: GoogleFonts.poppins(
                        fontSize: 9.5 * scale,
                        fontWeight: FontWeight.w500,
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
                  fontSize: 11.5 * scale,
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
    if (name.contains('emergency')) {
      return Icons.health_and_safety_outlined;
    }

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
