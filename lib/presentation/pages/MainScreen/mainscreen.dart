
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/color/app_color.dart';
import '../analytics/analytics_page.dart';
import '../categories/categories.dart';
import '../home/home_page.dart';
import '../profile/profile_page.dart';
import '../saving/saving.dart';
import '../transactions/transactions_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<GlobalKey<NavigatorState>> _navKeys =
  List.generate(5, (_) => GlobalKey<NavigatorState>());

  int currentIndex = 0;

  bool showSavings = false;

  double savingsTotalBalance = 0;
  double savingsTotalExpense = 0;
  double savingsTotalIncome = 0;

  Widget _rootFor(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();

      case 1:
        return const AnalysisScreen();

      case 2:
        return const TransactionScreen();

      case 3:
        return CategoriesScreen(
          onOpenSavings: ({
            required double totalBalance,
            required double totalExpense,
            required double totalIncome,
          }) {
            setState(() {
              savingsTotalBalance = totalBalance;
              savingsTotalExpense = totalExpense;
              savingsTotalIncome = totalIncome;
              showSavings = true;
              currentIndex = 2;
            });
          },
        );

      case 4:
        return const ProfileScreen();

      default:
        return const HomeScreen();
    }
  }

  Widget _tabNavigator(int index) {
    return Navigator(
      key: _navKeys[index],
      onGenerateRoute: (settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => _rootFor(index),
        );
      },
    );
  }

  Future<void> _handleBack() async {
    if (showSavings) {
      setState(() {
        showSavings = false;
        currentIndex = 2;
      });
      return;
    }

    final nested = _navKeys[currentIndex].currentState;

    if (nested != null && await nested.maybePop()) {
      return;
    }

    if (currentIndex != 0) {
      setState(() {
        currentIndex = 0;
      });
      return;
    }

    SystemNavigator.pop();
  }

  void _onTabTap(int index) {
    if (index == currentIndex && !showSavings) {
      _navKeys[index].currentState?.popUntil(
            (route) => route.isFirst,
      );
      return;
    }

    setState(() {
      showSavings = false;
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final navigationBackground = isDark
        ? AppColors.darkSurface
        : AppColors.softGreen;

    final selectedBackground = AppColors.primaryGreen;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        body: Stack(
          children: [
            Positioned.fill(
              child: _tabNavigator(currentIndex),
            ),
            if (showSavings)
              Positioned.fill(
                child: SavingsScreen(
                  totalBalance: savingsTotalBalance,
                  totalExpense: savingsTotalExpense,
                  totalIncome: savingsTotalIncome,
                  onBack: () {
                    setState(() {
                      showSavings = false;
                      currentIndex = 2;
                    });
                  },
                ),
              ),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: navigationBackground,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
            border: isDark
                ? Border(
              top: BorderSide(
                color: AppColors.darkDivider,
                width: 0.5,
              ),
            )
                : null,
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
                  _navigationItem(
                    index: 0,
                    icon: 'assets/icons/Home.png',
                  ),
                  _navigationItem(
                    index: 1,
                    icon: 'assets/icons/Analysis.png',
                  ),
                  _navigationItem(
                    index: 2,
                    icon: 'assets/icons/Vectors.png',
                  ),
                  _navigationItem(
                    index: 3,
                    icon: 'assets/icons/Category.png',
                  ),
                  _navigationItem(
                    index: 4,
                    icon: 'assets/icons/Profile.png',
                  ),
                ],
              ),
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
    final isDark =
        Theme.of(context).brightness == Brightness.dark;
    final selected = currentIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onTabTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryGreen
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Image.asset(
            icon,
            width: 27,
            height: 27,
            // Preserve original icon colors in light mode.
            // Tint icons in dark mode for better visibility.
            color: isDark && !selected
                ? AppColors.darkText
                : null,
            colorBlendMode: isDark && !selected
                ? BlendMode.srcIn
                : null,
          ),
        ),
      ),
    );
  }
}
