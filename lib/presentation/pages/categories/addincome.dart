
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
import '../../../data/datasources/categoriesdatasorces.dart';
import '../../../data/repositories/categories/categories_repository_impl.dart';
import '../../../domain/entities/categories/expnse.dart';
import '../../../domain/usecases/categories/addcategryusecase.dart';
import '../../../domain/usecases/categories/addexpnseusecse.dart';
import '../../../domain/usecases/categories/addincome.dart';
import '../../../domain/usecases/categories/getcategories_usecase.dart';
import '../../../domain/usecases/categories/getexpenseusecase.dart';
import '../../bloc/categories/categories_bloc.dart';
import '../../bloc/categories/categories_event.dart';
import '../../bloc/categories/categories_state.dart';

class AddIncomeScreen extends StatelessWidget {
  final String categoryName;

  const AddIncomeScreen({
    super.key,
    this.categoryName = '',
  });

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    final repository = CategoryRepositoryImpl(
      dataSource: CategoryDataSource(
        firestore: FirebaseFirestore.instance,
        firebaseAuth: auth,
      ),
    );

    return BlocProvider(
      create: (_) => CategoryBloc(
        getCategoriesUseCase:
        GetCategoriesUseCase(repository: repository),
        getExpensesUseCase:
        GetExpensesUseCase(repository: repository),
        addCategoryUseCase:
        AddCategoryUseCase(repository: repository),
        addExpenseUseCase:
        AddExpenseUseCase(repository: repository),
        addIncomeUseCase:
        AddIncomeUseCase(repository: repository),
        firebaseAuth: auth,
      )..add(const WatchCategories()),
      child: AddIncomeView(categoryName: categoryName),
    );
  }
}

class AddIncomeView extends StatefulWidget {
  final String categoryName;

  const AddIncomeView({
    super.key,
    required this.categoryName,
  });

  @override
  State<AddIncomeView> createState() => _AddIncomeViewState();
}

class _AddIncomeViewState extends State<AddIncomeView> {
  DateTime selectedDate = DateTime.now();
  String? selectedCategory;
  bool isSaving = false;

  final amountController = TextEditingController();
  final titleController = TextEditingController();
  final messageController = TextEditingController();

  bool get isDark =>
      Theme.of(context).brightness == Brightness.dark;

  Color get pageBackground =>
      isDark ? AppColors.darkBackground : AppColors.primaryGreen;

  Color get formBackground =>
      isDark ? AppColors.darkSurface : AppColors.lightGreen;

  // Keep the Figma mint-green fields in both themes.
  Color get fieldBackground => AppColors.softGreen;

  Color get primaryText =>
      isDark ? AppColors.darkText : AppColors.darkGreen;

  Color get secondaryText =>
      isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText;

  @override
  void initState() {
    super.initState();

    if (widget.categoryName.isNotEmpty) {
      selectedCategory = widget.categoryName;
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    titleController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return BlocListener<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state.status == CategoryStatus.saved &&
            state.savedType == 'income') {
          isSaving = false;
          Navigator.pop(context, true);
        }

        if (state.status == CategoryStatus.failure &&
            state.errorMessage != null) {
          isSaving = false;
          _message(context, state.errorMessage!);
        }
      },
      child: Scaffold(
        backgroundColor: pageBackground,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: height * .14,
                child: Row(
                  children: [
                    const SizedBox(width: 25),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back,
                        color: isDark
                            ? AppColors.darkText
                            : Colors.white,
                        size: 27,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Add Income',
                          style: GoogleFonts.poppins(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.darkText
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      margin: const EdgeInsets.only(right: 25),
                      decoration: BoxDecoration(
                        color: formBackground,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.notifications_none,
                        color: primaryText,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: formBackground,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      32, 28, 32, 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Date'),
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: _selectDate,
                          child: Container(
                            height: 38,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: fieldBackground,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    DateFormatHelper.format(selectedDate),
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: AppColors.darkGreen,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.calendar_month,
                                  size: 18,
                                  color: AppColors.primaryGreen,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        _label('Category'),
                        const SizedBox(height: 5),
                        BlocBuilder<CategoryBloc, CategoryState>(
                          builder: (context, state) {
                            return GestureDetector(
                              onTap: () => _selectCategory(state.categories),
                              child: Container(
                                height: 38,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: fieldBackground,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        selectedCategory ??
                                            'Select the category',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: selectedCategory == null
                                              ? Colors.black54
                                              : AppColors.darkGreen,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColors.primaryGreen,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 25),
                        _label('Amount'),
                        const SizedBox(height: 5),
                        _inputField(
                          controller: amountController,
                          hint: '0.00',
                          keyboardType:
                          const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                        const SizedBox(height: 25),
                        _label('Income Title'),
                        const SizedBox(height: 5),
                        _inputField(
                          controller: titleController,
                          hint: 'Income title',
                        ),
                        const SizedBox(height: 30),
                        Container(
                          height: 135,
                          decoration: BoxDecoration(
                            color: fieldBackground,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextField(
                            controller: messageController,
                            maxLines: 5,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.darkGreen,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter Message',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: SizedBox(
                            width: 140,
                            height: 40,
                            child: ElevatedButton(
                              onPressed:
                              isSaving ? null : _save,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                AppColors.primaryGreen,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor:
                                AppColors.primaryGreen.withValues(
                                  alpha: 0.6,
                                ),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(20),
                                ),
                              ),
                              child: isSaving
                                  ? const SizedBox(
                                width: 18,
                                height: 18,
                                child:
                                CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : Text(
                                'Save',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 12,
        color: primaryText,
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: fieldBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: AppColors.darkGreen,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.black54,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 9,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        final darkMode =
            Theme.of(context).brightness == Brightness.dark;

        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme(
              brightness: darkMode
                  ? Brightness.dark
                  : Brightness.light,
              primary: AppColors.primaryGreen,
              onPrimary: Colors.white,
              secondary: AppColors.primaryGreen,
              onSecondary: Colors.white,
              error: AppColors.error,
              onError: Colors.white,
              surface: darkMode
                  ? AppColors.darkSurface
                  : AppColors.lightSurface,
              onSurface: darkMode
                  ? AppColors.darkText
                  : AppColors.darkGreen,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: darkMode
                  ? AppColors.darkSurface
                  : AppColors.lightSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null && mounted) {
      setState(() => selectedDate = date);
    }
  }

  Future<void> _selectCategory(List<String> categories) async {
    if (categories.isEmpty) {
      _message(context, 'Add a category first');
      return;
    }

    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: formBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20),
            itemCount: categories.length,
            separatorBuilder: (_, __) => Divider(
              color: isDark
                  ? AppColors.darkDivider
                  : AppColors.lightDivider,
            ),
            itemBuilder: (_, index) {
              final category = categories[index];

              return ListTile(
                title: Text(
                  category,
                  style: GoogleFonts.poppins(
                    color: primaryText,
                  ),
                ),
                onTap: () =>
                    Navigator.pop(sheetContext, category),
              );
            },
          ),
        );
      },
    );

    if (result != null && mounted) {
      setState(() => selectedCategory = result);
    }
  }

  void _save() {
    if (isSaving) return;

    final amount = double.tryParse(
      amountController.text.trim().replaceAll(',', '.'),
    );

    if (selectedCategory == null ||
        selectedCategory!.isEmpty) {
      _message(context, 'Select a category');
      return;
    }

    if (amount == null || amount <= 0) {
      _message(context, 'Enter a valid amount');
      return;
    }

    if (titleController.text.trim().isEmpty) {
      _message(context, 'Enter income title');
      return;
    }

    final income = ExpenseEntity(
      id: '',
      category: selectedCategory!,
      title: titleController.text.trim(),
      amount: amount,
      message: messageController.text.trim(),
      date: selectedDate,
      createdAt: DateTime.now(),
      type: 'income',
    );

    setState(() => isSaving = true);

    context.read<CategoryBloc>().add(
      AddIncome(income: income),
    );
  }

  void _message(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }
}

class DateFormatHelper {
  static String format(DateTime date) {
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

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
