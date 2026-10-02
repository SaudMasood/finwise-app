import 'package:flutter/material.dart';

import '../home/home_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List<Widget> screens = [
    HomeScreen(),
    const Center(
      child: Text('Analysis'),
    ),
    const Center(
      child: Text('Category'),
    ),
    const Center(
      child: Text('Vectors'),
    ),
    const Center(
      child: Text('Profile'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFDDF5E2),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = 0;
                    });
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: currentIndex == 0
                          ? const Color(0xFF00D09E)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/icons/Home.png',
                      width: 27,
                      height: 27,
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = 1;
                    });
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: currentIndex == 1
                          ? const Color(0xFF00D09E)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/icons/Analysis.png',
                      width: 27,
                      height: 27,
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = 2;
                    });
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: currentIndex == 2
                          ? const Color(0xFF00D09E)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/icons/Category.png',
                      width: 27,
                      height: 27,
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = 3;
                    });
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: currentIndex == 3
                          ? const Color(0xFF00D09E)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/icons/Vectors.png',
                      width: 27,
                      height: 27,
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = 4;
                    });
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: currentIndex == 4
                          ? const Color(0xFF00D09E)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/icons/Profile.png',
                      width: 27,
                      height: 27,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}