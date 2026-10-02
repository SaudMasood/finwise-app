import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  int selectedTab = 0;

  final List<String> tabs = [
    'Daily',
    'Weekly',
    'Monthly',
    'Year',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    const mainGreen = Color(0xFF00D09E);
    const lightGreen = Color(0xFFF1FFF3);
    const softGreen = Color(0xFFDDF5E2);
    const darkGreen = Color(0xFF063F3F);
    const blue = Color(0xFF168BFF);

    return Scaffold(
      backgroundColor: mainGreen,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.18,
              child: Column(
                children: [
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      const SizedBox(width: 22),

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
                            'Analysis',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
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
                          size: 21,
                          color: darkGreen,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.account_balance_wallet_outlined,
                                    size: 12,
                                    color: darkGreen,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Total Balance',
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      color: darkGreen,
                                    ),
                                  ),
                                ],
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

                        const SizedBox(width: 18),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.receipt_long_outlined,
                                    size: 12,
                                    color: darkGreen,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Total Expense',
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      color: darkGreen,
                                    ),
                                  ),
                                ],
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
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Container(
                      height: 22,
                      decoration: BoxDecoration(
                        color: softGreen,
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

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_box_outlined,
                          size: 13,
                          color: darkGreen,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '30% Of Your Expenses, Looks Good.',
                          style: GoogleFonts.poppins(
                            fontSize: 9,
                            color: darkGreen,
                          ),
                        ),
                      ],
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
                      children: [
                        const SizedBox(height: 25),

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
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedTab = 0;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: selectedTab == 0
                                          ? mainGreen
                                          : Colors.transparent,
                                      borderRadius:
                                      BorderRadius.circular(16),
                                    ),
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
                                ),
                              ),

                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedTab = 1;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: selectedTab == 1
                                          ? mainGreen
                                          : Colors.transparent,
                                      borderRadius:
                                      BorderRadius.circular(16),
                                    ),
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
                                ),
                              ),

                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedTab = 2;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: selectedTab == 2
                                          ? mainGreen
                                          : Colors.transparent,
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
                              ),

                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedTab = 3;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: selectedTab == 3
                                          ? mainGreen
                                          : Colors.transparent,
                                      borderRadius:
                                      BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Year',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: darkGreen,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        Container(
                          width: double.infinity,
                          height: 205,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: softGreen,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Income & Expenses',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: darkGreen,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    width: 27,
                                    height: 27,
                                    decoration: BoxDecoration(
                                      color: mainGreen,
                                      borderRadius:
                                      BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.search,
                                      size: 18,
                                      color: darkGreen,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    width: 27,
                                    height: 27,
                                    decoration: BoxDecoration(
                                      color: mainGreen,
                                      borderRadius:
                                      BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.calendar_month_outlined,
                                      size: 17,
                                      color: darkGreen,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              Expanded(
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 25,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '15k',
                                            style: GoogleFonts.poppins(
                                              fontSize: 7,
                                              color: blue,
                                            ),
                                          ),
                                          Text(
                                            '10k',
                                            style: GoogleFonts.poppins(
                                              fontSize: 7,
                                              color: blue,
                                            ),
                                          ),
                                          Text(
                                            '5k',
                                            style: GoogleFonts.poppins(
                                              fontSize: 7,
                                              color: blue,
                                            ),
                                          ),
                                          Text(
                                            '1k',
                                            style: GoogleFonts.poppins(
                                              fontSize: 7,
                                              color: blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Expanded(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceAround,
                                              children: [
                                                Container(
                                                  width: 5,
                                                  height: selectedTab == 0
                                                      ? 70
                                                      : 35,
                                                  color: mainGreen,
                                                ),
                                                Container(
                                                  width: 5,
                                                  height: selectedTab == 0
                                                      ? 100
                                                      : 75,
                                                  color: blue,
                                                ),
                                                Container(
                                                  width: 5,
                                                  height: 35,
                                                  color: mainGreen,
                                                ),
                                                Container(
                                                  width: 5,
                                                  height: 55,
                                                  color: blue,
                                                ),
                                                Container(
                                                  width: 5,
                                                  height: 90,
                                                  color: mainGreen,
                                                ),
                                                Container(
                                                  width: 5,
                                                  height: 72,
                                                  color: blue,
                                                ),
                                                Container(
                                                  width: 5,
                                                  height: 28,
                                                  color: mainGreen,
                                                ),
                                                Container(
                                                  width: 5,
                                                  height: 82,
                                                  color: blue,
                                                ),
                                                Container(
                                                  width: 5,
                                                  height: 95,
                                                  color: mainGreen,
                                                ),
                                                Container(
                                                  width: 5,
                                                  height: 88,
                                                  color: blue,
                                                ),
                                                Container(
                                                  width: 5,
                                                  height: 30,
                                                  color: mainGreen,
                                                ),
                                                Container(
                                                  width: 5,
                                                  height: 20,
                                                  color: blue,
                                                ),
                                              ],
                                            ),
                                          ),

                                          Container(
                                            height: 1,
                                            color: darkGreen,
                                          ),

                                          const SizedBox(height: 5),

                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceAround,
                                            children: [
                                              Text(
                                                selectedTab == 1
                                                    ? '1st Week'
                                                    : 'Mon',
                                                style:
                                                GoogleFonts.poppins(
                                                  fontSize: 7,
                                                  color: darkGreen,
                                                ),
                                              ),
                                              Text(
                                                selectedTab == 1
                                                    ? '2nd Week'
                                                    : 'Tue',
                                                style:
                                                GoogleFonts.poppins(
                                                  fontSize: 7,
                                                  color: darkGreen,
                                                ),
                                              ),
                                              Text(
                                                selectedTab == 1
                                                    ? '3rd Week'
                                                    : 'Wed',
                                                style:
                                                GoogleFonts.poppins(
                                                  fontSize: 7,
                                                  color: darkGreen,
                                                ),
                                              ),
                                              Text(
                                                selectedTab == 1
                                                    ? '4th Week'
                                                    : 'Thu',
                                                style:
                                                GoogleFonts.poppins(
                                                  fontSize: 7,
                                                  color: darkGreen,
                                                ),
                                              ),
                                              Text(
                                                selectedTab == 1
                                                    ? ''
                                                    : 'Fri',
                                                style:
                                                GoogleFonts.poppins(
                                                  fontSize: 7,
                                                  color: darkGreen,
                                                ),
                                              ),
                                              Text(
                                                selectedTab == 1
                                                    ? ''
                                                    : 'Sat',
                                                style:
                                                GoogleFonts.poppins(
                                                  fontSize: 7,
                                                  color: darkGreen,
                                                ),
                                              ),
                                              Text(
                                                selectedTab == 1
                                                    ? ''
                                                    : 'Sun',
                                                style:
                                                GoogleFonts.poppins(
                                                  fontSize: 7,
                                                  color: darkGreen,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: mainGreen,
                                        width: 2,
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(6),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_outward,
                                      size: 17,
                                      color: mainGreen,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Income',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: darkGreen,
                                    ),
                                  ),
                                  Text(
                                    selectedTab == 1
                                        ? '\$11,420.00'
                                        : '\$4,120.00',
                                    style: GoogleFonts.poppins(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: darkGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: blue,
                                        width: 2,
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(6),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_downward,
                                      size: 17,
                                      color: blue,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Expense',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: darkGreen,
                                    ),
                                  ),
                                  Text(
                                    selectedTab == 1
                                        ? '\$20,000.20'
                                        : '\$1,187.40',
                                    style: GoogleFonts.poppins(
                                      fontSize: 17,
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

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'My Targets',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: darkGreen,
                            ),
                          ),
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