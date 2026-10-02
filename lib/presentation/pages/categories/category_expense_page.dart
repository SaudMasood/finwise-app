import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'add_expense_page.dart';

class CategoryExpenseScreen extends StatelessWidget {
  final String categoryName;

  const CategoryExpenseScreen({
    super.key,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    const mainGreen = Color(0xFF00D09E);
    const lightGreen = Color(0xFFF1FFF3);
    const darkGreen = Color(0xFF063F3F);
    const blue = Color(0xFF168BFF);

    return Scaffold(
      backgroundColor: mainGreen,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.29,
              child: Column(
                children: [
                  const SizedBox(height: 15),

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
                          size: 27,
                        ),
                      ),

                      Expanded(
                        child: Center(
                          child: Text(
                            categoryName,
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

                  const SizedBox(height: 28),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                '▧ Total Balance',
                                style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  color: darkGreen,
                                ),
                              ),
                              Text(
                                '\$7,783.00',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          width: 1,
                          height: 38,
                          color: darkGreen,
                        ),

                        const SizedBox(width: 20),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                '▧ Total Expense',
                                style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  color: darkGreen,
                                ),
                              ),
                              Text(
                                '-\$1.187.40',
                                style: GoogleFonts.poppins(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                  color: blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45),
                    child: Container(
                      height: 22,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDDF5E2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: width * 0.17,
                            height: 22,
                            decoration: BoxDecoration(
                              color: darkGreen,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                '30%',
                                style: GoogleFonts.poppins(
                                  fontSize: 8,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                '\$20,000.00',
                                style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: darkGreen,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '☑ 30% Of Your Expenses, Looks Good.',
                    style: GoogleFonts.poppins(
                      fontSize: 9,
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
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.07,
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 25),

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'March',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: darkGreen,
                              ),
                            ),
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: mainGreen,
                                borderRadius:
                                BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.calendar_month_outlined,
                                size: 18,
                                color: darkGreen,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF168BFF),
                              ),
                              child: const Icon(
                                Icons.directions_bus_outlined,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    categoryName == 'Transport'
                                        ? 'Fuel'
                                        : 'Expense',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: darkGreen,
                                    ),
                                  ),
                                  Text(
                                    '18:27 - March 30',
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              '-\$3.53',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: blue,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF62B0FF),
                              ),
                              child: const Icon(
                                Icons.directions_bus_outlined,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Car Parts',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: darkGreen,
                                    ),
                                  ),
                                  Text(
                                    '15:00 - March 30',
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              '-\$26.75',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: blue,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Text(
                          'February',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: darkGreen,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF168BFF),
                              ),
                              child: const Icon(
                                Icons.directions_bus_outlined,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'New Tires',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: darkGreen,
                                    ),
                                  ),
                                  Text(
                                    '12:47 - February 10',
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              '-\$373.99',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: blue,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF62B0FF),
                              ),
                              child: const Icon(
                                Icons.directions_bus_outlined,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Car Wash',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: darkGreen,
                                    ),
                                  ),
                                  Text(
                                    '9:30 - February 09',
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              '-\$9.74',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: blue,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF168BFF),
                              ),
                              child: const Icon(
                                Icons.directions_bus_outlined,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Public Transport',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: darkGreen,
                                    ),
                                  ),
                                  Text(
                                    '7:50 - February 01',
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              '-\$1.24',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: blue,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        Center(
                          child: SizedBox(
                            width: 140,
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddExpenseScreen(
                                          categoryName: categoryName,
                                        ),
                                  ),
                                );
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
                                'Add Expenses',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
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