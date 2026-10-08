import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/login_page.dart';

const green = Color(0xFF00D09E);
const lightGreen = Color(0xFFF1FFF3);
const dark = Color(0xFF052224);

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState
    extends State<OnboardingScreen> {
  int currentPage = 0;

  void nextPage() {
    if (currentPage == 0) {
      setState(() {
        currentPage = 1;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: green,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.30,
              child: Center(
                child: Text(
                  currentPage == 0
                      ? 'Welcome To\nExpense Manager'
                      : '¿Are You Ready To\nTake Control Of\nYour Finances?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: dark,
                    height: 1.3,
                  ),
                ),
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: lightGreen,
                  borderRadius:
                  BorderRadius.vertical(
                    top: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 30),

                    SizedBox(
                      width: 287,
                      height: 287,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/Ellipse.png',
                            width: 190,
                            height: 190,
                            fit: BoxFit.contain,
                          ),

                          Image.asset(
                            currentPage == 0
                                ? 'assets/icons/on1.png'
                                : 'assets/icons/on2.png',
                            width: 287,
                            height: 287,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    GestureDetector(
                      onTap: nextPage,
                      child: Text(
                        'Next',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: dark,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: currentPage == 0
                                ? green
                                : Colors.transparent,
                            border: currentPage == 0
                                ? null
                                : Border.all(
                              color: dark,
                              width: 1,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),

                        const SizedBox(width: 8),

                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: currentPage == 1
                                ? green
                                : Colors.transparent,
                            border: currentPage == 1
                                ? null
                                : Border.all(
                              color: dark,
                              width: 1,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}