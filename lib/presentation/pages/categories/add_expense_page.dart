import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddExpenseScreen extends StatefulWidget {
  final String categoryName;

  const AddExpenseScreen({
    super.key,
    required this.categoryName,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  DateTime selectedDate = DateTime.now();

  final amountController = TextEditingController();
  final titleController = TextEditingController();
  final messageController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    titleController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    const mainGreen = Color(0xFF00D09E);
    const lightGreen = Color(0xFFF1FFF3);
    const softGreen = Color(0xFFDDF5E2);
    const darkGreen = Color(0xFF063F3F);

    return Scaffold(
      backgroundColor: mainGreen,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.14,
              child: Row(
                children: [
                  const SizedBox(width: 25),

                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: Text(
                        'Add Expenses',
                        style: GoogleFonts.poppins(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: darkGreen,
                        ),
                      ),
                    ),
                  ),

                  Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.only(right: 25),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: lightGreen,
                    ),
                    child: const Icon(
                      Icons.notifications_none,
                      size: 21,
                      color: darkGreen,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      32,
                      28,
                      32,
                      30,
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: darkGreen,
                          ),
                        ),

                        const SizedBox(height: 5),

                        GestureDetector(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );

                            if (date != null) {
                              setState(() {
                                selectedDate = date;
                              });
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            height: 34,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: softGreen,
                              borderRadius:
                              BorderRadius.circular(18),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: darkGreen,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.calendar_month,
                                  size: 18,
                                  color: mainGreen,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        Text(
                          'Category',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: darkGreen,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Container(
                          width: double.infinity,
                          height: 34,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: softGreen,
                            borderRadius:
                            BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              Text(
                                widget.categoryName,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: darkGreen,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                size: 18,
                                color: mainGreen,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        Text(
                          'Amount',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: darkGreen,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Container(
                          height: 34,
                          decoration: BoxDecoration(
                            color: softGreen,
                            borderRadius:
                            BorderRadius.circular(18),
                          ),
                          child: TextField(
                            controller: amountController,
                            keyboardType:
                            TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: '\$674,40',
                              border: InputBorder.none,
                              contentPadding:
                              EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: darkGreen,
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        Text(
                          'Expense Title',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: darkGreen,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Container(
                          height: 34,
                          decoration: BoxDecoration(
                            color: softGreen,
                            borderRadius:
                            BorderRadius.circular(18),
                          ),
                          child: TextField(
                            controller: titleController,
                            decoration: const InputDecoration(
                              hintText: 'Rent',
                              border: InputBorder.none,
                              contentPadding:
                              EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: darkGreen,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        Container(
                          width: double.infinity,
                          height: 135,
                          decoration: BoxDecoration(
                            color: softGreen,
                            borderRadius:
                            BorderRadius.circular(15),
                          ),
                          child: TextField(
                            controller: messageController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: 'Enter Message',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 11,
                                color: mainGreen,
                              ),
                              border: InputBorder.none,
                              contentPadding:
                              const EdgeInsets.all(10),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        Center(
                          child: SizedBox(
                            width: 140,
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainGreen,
                                foregroundColor: darkGreen,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Save',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
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
            ),
          ],
        ),
      ),
    );
  }
}