import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordChangedScreen extends StatefulWidget {
  const PasswordChangedScreen({super.key});

  @override
  State<PasswordChangedScreen> createState() =>
      _PasswordChangedScreenState();
}

class _PasswordChangedScreenState extends State<PasswordChangedScreen> {
  int dotCount = 1;
  bool showCheck = false;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;

      setState(() {
        dotCount = 2;
      });
    });

    Timer(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      setState(() {
        dotCount = 3;
      });
    });

    Timer(const Duration(milliseconds: 1200), () {
      if (!mounted) return;

      setState(() {
        showCheck = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    const mainGreen = Color(0xFF00D09E);

    return Scaffold(
      backgroundColor: mainGreen,
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
                  border: Border.all(
                    color: Colors.white,
                    width: 6,
                  ),
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: showCheck
                        ? const Icon(
                      Icons.check,
                      key: ValueKey('check'),
                      color: Colors.white,
                      size: 65,
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

              SizedBox(height: height * 0.035),

              Text(
                'Password Has Been\nChanged Successfully',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}