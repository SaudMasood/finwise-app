import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'category_expense_page.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    const mainGreen = Color(0xFF00D09E);
    const lightGreen = Color(0xFFF1FFF3);
    const softGreen = Color(0xFFDDF5E2);
    const darkGreen = Color(0xFF063F3F);
    const blue = Color(0xFF62B0FF);

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
                            'Categories',
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
                    padding: const EdgeInsets.symmetric(horizontal: 52),
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
                    padding: const EdgeInsets.symmetric(horizontal: 52),
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
                    padding: const EdgeInsets.symmetric(horizontal: 52),
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    35,
                    28,
                    35,
                    20,
                  ),
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 28,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.78,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const CategoryExpenseScreen(
                                categoryName: 'Food',
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFF168BFF),
                                borderRadius:
                                BorderRadius.circular(18),
                              ),
                              child: const Icon(
                                Icons.restaurant,
                                size: 43,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Food',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: darkGreen,
                              ),
                            ),
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const CategoryExpenseScreen(
                                categoryName: 'Transport',
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: blue,
                                borderRadius:
                                BorderRadius.circular(18),
                              ),
                              child: const Icon(
                                Icons.directions_bus_outlined,
                                size: 43,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Transport',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: darkGreen,
                              ),
                            ),
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const CategoryExpenseScreen(
                                categoryName: 'Medicine',
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: blue,
                                borderRadius:
                                BorderRadius.circular(18),
                              ),
                              child: const Icon(
                                Icons.medication_outlined,
                                size: 43,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Medicine',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: darkGreen,
                              ),
                            ),
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const CategoryExpenseScreen(
                                categoryName: 'Groceries',
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: blue,
                                borderRadius:
                                BorderRadius.circular(18),
                              ),
                              child: const Icon(
                                Icons.shopping_bag_outlined,
                                size: 43,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Groceries',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: darkGreen,
                              ),
                            ),
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const CategoryExpenseScreen(
                                categoryName: 'Rent',
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: blue,
                                borderRadius:
                                BorderRadius.circular(18),
                              ),
                              child: const Icon(
                                Icons.volunteer_activism_outlined,
                                size: 43,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Rent',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: darkGreen,
                              ),
                            ),
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const CategoryExpenseScreen(
                                categoryName: 'Gifts',
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: blue,
                                borderRadius:
                                BorderRadius.circular(18),
                              ),
                              child: const Icon(
                                Icons.card_giftcard_outlined,
                                size: 43,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Gifts',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: darkGreen,
                              ),
                            ),
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const CategoryExpenseScreen(
                                categoryName: 'Savings',
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: blue,
                                borderRadius:
                                BorderRadius.circular(18),
                              ),
                              child: const Icon(
                                Icons.savings_outlined,
                                size: 43,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Savings',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: darkGreen,
                              ),
                            ),
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const CategoryExpenseScreen(
                                categoryName: 'Entertainment',
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: blue,
                                borderRadius:
                                BorderRadius.circular(18),
                              ),
                              child: const Icon(
                                Icons.local_activity_outlined,
                                size: 43,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Entertainment',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: darkGreen,
                              ),
                            ),
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              final controller =
                              TextEditingController();

                              return AlertDialog(
                                title: Text(
                                  'New Category',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                content: TextField(
                                  controller: controller,
                                  decoration: InputDecoration(
                                    hintText: 'Write...',
                                    filled: true,
                                    fillColor: softGreen,
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(20),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style:
                                    ElevatedButton.styleFrom(
                                      backgroundColor: mainGreen,
                                    ),
                                    child: const Text('Save'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: blue,
                                borderRadius:
                                BorderRadius.circular(18),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 43,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'More',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: darkGreen,
                              ),
                            ),
                          ],
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
    );
  }
}