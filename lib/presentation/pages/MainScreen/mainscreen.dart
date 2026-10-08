import 'package:flutter/material.dart';

import '../analytics/analytics_page.dart';
import '../categories/categories.dart';
import '../home/home_page.dart';
import '../profile/profile_page.dart';
import '../saving/saving.dart';
import '../transactions/transactions_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() =>
      _MainScreenState();
}

class _MainScreenState
    extends State<MainScreen> {
  int currentIndex = 0;

  bool showSavings = false;

  double savingsTotalBalance = 0;
  double savingsTotalExpense = 0;
  double savingsTotalIncome = 0;

  Widget getCurrentScreen() {
    if (showSavings) {
      return SavingsScreen(
        totalBalance:
        savingsTotalBalance,
        totalExpense:
        savingsTotalExpense,
        totalIncome:
        savingsTotalIncome,
        onBack: () {
          setState(() {
            showSavings = false;
            currentIndex = 2;
          });
        },
      );
    }

    switch (currentIndex) {
      case 0:
        return const HomeScreen();

      case 1:
        return const AnalysisScreen();

      case 3:
        return CategoriesScreen(
          onOpenSavings: ({
            required double totalBalance,
            required double totalExpense,
            required double totalIncome,
          }) {
            setState(() {
              savingsTotalBalance =
                  totalBalance;

              savingsTotalExpense =
                  totalExpense;

              savingsTotalIncome =
                  totalIncome;

              showSavings = true;

              currentIndex = 2;
            });
          },
        );

      case 2:
        return const TransactionScreen();

      case 4:
        return const ProfileScreen();

      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    return Scaffold(
      body: getCurrentScreen(),

      bottomNavigationBar:
      Container(
        decoration:
        const BoxDecoration(
          color: Color(0xFFDDF5E2),
          borderRadius:
          BorderRadius.only(
            topLeft:
            Radius.circular(35),
            topRight:
            Radius.circular(35),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment
                  .spaceAround,
              children: [
                _navigationItem(
                  index: 0,
                  icon:
                  'assets/icons/Home.png',
                ),

                _navigationItem(
                  index: 1,
                  icon:
                  'assets/icons/Analysis.png',
                ),


                _navigationItem(
                  index: 2,
                  icon:
                  'assets/icons/Vectors.png',
                ),
                _navigationItem(
                  index: 3,
                  icon:
                  'assets/icons/Category.png',
                ),


                _navigationItem(
                  index: 4,
                  icon:
                  'assets/icons/Profile.png',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navigationItem({
    required int index,
    required String icon,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showSavings = false;
          currentIndex = index;
        });
      },
      child: Container(
        width: 48,
        height: 48,
        decoration:
        BoxDecoration(
          color: currentIndex == index
              ? const Color(0xFF00D09E)
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Image.asset(
            icon,
            width: 27,
            height: 27,
          ),
        ),
      ),
    );
  }
}