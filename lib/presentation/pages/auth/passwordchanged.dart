
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';

class PasswordChangedScreen extends StatefulWidget {
  const PasswordChangedScreen({super.key});

  @override
  State<PasswordChangedScreen> createState() =>
      _PasswordChangedScreenState();
}

class _PasswordChangedScreenState
    extends State<PasswordChangedScreen> {
  int dotCount = 1;
  bool showCheck = false;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => dotCount = 2);
    });

    Timer(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => dotCount = 3);
    });

    Timer(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => showCheck = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final background = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;

    final textColor = isDark
        ? AppColors.darkText
        : AppColors.lightText;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: width * 0.27,
                height: width * 0.27,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryGreen,
                  border: Border.all(
                    color: AppColors.primaryGreen,
                    width: 6,
                  ),
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration:
                    const Duration(milliseconds: 250),
                    child: showCheck
                        ? const Icon(
                      Icons.check,
                      key: ValueKey('check'),
                      size: 65,
                      color: Colors.white,
                    )
                        : Text(
                      '.' * dotCount,
                      key: ValueKey(dotCount),
                      style: GoogleFonts.poppins(
                        fontSize: 42,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Password Has Been\nChanged Successfully',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
