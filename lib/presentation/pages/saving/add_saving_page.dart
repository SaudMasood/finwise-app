import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
  static const mainGreen = Color(0xFF00D09E);
  static const lightGreen = Color(0xFFF1FFF3);
  static const softGreen = Color(0xFFDFF7E2);
  static const darkGreen = Color(0xFF052224);

  final TextEditingController dateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  String selectedCategory = '';

  bool isSaving = false;

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
    final double scale = (size.width / 375).clamp(0.85, 1.15);

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
                        'Add Savings',
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
                child: BlocListener<SavingsBloc, SavingsState>(
                  listenWhen: (previous, current) {
                    return previous.savingSuccess != current.savingSuccess ||
                        previous.errorMessage != current.errorMessage;
                  },
                  listener: (context, state) {
                    if (state.savingSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Savings added successfully'),
                        ),
                      );

                      Navigator.pop(context);
                      return;
                    }

                    if (state.errorMessage != null && !state.savingSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessage!)),
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
                          keyboardType: const TextInputType.numberWithOptions(
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

                        // Message box (label inside, like Figma)
                        Container(
                          width: double.infinity,
                          height: 150 * scale,
                          decoration: BoxDecoration(
                            color: softGreen,
                            borderRadius: BorderRadius.circular(20 * scale),
                          ),
                          child: TextField(
                            controller: messageController,
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            style: GoogleFonts.poppins(
                              fontSize: 12 * scale,
                              color: darkGreen,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter Message',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 12 * scale,
                                color: mainGreen,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(14 * scale),
                            ),
                          ),
                        ),

                        SizedBox(height: 28 * scale),

                        // Save button
                        Center(
                          child: SizedBox(
                            width: 125 * scale,
                            height: 32 * scale,
                            child: ElevatedButton(
                              onPressed: isSaving ? null : _saveSaving,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainGreen,
                                foregroundColor: darkGreen,
                                disabledBackgroundColor:
                                mainGreen.withOpacity(0.5),
                                elevation: 0,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: isSaving
                                  ? SizedBox(
                                width: 16 * scale,
                                height: 16 * scale,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: darkGreen,
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

  // ================= LABEL =================
  Widget _buildLabel(String text, double scale) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 12 * scale,
        fontWeight: FontWeight.w500,
        color: darkGreen,
      ),
    );
  }

  // ================= CALENDAR ICON (small green box) =================
  Widget _calendarIcon(double scale) {
    return Container(
      width: 24 * scale,
      height: 24 * scale,
      decoration: BoxDecoration(
        color: mainGreen,
        borderRadius: BorderRadius.circular(8 * scale),
      ),
      child: Icon(
        Icons.calendar_month_outlined,
        size: 15 * scale,
        color: darkGreen,
      ),
    );
  }

  // ================= TEXT FIELD =================
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
        color: softGreen,
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
          color: darkGreen,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16 * scale,
            vertical: 0,
          ),
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

  // ================= CATEGORY FIELD =================
  Widget _buildCategoryField(double scale) {
    return GestureDetector(
      onTap: () {
        final categories = context.read<SavingsBloc>().state.savingCategories;

        if (categories.isEmpty) {
          return;
        }

        showModalBottomSheet(
          context: context,
          backgroundColor: lightGreen,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          builder: (bottomSheetContext) {
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
                        color: darkGreen,
                      ),
                    ),
                    trailing: category == selectedCategory
                        ? const Icon(Icons.check, color: mainGreen)
                        : null,
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                      });

                      Navigator.pop(bottomSheetContext);
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
          color: softGreen,
          borderRadius: BorderRadius.circular(20 * scale),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedCategory,
                style: GoogleFonts.poppins(
                  fontSize: 12 * scale,
                  fontWeight: FontWeight.w500,
                  color: darkGreen,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20 * scale,
              color: mainGreen,
            ),
          ],
        ),
      ),
    );
  }

  // ================= DATE PICKER =================
  Future<void> _selectDate() async {
    final DateTime? result = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: mainGreen,
              onPrimary: Colors.white,
              onSurface: darkGreen,
            ),
          ),
          child: child!,
        );
      },
    );

    if (result == null) {
      return;
    }

    setState(() {
      selectedDate = result;
      dateController.text = _formatFullDate(result);
    });
  }

  // ================= SAVE =================
  void _saveSaving() {
    final amountText = amountController.text.trim();
    final title = titleController.text.trim();
    final message = messageController.text.trim();

    if (amountText.isEmpty) {
      _showMessage('Enter amount');
      return;
    }

    final double? amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) {
      _showMessage('Enter a valid amount');
      return;
    }

    if (selectedCategory.isEmpty) {
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

    setState(() {
      isSaving = true;
    });

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