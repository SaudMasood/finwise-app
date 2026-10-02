import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

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
              height: height * 0.13,
              child: Row(
                children: [
                  const SizedBox(width: 20),

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
                        'Notification',
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
                      color: lightGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_none,
                      color: darkGreen,
                      size: 21,
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
                    topLeft: Radius.circular(55),
                    topRight: Radius.circular(55),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.075,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 22),

                        Text(
                          'Today',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: darkGreen,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: mainGreen,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: const Icon(
                                Icons.notifications_none,
                                color: darkGreen,
                                size: 22,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reminder!',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: darkGreen,
                                    ),
                                  ),
                                  Text(
                                    'Set up your automatic savings to\n'
                                        'meet your savings goal...',
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      height: 1.2,
                                      color: darkGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              '17:00 - April 24',
                              style: GoogleFonts.poppins(
                                fontSize: 8,
                                color: blue,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Container(
                          height: 1,
                          color: mainGreen,
                        ),

                        const SizedBox(height: 15),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: mainGreen,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: const Icon(
                                Icons.star_border,
                                color: darkGreen,
                                size: 22,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'New Update',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: darkGreen,
                                    ),
                                  ),
                                  Text(
                                    'Set up your automatic savings to\n'
                                        'meet your savings goal...',
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      height: 1.2,
                                      color: darkGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              '17:00 - April 24',
                              style: GoogleFonts.poppins(
                                fontSize: 8,
                                color: blue,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Container(
                          height: 1,
                          color: mainGreen,
                        ),

                        const SizedBox(height: 15),

                        Text(
                          'Yesterday',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: darkGreen,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: mainGreen,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: const Icon(
                                Icons.attach_money,
                                color: darkGreen,
                                size: 24,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Transactions',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: darkGreen,
                                    ),
                                  ),
                                  Text(
                                    'A new transaction has been registered',
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      color: darkGreen,
                                    ),
                                  ),
                                  Text(
                                    'Groceries | Pantry | -\$100.00',
                                    style: GoogleFonts.poppins(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w600,
                                      color: blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              '17:00 - April 24',
                              style: GoogleFonts.poppins(
                                fontSize: 8,
                                color: blue,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Container(
                          height: 1,
                          color: mainGreen,
                        ),

                        const SizedBox(height: 15),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: mainGreen,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: const Icon(
                                Icons.notifications_none,
                                color: darkGreen,
                                size: 22,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reminder!',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: darkGreen,
                                    ),
                                  ),
                                  Text(
                                    'Set up your automatic savings to\n'
                                        'meet your savings goal...',
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      height: 1.2,
                                      color: darkGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              '17:00 - April 24',
                              style: GoogleFonts.poppins(
                                fontSize: 8,
                                color: blue,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Container(
                          height: 1,
                          color: mainGreen,
                        ),

                        const SizedBox(height: 15),

                        Text(
                          'This Weekend',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: darkGreen,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: mainGreen,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: const Icon(
                                Icons.trending_down,
                                color: darkGreen,
                                size: 22,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Expense Record',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: darkGreen,
                                    ),
                                  ),
                                  Text(
                                    'We recommend that you be more\n'
                                        'attentive to your finances.',
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      height: 1.2,
                                      color: darkGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              '17:00 - April 24',
                              style: GoogleFonts.poppins(
                                fontSize: 8,
                                color: blue,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Container(
                          height: 1,
                          color: mainGreen,
                        ),

                        const SizedBox(height: 15),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: mainGreen,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: const Icon(
                                Icons.attach_money,
                                color: darkGreen,
                                size: 24,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Transactions',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: darkGreen,
                                    ),
                                  ),
                                  Text(
                                    'A new transaction has been registered',
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      color: darkGreen,
                                    ),
                                  ),
                                  Text(
                                    'Food | Dinner | -\$974.40',
                                    style: GoogleFonts.poppins(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w600,
                                      color: blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),
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