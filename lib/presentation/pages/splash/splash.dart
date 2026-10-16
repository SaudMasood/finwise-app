import 'dart:async';

import 'package:finwise/presentation/pages/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
import '../luncher/luncher.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Animation settings
  static const Duration _waitBeforeMove =
  Duration(milliseconds: 1500);

  static const Duration _moveDuration =
  Duration(milliseconds: 2000);

  static const Duration _fadeDuration =
  Duration(milliseconds: 700);

  static const double _moveUp = 126;
  static const double _grow = 1.2;

  late final AnimationController _controller;
  late final Animation<double> _t;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: _moveDuration,
    );

    _t = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    _start();
  }

  Future<void> _start() async {
    await Future.delayed(_waitBeforeMove);

    if (!mounted) return;

    // 1. Move the logo and title upward.
    await _controller.forward();

    if (!mounted) return;

    // 2. Fade into the next screen.
    final user = FirebaseAuth.instance.currentUser;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: _fadeDuration,
        pageBuilder: (_, __, ___) {
          return user != null
              ? const LoginScreen()
              : const LaunchScreen();
        },
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final scale = width / 430;

    return AnimatedBuilder(
      animation: _t,
      builder: (context, _) {
        final t = _t.value;

        return Scaffold(
          // Green changes to mint during the animation.
          backgroundColor: Color.lerp(
            AppColors.primaryGreen,
            AppColors.lightGreen,
            t,
          ),
          body: SafeArea(
            child: Center(
              child: Transform.translate(
                offset: Offset(
                  0,
                  -_moveUp * scale * t,
                ),
                child: Transform.scale(
                  scale: 1 + (_grow - 1) * t,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/upicon.svg',
                        width: (width * 0.19).clamp(70.0, 90.0),
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: height * 0.012),
                      Text(
                        'FinWise',
                        style: GoogleFonts.poppins(
                          fontSize: (width * 0.085).clamp(32.0, 38.0),
                          fontWeight: FontWeight.w600,

                          // White changes to green during the animation.
                          color: Color.lerp(
                            AppColors.white,
                            AppColors.primaryGreen,
                            t,
                          ),
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}