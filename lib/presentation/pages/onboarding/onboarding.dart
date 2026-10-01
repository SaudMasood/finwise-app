import 'package:flutter/material.dart';
import '../../../core/widgets/app_bottom_container.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageController = PageController();

  int currentPage = 0;

  final List<String> images = [
    'assets/images/onboarding1.png',
    'assets/images/onboarding2.png',
  ];

  final List<String> titles = [
    'Welcome To\nExpense Manager',
    '¿Are You Ready To\nTake Control Of\nYour Finances?',
  ];

  void nextPage() {
    if (currentPage < 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF05C9A5),
      body: SafeArea(
        child: PageView.builder(
          controller: pageController,
          itemCount: 2,
          onPageChanged: (index) {
            setState(() {
              currentPage = index;
            });
          },
          itemBuilder: (context, index) {
            return Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.06,
                      ),
                      child: Text(
                        titles[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF063F3F),
                          fontSize: (width * 0.060).clamp(24.0, 32.0),
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 6,
                  child: AppBottomContainer(
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.06),

                        Image.asset(
                          images[index],
                          width: (width * 0.55).clamp(180.0, 280.0),
                          height: height * 0.30,
                          fit: BoxFit.contain,
                        ),

                        const Spacer(),

                        GestureDetector(
                          onTap: nextPage,
                          child: Text(
                            'Next',
                            style: TextStyle(
                              color: const Color(0xFF063F3F),
                              fontSize: (width * 0.055).clamp(22.0, 28.0),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.025),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: currentPage == 0
                                    ? const Color(0xFF05C9A5)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: const Color(0xFF063F3F),
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: currentPage == 1
                                    ? const Color(0xFF05C9A5)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: const Color(0xFF063F3F),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: height * 0.07),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}