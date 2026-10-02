import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    const mainGreen = Color(0xFF00D09E);
    const lightGreen = Color(0xFFF1FFF3);
    const cardGreen = Color(0xFF00CFA0);
    const softGreen = Color(0xFFDDF5E2);
    const darkGreen = Color(0xFF063F3F);
    const blue = Color(0xFF168BFF);

    return Scaffold(
      backgroundColor: mainGreen,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.07,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.025),

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hi, Welcome Back',
                                  style: GoogleFonts.poppins(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                    color: darkGreen,
                                  ),
                                ),
                                Text(
                                  'Good Morning',
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: darkGreen,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.notifications_none,
                                size: 21,
                                color: darkGreen,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: height * 0.04),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.account_balance_wallet_outlined,
                                        size: 13,
                                        color: darkGreen,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Total Balance',
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          color: darkGreen,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '\$7,783.00',
                                    style: GoogleFonts.poppins(
                                      fontSize: 21,
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
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.receipt_long_outlined,
                                        size: 13,
                                        color: darkGreen,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Total Expense',
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          color: darkGreen,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
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

                        const SizedBox(height: 15),

                        Container(
                          width: double.infinity,
                          height: 23,
                          decoration: BoxDecoration(
                            color: softGreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: width * 0.17,
                                height: 23,
                                decoration: BoxDecoration(
                                  color: darkGreen,
                                  borderRadius:
                                  BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    '30%',
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
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

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Icon(
                              Icons.check_box_outlined,
                              size: 13,
                              color: darkGreen,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '30% Of Your Expenses, Looks Good.',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: darkGreen,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: height * 0.035),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: cardGreen,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 55,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: darkGreen,
                                          width: 2,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.directions_car_outlined,
                                        size: 32,
                                        color: darkGreen,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      'Savings',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: darkGreen,
                                      ),
                                    ),
                                    Text(
                                      'On Goals',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: darkGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                width: 1,
                                height: 85,
                                color: Colors.white,
                              ),

                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.layers_outlined,
                                            size: 28,
                                            color: darkGreen,
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Revenue Last Week',
                                                style:
                                                GoogleFonts.poppins(
                                                  fontSize: 9,
                                                  color: darkGreen,
                                                ),
                                              ),
                                              Text(
                                                '\$4.000.00',
                                                style:
                                                GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight:
                                                  FontWeight.w600,
                                                  color: darkGreen,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      const Divider(
                                        color: Colors.white,
                                        thickness: 1,
                                      ),

                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.restaurant_outlined,
                                            size: 28,
                                            color: darkGreen,
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Food Last Week',
                                                style:
                                                GoogleFonts.poppins(
                                                  fontSize: 9,
                                                  color: darkGreen,
                                                ),
                                              ),
                                              Text(
                                                '-\$100.00',
                                                style:
                                                GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight:
                                                  FontWeight.w600,
                                                  color: blue,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: height * 0.035),

                        Container(
                          width: double.infinity,
                          height: 49,
                          decoration: BoxDecoration(
                            color: softGreen,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'Daily',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: darkGreen,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'Weekly',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: darkGreen,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: mainGreen,
                                    borderRadius:
                                    BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Monthly',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: darkGreen,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF5AAFFF),
                              ),
                              child: const Icon(
                                Icons.layers_outlined,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                            const SizedBox(width: 13),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Salary',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: darkGreen,
                                    ),
                                  ),
                                  Text(
                                    '18:27 - April 30',
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      color: blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 35,
                              color: mainGreen,
                            ),
                            const SizedBox(width: 15),
                            SizedBox(
                              width: 55,
                              child: Text(
                                'Monthly',
                                style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  color: darkGreen,
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 35,
                              color: mainGreen,
                            ),
                            const SizedBox(width: 15),
                            Text(
                              '\$4.000,00',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: darkGreen,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

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
                                Icons.shopping_bag_outlined,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                            const SizedBox(width: 13),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Groceries',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: darkGreen,
                                    ),
                                  ),
                                  Text(
                                    '17:00 - April 24',
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      color: blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 35,
                              color: mainGreen,
                            ),
                            const SizedBox(width: 15),
                            SizedBox(
                              width: 55,
                              child: Text(
                                'Pantry',
                                style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  color: darkGreen,
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 35,
                              color: mainGreen,
                            ),
                            const SizedBox(width: 15),
                            Text(
                              '-\$100,00',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: blue,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

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
                                Icons.volunteer_activism_outlined,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                            const SizedBox(width: 13),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Rent',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: darkGreen,
                                    ),
                                  ),
                                  Text(
                                    '8:30 - April 15',
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      color: blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 35,
                              color: mainGreen,
                            ),
                            const SizedBox(width: 15),
                            SizedBox(
                              width: 55,
                              child: Text(
                                'Rent',
                                style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  color: darkGreen,
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 35,
                              color: mainGreen,
                            ),
                            const SizedBox(width: 15),
                            Text(
                              '-\$674,40',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: blue,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
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