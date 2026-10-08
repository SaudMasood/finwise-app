import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/datasources/categoriesdatasorces.dart';
import '../../../data/repositories/categories/categories_repository_impl.dart';
import '../../../domain/usecases/categories/addcategryusecase.dart';
import '../../../domain/usecases/categories/addexpnseusecse.dart';
import '../../../domain/usecases/categories/addincome.dart';
import '../../../domain/usecases/categories/getcategories_usecase.dart';
import '../../../domain/usecases/categories/getexpenseusecase.dart';
import '../../bloc/categories/categories_bloc.dart';
import '../../bloc/categories/categories_event.dart';
import '../../bloc/categories/categories_state.dart';
import 'category_expense_page.dart';

class CategoriesScreen extends StatelessWidget {
  final void Function({
  required double totalBalance,
  required double totalExpense,
  required double totalIncome,
  }) onOpenSavings;

  const CategoriesScreen({
    super.key,
    required this.onOpenSavings,
  });

  @override
  Widget build(BuildContext context) {
    final dataSource = CategoryDataSource(
      firestore: FirebaseFirestore.instance,
      firebaseAuth: FirebaseAuth.instance,
    );

    final repository = CategoryRepositoryImpl(
      dataSource: dataSource,
    );

    return BlocProvider(
      create: (_) => CategoryBloc(
        getCategoriesUseCase:
        GetCategoriesUseCase(
          repository: repository,
        ),
        getExpensesUseCase:
        GetExpensesUseCase(
          repository: repository,
        ),
        addCategoryUseCase:
        AddCategoryUseCase(
          repository: repository,
        ),
        addExpenseUseCase:
        AddExpenseUseCase(
          repository: repository,
        ),
        addIncomeUseCase:
        AddIncomeUseCase(
          repository: repository,
        ),
        firebaseAuth:
        FirebaseAuth.instance,
      )
        ..add(const WatchCategories())
        ..add(const WatchAllTransactions()),
      child: CategoriesView(
        onOpenSavings: onOpenSavings,
      ),
    );
  }
}

class CategoriesView extends StatefulWidget {
  final void Function({
  required double totalBalance,
  required double totalExpense,
  required double totalIncome,
  }) onOpenSavings;

  const CategoriesView({
    super.key,
    required this.onOpenSavings,
  });

  static const mainGreen =
  Color(0xFF00D09E);

  static const lightGreen =
  Color(0xFFF1FFF3);

  static const softGreen =
  Color(0xFFDFF7E2);

  static const darkGreen =
  Color(0xFF052224);

  static const blue =
  Color(0xFF6DB6FE);

  static const selectedBlue =
  Color(0xFF0068FF);

  @override
  State<CategoriesView> createState() =>
      _CategoriesViewState();
}

class _CategoriesViewState
    extends State<CategoriesView> {
  int selectedIndex = 0;

  static const mainGreen =
      CategoriesView.mainGreen;

  static const lightGreen =
      CategoriesView.lightGreen;

  static const softGreen =
      CategoriesView.softGreen;

  static const darkGreen =
      CategoriesView.darkGreen;

  static const blue =
      CategoriesView.blue;

  static const selectedBlue =
      CategoriesView.selectedBlue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainGreen,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 14),

            Row(
              children: [
                const SizedBox(width: 25),

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
                      'Categories',
                      style:
                      GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight:
                        FontWeight.w600,
                        color: darkGreen,
                      ),
                    ),
                  ),
                ),

                Container(
                  width: 34,
                  height: 34,
                  margin:
                  const EdgeInsets.only(
                    right: 25,
                  ),
                  decoration:
                  const BoxDecoration(
                    color: lightGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_none,
                    color: darkGreen,
                    size: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            BlocBuilder<CategoryBloc,
                CategoryState>(
              builder: (context, state) {
                return Padding(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 36,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _summaryItem(
                          label:
                          'Total Balance',
                          value:
                          '\$${state.totalBalance.toStringAsFixed(2)}',
                          valueColor:
                          Colors.white,
                        ),
                      ),

                      Container(
                        width: 1,
                        height: 42,
                        color: Colors.white,
                      ),

                      const SizedBox(
                        width: 18,
                      ),

                      Expanded(
                        child: _summaryItem(
                          label:
                          'Total Expense',
                          value:
                          '-\$${state.totalExpense.toStringAsFixed(2)}',
                          valueColor:
                          selectedBlue,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 14),

            BlocBuilder<CategoryBloc,
                CategoryState>(
              builder: (context, state) {
                final income =
                    state.totalIncome;

                final expense =
                    state.totalExpense;

                double percentage = 0;

                if (income > 0) {
                  percentage =
                      (expense / income) *
                          100;
                }

                percentage =
                    percentage.clamp(
                      0.0,
                      100.0,
                    );

                return Padding(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 36,
                  ),
                  child: LayoutBuilder(
                    builder:
                        (context, constraints) {
                      final totalWidth =
                          constraints.maxWidth;

                      const barHeight =
                      26.0;

                      double fillWidth =
                          totalWidth *
                              percentage /
                              100;

                      const minimumFill =
                      54.0;

                      if (fillWidth > 0 &&
                          fillWidth <
                              minimumFill) {
                        fillWidth =
                            minimumFill;
                      }

                      if (fillWidth >
                          totalWidth) {
                        fillWidth =
                            totalWidth;
                      }

                      final amountOnDark =
                          fillWidth >
                              totalWidth -
                                  110;

                      return Container(
                        width:
                        double.infinity,
                        height: barHeight,
                        decoration:
                        BoxDecoration(
                          color:
                          Colors.white,
                          borderRadius:
                          BorderRadius
                              .circular(
                            20,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius
                              .circular(
                            20,
                          ),
                          child: Stack(
                            children: [
                              AnimatedContainer(
                                duration:
                                const Duration(
                                  milliseconds:
                                  500,
                                ),
                                curve:
                                Curves.easeOut,
                                width:
                                fillWidth,
                                height:
                                barHeight,
                                padding:
                                const EdgeInsets
                                    .only(
                                  left: 12,
                                ),
                                alignment:
                                Alignment
                                    .centerLeft,
                                decoration:
                                BoxDecoration(
                                  color:
                                  darkGreen,
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    20,
                                  ),
                                ),
                                child: Text(
                                  '${percentage.toStringAsFixed(0)}%',
                                  style:
                                  GoogleFonts
                                      .poppins(
                                    fontSize: 10,
                                    fontWeight:
                                    FontWeight
                                        .w500,
                                    color:
                                    Colors
                                        .white,
                                  ),
                                ),
                              ),

                              Positioned(
                                right: 14,
                                top: 0,
                                bottom: 0,
                                child: Center(
                                  child: Text(
                                    '\$${income.toStringAsFixed(2)}',
                                    style:
                                    GoogleFonts
                                        .poppins(
                                      fontSize:
                                      10,
                                      fontWeight:
                                      FontWeight
                                          .w600,
                                      color:
                                      amountOnDark
                                          ? Colors
                                          .white
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
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            BlocBuilder<CategoryBloc,
                CategoryState>(
              builder: (context, state) {
                final income =
                    state.totalIncome;

                double percentage = 0;

                if (income > 0) {
                  percentage =
                      (state.totalExpense /
                          income) *
                          100;
                }

                percentage =
                    percentage.clamp(
                      0.0,
                      100.0,
                    );

                return Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_box_outlined,
                      size: 15,
                      color: darkGreen,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${percentage.toStringAsFixed(0)}% Of Your Expenses, Looks Good.',
                      style:
                      GoogleFonts.poppins(
                        fontSize: 11,
                        color: darkGreen,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 22),

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
                child: BlocBuilder<
                    CategoryBloc,
                    CategoryState>(
                  builder:
                      (context, state) {
                    if (state.status ==
                        CategoryStatus
                            .failure) {
                      return Center(
                        child: Text(
                          state.errorMessage ??
                              'Something went wrong',
                          textAlign:
                          TextAlign.center,
                          style:
                          GoogleFonts
                              .poppins(
                            color:
                            darkGreen,
                          ),
                        ),
                      );
                    }

                    final categories =
                    [...state.categories];

                    if (!categories.any(
                          (category) =>
                      category
                          .toLowerCase() ==
                          'saving',
                    )) {
                      categories.add(
                        'Saving',
                      );
                    }

                    return GridView.builder(
                      padding:
                      const EdgeInsets
                          .fromLTRB(
                        35,
                        30,
                        35,
                        120,
                      ),
                      itemCount:
                      categories.length +
                          1,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 22,
                        childAspectRatio: .78,
                      ),
                      itemBuilder:
                          (context, index) {
                        if (index ==
                            categories.length) {
                          return GestureDetector(
                            onTap: () {
                              _showAddCategoryDialog(
                                context,
                              );
                            },
                            child:
                            const _CategoryItem(
                              icon: Icons.add,
                              label: 'More',
                              selected: false,
                            ),
                          );
                        }

                        final category =
                        categories[index];

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex =
                                  index;
                            });

                            if (category
                                .toLowerCase() ==
                                'saving') {
                              widget
                                  .onOpenSavings(
                                totalBalance:
                                state
                                    .totalBalance,
                                totalExpense:
                                state
                                    .totalExpense,
                                totalIncome:
                                state
                                    .totalIncome,
                              );

                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CategoryExpenseScreen(
                                      categoryName:
                                      category,
                                    ),
                              ),
                            );
                          },
                          child: _CategoryItem(
                            icon:
                            _icon(category),
                            label: category,
                            selected:
                            selectedIndex ==
                                index,
                          ),
                        );
                      },
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

  Widget _summaryItem({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Padding(
      padding:
      const EdgeInsets.only(left: 4),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons
                    .account_balance_wallet_outlined,
                size: 12,
                color: darkGreen,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style:
                GoogleFonts.poppins(
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
              style:
              GoogleFonts.poppins(
                fontSize: 22,
                fontWeight:
                FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static IconData _icon(
      String category,
      ) {
    final name =
    category.toLowerCase();

    if (name.contains('food')) {
      return Icons.restaurant;
    }

    if (name.contains('transport') ||
        name.contains('travel')) {
      return Icons
          .directions_bus_outlined;
    }

    if (name.contains('medicine') ||
        name.contains('health')) {
      return Icons
          .medication_outlined;
    }

    if (name.contains('grocer')) {
      return Icons
          .shopping_basket_outlined;
    }

    if (name.contains('rent')) {
      return Icons.key_outlined;
    }

    if (name.contains('gift')) {
      return Icons
          .card_giftcard_outlined;
    }

    if (name.contains('saving')) {
      return Icons
          .savings_outlined;
    }

    if (name.contains('entertainment') ||
        name.contains('ticket')) {
      return Icons
          .confirmation_number_outlined;
    }

    if (name.contains('drink')) {
      return Icons.local_bar_outlined;
    }

    if (name.contains('sport') ||
        name.contains('ball')) {
      return Icons
          .sports_soccer_outlined;
    }

    return Icons.category_outlined;
  }

  void _showAddCategoryDialog(
      BuildContext context,
      ) {
    final controller =
    TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(16),
          ),
          title: Center(
            child: Text(
              'New Category',
              style:
              GoogleFonts.poppins(
                fontSize: 16,
                fontWeight:
                FontWeight.w600,
                color: darkGreen,
              ),
            ),
          ),
          content: TextField(
            controller: controller,
            decoration:
            InputDecoration(
              hintText: 'Write...',
              filled: true,
              fillColor: softGreen,
              border:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(
                  20,
                ),
                borderSide:
                BorderSide.none,
              ),
            ),
          ),
          actions: [
            Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 165,
                    height: 34,
                    child: ElevatedButton(
                      onPressed: () {
                        final name =
                        controller
                            .text
                            .trim();

                        if (name.isEmpty) {
                          return;
                        }

                        context
                            .read<
                            CategoryBloc>()
                            .add(
                          AddNewCategory(
                            category:
                            name,
                          ),
                        );

                        Navigator.pop(
                          dialogContext,
                        );
                      },
                      style:
                      ElevatedButton
                          .styleFrom(
                        backgroundColor:
                        mainGreen,
                        foregroundColor:
                        darkGreen,
                        elevation: 0,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(
                            20,
                          ),
                        ),
                      ),
                      child:
                      const Text(
                        'Save',
                      ),
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.pop(
                        dialogContext,
                      );
                    },
                    child:
                    const Text(
                      'Cancel',
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CategoryItem
    extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const _CategoryItem({
    required this.icon,
    required this.label,
    required this.selected,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return Column(
      children: [
        AnimatedContainer(
          duration:
          const Duration(
            milliseconds: 200,
          ),
          width: 80,
          height: 80,
          decoration:
          BoxDecoration(
            color: selected
                ? CategoriesView
                .selectedBlue
                : CategoriesView
                .blue,
            borderRadius:
            BorderRadius.circular(
              20,
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 44,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          label,
          maxLines: 1,
          overflow:
          TextOverflow.ellipsis,
          textAlign:
          TextAlign.center,
          style:
          GoogleFonts.poppins(
            fontSize: 12,
            fontWeight:
            FontWeight.w500,
            color:
            CategoriesView
                .darkGreen,
          ),
        ),
      ],
    );
  }
}