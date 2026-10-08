import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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

class AddExpenseScreen extends StatelessWidget {
  final String categoryName;

  const AddExpenseScreen({
    super.key,
    this.categoryName = '',
  });

  @override
  Widget build(BuildContext context) {
    final dataSource = CategoryDataSource(
      firestore:
      FirebaseFirestore.instance,
      firebaseAuth:
      FirebaseAuth.instance,
    );

    final repository =
    CategoryRepositoryImpl(
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
      )..add(
        const WatchCategories(),
      ),
      child: AddExpenseView(
        categoryName:
        categoryName,
      ),
    );
  }
}

class AddExpenseView
    extends StatefulWidget {
  final String categoryName;

  const AddExpenseView({
    super.key,
    required this.categoryName,
  });

  @override
  State<AddExpenseView>
  createState() =>
      _AddExpenseViewState();
}

class _AddExpenseViewState
    extends State<AddExpenseView> {
  DateTime selectedDate =
  DateTime.now();

  String? selectedCategory;

  final amountController =
  TextEditingController();

  final titleController =
  TextEditingController();

  final messageController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.categoryName.isNotEmpty) {
      selectedCategory =
          widget.categoryName;
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
    const mainGreen =
    Color(0xFF00D09E);

    const lightGreen =
    Color(0xFFF1FFF3);

    const softGreen =
    Color(0xFFDDF5E2);

    const darkGreen =
    Color(0xFF063F3F);

    final height =
        MediaQuery.of(context)
            .size
            .height;

    return BlocListener<
        CategoryBloc,
        CategoryState>(
      listener:
          (context, state) {
        if (state.status ==
            CategoryStatus.saved &&
            state.savedType ==
                'expense') {
          Navigator.pop(
            context,
            true,
          );
        }

        if (state.status ==
            CategoryStatus.failure &&
            state.errorMessage !=
                null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage!,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor:
        mainGreen,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: height * .14,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 25,
                    ),

                    GestureDetector(
                      onTap: () =>
                          Navigator.pop(
                            context,
                          ),
                      child:
                      const Icon(
                        Icons.arrow_back,
                        color:
                        Colors.white,
                        size: 27,
                      ),
                    ),

                    Expanded(
                      child: Center(
                        child: Text(
                          'Add Expenses',
                          style: GoogleFonts
                              .poppins(
                            fontSize: 19,
                            fontWeight:
                            FontWeight
                                .w600,
                            color:
                            darkGreen,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      width: 32,
                      height: 32,
                      margin:
                      const EdgeInsets
                          .only(
                        right: 25,
                      ),
                      decoration:
                      const BoxDecoration(
                        color:
                        lightGreen,
                        shape:
                        BoxShape.circle,
                      ),
                      child:
                      const Icon(
                        Icons
                            .notifications_none,
                        color:
                        darkGreen,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  decoration:
                  const BoxDecoration(
                    color:
                    lightGreen,
                    borderRadius:
                    BorderRadius
                        .only(
                      topLeft:
                      Radius.circular(
                        50,
                      ),
                      topRight:
                      Radius.circular(
                        50,
                      ),
                    ),
                  ),
                  child:
                  SingleChildScrollView(
                    padding:
                    const EdgeInsets
                        .fromLTRB(
                      32,
                      28,
                      32,
                      30,
                    ),
                    child:
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        Text(
                          'Date',
                          style: GoogleFonts
                              .poppins(
                            fontSize: 12,
                            color:
                            darkGreen,
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        GestureDetector(
                          onTap: () async {
                            final date =
                            await showDatePicker(
                              context:
                              context,
                              initialDate:
                              selectedDate,
                              firstDate:
                              DateTime(
                                2020,
                              ),
                              lastDate:
                              DateTime(
                                2035,
                              ),
                            );

                            if (date !=
                                null) {
                              setState(() {
                                selectedDate =
                                    date;
                              });
                            }
                          },
                          child:
                          Container(
                            height: 34,
                            padding:
                            const EdgeInsets
                                .symmetric(
                              horizontal:
                              12,
                            ),
                            decoration:
                            BoxDecoration(
                              color:
                              softGreen,
                              borderRadius:
                              BorderRadius
                                  .circular(
                                18,
                              ),
                            ),
                            child:
                            Row(
                              children: [
                                Text(
                                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                  style:
                                  GoogleFonts.poppins(
                                    fontSize:
                                    11,
                                    color:
                                    darkGreen,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons
                                      .calendar_month,
                                  size:
                                  18,
                                  color:
                                  mainGreen,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 25,
                        ),

                        Text(
                          'Category',
                          style: GoogleFonts
                              .poppins(
                            fontSize: 12,
                            color:
                            darkGreen,
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        BlocBuilder<
                            CategoryBloc,
                            CategoryState>(
                          builder:
                              (context,
                              state) {
                            return GestureDetector(
                              onTap: () async {
                                if (state
                                    .categories
                                    .isEmpty) {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    const SnackBar(
                                      content:
                                      Text(
                                        'Add a category first',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                final result =
                                await showModalBottomSheet<
                                    String>(
                                  context:
                                  context,
                                  backgroundColor:
                                  lightGreen,
                                  builder:
                                      (_) {
                                    return ListView
                                        .separated(
                                      padding:
                                      const EdgeInsets.all(
                                        20,
                                      ),
                                      itemCount:
                                      state.categories.length,
                                      separatorBuilder:
                                          (_, __) =>
                                      const Divider(),
                                      itemBuilder:
                                          (_, index) {
                                        final category =
                                        state.categories[index];

                                        return ListTile(
                                          title:
                                          Text(
                                            category,
                                          ),
                                          onTap:
                                              () {
                                            Navigator.pop(
                                              context,
                                              category,
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                );

                                if (result !=
                                    null) {
                                  setState(() {
                                    selectedCategory =
                                        result;
                                  });
                                }
                              },
                              child:
                              Container(
                                height: 34,
                                padding:
                                const EdgeInsets
                                    .symmetric(
                                  horizontal:
                                  12,
                                ),
                                decoration:
                                BoxDecoration(
                                  color:
                                  softGreen,
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    18,
                                  ),
                                ),
                                child:
                                Row(
                                  children: [
                                    Text(
                                      selectedCategory ??
                                          'Select the category',
                                      style:
                                      GoogleFonts.poppins(
                                        fontSize:
                                        11,
                                        color:
                                        darkGreen,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons
                                          .keyboard_arrow_down,
                                      color:
                                      mainGreen,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(
                          height: 25,
                        ),

                        Text(
                          'Amount',
                          style: GoogleFonts
                              .poppins(
                            fontSize: 12,
                            color:
                            darkGreen,
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        Container(
                          height: 34,
                          decoration:
                          BoxDecoration(
                            color:
                            softGreen,
                            borderRadius:
                            BorderRadius
                                .circular(
                              18,
                            ),
                          ),
                          child:
                          TextField(
                            controller:
                            amountController,
                            keyboardType:
                            const TextInputType
                                .numberWithOptions(
                              decimal:
                              true,
                            ),
                            decoration:
                            const InputDecoration(
                              hintText:
                              '0.00',
                              border:
                              InputBorder
                                  .none,
                              contentPadding:
                              EdgeInsets
                                  .symmetric(
                                horizontal:
                                12,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 25,
                        ),

                        Text(
                          'Expense Title',
                          style: GoogleFonts
                              .poppins(
                            fontSize: 12,
                            color:
                            darkGreen,
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        Container(
                          height: 34,
                          decoration:
                          BoxDecoration(
                            color:
                            softGreen,
                            borderRadius:
                            BorderRadius
                                .circular(
                              18,
                            ),
                          ),
                          child:
                          TextField(
                            controller:
                            titleController,
                            decoration:
                            const InputDecoration(
                              hintText:
                              'Expense title',
                              border:
                              InputBorder
                                  .none,
                              contentPadding:
                              EdgeInsets
                                  .symmetric(
                                horizontal:
                                12,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        Container(
                          height: 135,
                          decoration:
                          BoxDecoration(
                            color:
                            softGreen,
                            borderRadius:
                            BorderRadius
                                .circular(
                              15,
                            ),
                          ),
                          child:
                          TextField(
                            controller:
                            messageController,
                            maxLines: 5,
                            decoration:
                            InputDecoration(
                              hintText:
                              'Enter Message',
                              hintStyle:
                              GoogleFonts
                                  .poppins(
                                fontSize:
                                11,
                                color:
                                mainGreen,
                              ),
                              border:
                              InputBorder
                                  .none,
                              contentPadding:
                              const EdgeInsets
                                  .all(
                                10,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        Center(
                          child:
                          SizedBox(
                            width: 140,
                            height: 30,
                            child:
                            ElevatedButton(
                              onPressed:
                                  () {
                                _save(
                                  context,
                                );
                              },
                              style:
                              ElevatedButton
                                  .styleFrom(
                                backgroundColor:
                                mainGreen,
                                foregroundColor:
                                darkGreen,
                                elevation:
                                0,
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

  void _save(BuildContext context) {
    final amount =
    double.tryParse(
      amountController.text
          .trim()
          .replaceAll(
        ',',
        '.',
      ),
    );

    if (selectedCategory ==
        null ||
        selectedCategory!
            .isEmpty) {
      _message(
        context,
        'Select a category',
      );
      return;
    }

    if (amount ==
        null ||
        amount <= 0) {
      _message(
        context,
        'Enter a valid amount',
      );
      return;
    }

    if (titleController.text
        .trim()
        .isEmpty) {
      _message(
        context,
        'Enter expense title',
      );
      return;
    }

    final expense =
    ExpenseEntity(
      id: '',
      category:
      selectedCategory!,
      title:
      titleController.text
          .trim(),
      amount: amount,
      message:
      messageController.text
          .trim(),
      date: selectedDate,
      createdAt:
      DateTime.now(),
      type: 'expense',
    );

    context
        .read<CategoryBloc>()
        .add(
      AddExpense(
        expense:
        expense,
      ),
    );
  }

  void _message(
      BuildContext context,
      String text,
      ) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}