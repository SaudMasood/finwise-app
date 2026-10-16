
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
import '../auth/login_page.dart';

const green = AppColors.primaryGreen;
const lightGreen = AppColors.lightGreen;
const dark = Color(0xFF052224);

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;

  bool get isDark =>
      Theme.of(context).brightness == Brightness.dark;

  Color get backgroundColor =>
      isDark ? AppColors.darkBackground : green;

  Color get surfaceColor =>
      isDark ? AppColors.darkSurface : lightGreen;

  Color get textColor =>
      isDark ? AppColors.darkText : dark;

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

  Widget _pageIndicator(int page) {
    final isActive = currentPage == page;

    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        color: isActive
            ? green
            : Colors.transparent,
        border: isActive
            ? null
            : Border.all(
          color: textColor,
          width: 1,
        ),
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
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
                    color: isDark ? AppColors.darkText : AppColors.white,
                    height: 1.3,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: const BorderRadius.vertical(
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
                            color: isDark
                                ? AppColors.darkCard
                                : null,
                            colorBlendMode: isDark
                                ? BlendMode.modulate
                                : null,
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
                          color: textColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _pageIndicator(0),
                        const SizedBox(width: 8),
                        _pageIndicator(1),
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
