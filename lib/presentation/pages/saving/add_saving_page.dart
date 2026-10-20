import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
import '../../../domain/entities/saving/saving.dart';
import '../../bloc/saving/saving_bloc.dart';
import '../../bloc/saving/saving_event.dart';
import '../../bloc/saving/saving_state.dart';

class AddSavingsPage extends StatefulWidget {
  final String categoryName;

  const AddSavingsPage({
    super.key,
    required this.categoryName,
  });

  @override
  State<AddSavingsPage> createState() => _AddSavingsPageState();
}

class _AddSavingsPageState extends State<AddSavingsPage> {
  final dateController = TextEditingController();
  final amountController = TextEditingController();
  final titleController = TextEditingController();
  final messageController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  late String selectedCategory;
  bool isSaving = false;

  bool get isDark =>
      Theme.of(context).brightness == Brightness.dark;

  Color get backgroundColor =>
      isDark ? AppColors.darkBackground : AppColors.primaryGreen;

  Color get surfaceColor =>
      isDark ? AppColors.darkSurface : AppColors.lightGreen;

  Color get fieldColor =>
      isDark ? AppColors.darkSearchField : AppColors.softGreen;

  Color get textColor =>
      isDark ? AppColors.darkText : AppColors.darkGreen;

  Color get secondaryTextColor =>
      isDark ? AppColors.darkSecondaryText : AppColors.primaryGreen;

  Color get buttonColor =>
      isDark ? AppColors.lightGreen : AppColors.primaryGreen;

  Color get buttonTextColor =>
      isDark ? AppColors.darkBackground : AppColors.darkGreen;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.categoryName;
    dateController.text = _formatFullDate(selectedDate);
  }

  @override
  void dispose() {
    dateController.dispose();
    amountController.dispose();
    titleController.dispose();
    messageController.dispose();
    super.dispose();
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
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: isDark ? AppColors.darkText : AppColors.white,
                      size: 26 * scale,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Add Savings',
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
                child: BlocListener<SavingsBloc, SavingsState>(
                  listenWhen: (previous, current) =>
                  previous.savingSuccess != current.savingSuccess ||
                      previous.errorMessage != current.errorMessage,
                  listener: (context, state) {
                    if (!mounted) return;

                    if (state.savingSuccess) {
                      setState(() => isSaving = false);

                      context.read<SavingsBloc>().add(
                        const ClearSavingFeedback(),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Savings added successfully'),
                        ),
                      );

                      Navigator.pop(context);
                    } else if (state.errorMessage != null) {
                      setState(() => isSaving = false);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessage!)),
                      );

                      context.read<SavingsBloc>().add(
                        const ClearSavingFeedback(),
                      );
                    }
                  },
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      40 * scale,
                      34 * scale,
                      40 * scale,
                      30 * scale,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Date', scale),
                        SizedBox(height: 6 * scale),
                        _buildTextField(
                          controller: dateController,
                          scale: scale,
                          readOnly: true,
                          showCalendar: true,
                          onTap: _selectDate,
                        ),
                        SizedBox(height: 24 * scale),

                        _buildLabel('Category', scale),
                        SizedBox(height: 6 * scale),
                        _buildCategoryField(scale),
                        SizedBox(height: 24 * scale),

                        _buildLabel('Amount', scale),
                        SizedBox(height: 6 * scale),
                        _buildTextField(
                          controller: amountController,
                          scale: scale,
                          keyboardType:
                          const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                        SizedBox(height: 24 * scale),

                        _buildLabel('Expense Title', scale),
                        SizedBox(height: 6 * scale),
                        _buildTextField(
                          controller: titleController,
                          scale: scale,
                        ),
                        SizedBox(height: 24 * scale),

                        Container(
                          width: double.infinity,
                          height: 150 * scale,
                          decoration: BoxDecoration(
                            color: fieldColor,
                            borderRadius:
                            BorderRadius.circular(20 * scale),
                          ),
                          child: TextField(
                            controller: messageController,
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            style: GoogleFonts.poppins(
                              fontSize: 12 * scale,
                              color: textColor,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter Message',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 12 * scale,
                                color: secondaryTextColor,
                              ),
                              border: InputBorder.none,
                              contentPadding:
                              EdgeInsets.all(14 * scale),
                            ),
                          ),
                        ),
                        SizedBox(height: 28 * scale),

                        Center(
                          child: SizedBox(
                            width: 125 * scale,
                            height: 36 * scale,
                            child: ElevatedButton(
                              onPressed: isSaving ? null : _saveSaving,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                foregroundColor: buttonTextColor,
                                disabledBackgroundColor:
                                buttonColor.withOpacity(0.5),
                                disabledForegroundColor:
                                buttonTextColor.withOpacity(0.7),
                                elevation: 0,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(20),
                                ),
                              ),
                              child: isSaving
                                  ? SizedBox(
                                width: 16 * scale,
                                height: 16 * scale,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: buttonTextColor,
                                ),
                              )
                                  : Text(
                                'Save',
                                style: GoogleFonts.poppins(
                                  fontSize: 12 * scale,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20 * scale),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, double scale) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 12 * scale,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
    );
  }

  Widget _calendarIcon(double scale) {
    return Container(
      width: 24 * scale,
      height: 24 * scale,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(8 * scale),
      ),
      child: Icon(
        Icons.calendar_month_outlined,
        size: 15 * scale,
        color: buttonTextColor,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required double scale,
    bool readOnly = false,
    bool showCalendar = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
  }) {
    return Container(
      width: double.infinity,
      height: 38 * scale,
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(20 * scale),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        textAlignVertical: TextAlignVertical.center,
        style: GoogleFonts.poppins(
          fontSize: 12 * scale,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding:
          EdgeInsets.symmetric(horizontal: 16 * scale),
          suffixIcon: showCalendar
              ? Padding(
            padding: EdgeInsets.only(right: 10 * scale),
            child: _calendarIcon(scale),
          )
              : null,
          suffixIconConstraints: BoxConstraints(
            minWidth: 40 * scale,
            minHeight: 38 * scale,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryField(double scale) {
    return BlocBuilder<SavingsBloc, SavingsState>(
      buildWhen: (previous, current) =>
      previous.savingCategories != current.savingCategories,
      builder: (context, state) {
        final categories = state.savingCategories;

        return GestureDetector(
          onTap: () {
            if (categories.isEmpty) {
              _showMessage('No categories available yet');
              return;
            }

            showModalBottomSheet<void>(
              context: context,
              backgroundColor: surfaceColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
              ),
              builder: (sheetContext) {
                return SafeArea(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20),
                    children: categories.map((category) {
                      return ListTile(
                        title: Text(
                          category,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: textColor,
                          ),
                        ),
                        trailing: category == selectedCategory
                            ? Icon(Icons.check, color: buttonColor)
                            : null,
                        onTap: () {
                          setState(() {
                            selectedCategory = category;
                          });
                          Navigator.pop(sheetContext);
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            );
          },
          child: Container(
            width: double.infinity,
            height: 38 * scale,
            padding: EdgeInsets.symmetric(horizontal: 16 * scale),
            decoration: BoxDecoration(
              color: fieldColor,
              borderRadius: BorderRadius.circular(20 * scale),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedCategory,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 12 * scale,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 20 * scale,
                  color: secondaryTextColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        final dark =
            Theme.of(context).brightness == Brightness.dark;

        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryGreen,
              brightness: dark ? Brightness.dark : Brightness.light,
              surface:
              dark ? AppColors.darkSurface : AppColors.lightGreen,
              onSurface:
              dark ? AppColors.darkText : AppColors.darkGreen,
            ),
          ),
          child: child!,
        );
      },
    );

    if (result == null || !mounted) return;

    setState(() {
      selectedDate = result;
      dateController.text = _formatFullDate(result);
    });
  }

  void _saveSaving() {
    final amountText = amountController.text.trim();
    final title = titleController.text.trim();
    final message = messageController.text.trim();

    if (amountText.isEmpty) {
      _showMessage('Enter amount');
      return;
    }

    final amount = double.tryParse(amountText);

    if (amount == null || !amount.isFinite || amount <= 0) {
      _showMessage('Enter a valid amount');
      return;
    }

    if (selectedCategory.trim().isEmpty) {
      _showMessage('Select category');
      return;
    }

    if (title.isEmpty) {
      _showMessage('Enter saving title');
      return;
    }

    final saving = SavingEntity(
      id: '',
      category: selectedCategory,
      title: title,
      amount: amount,
      message: message,
      date: selectedDate,
      createdAt: DateTime.now(),
    );

    setState(() => isSaving = true);

    context.read<SavingsBloc>().add(
      AddSaving(saving: saving),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _formatFullDate(DateTime date) {
    return '${_monthName(date.month)} ${date.day}, ${date.year}';
  }

  String _monthName(int month) {
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