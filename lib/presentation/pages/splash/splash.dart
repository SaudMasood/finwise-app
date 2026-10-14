import 'dart:async';

import 'package:finwise/presentation/pages/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../luncher/luncher.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // ---- Tweak these ----
  static const _waitBeforeMove = Duration(milliseconds: 1500); // splash stays
  static const _moveDuration = Duration(milliseconds: 2000); // icon moves up
  static const _fadeDuration = Duration(milliseconds: 700); // final dissolve
  static const double _moveUp = 126; // how far the logo goes up (x scale)
  static const double _grow = 1.2; // logo gets bigger while moving

  static const _splashGreen = Color(0xFF05C9A5);
  static const _launchBg = Color(0xFFF1FFF3);

  late final AnimationController _controller;
  late final Animation<double> _t;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _moveDuration);
    _t = CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);
    _start();
  }

  Future<void> _start() async {
    await Future.delayed(_waitBeforeMove);
    if (!mounted) return;

    // 1) Logo + title slide up to the launcher position
    await _controller.forward();
    if (!mounted) return;

    // 2) Then dissolve into the launcher screen
    final user = FirebaseAuth.instance.currentUser;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: _fadeDuration,
        pageBuilder: (_, __, ___) =>
        user != null ? const LoginScreen() : const LaunchScreen(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
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
          // green -> mint while moving
          backgroundColor: Color.lerp(_splashGreen, _launchBg, t),
          body: SafeArea(
            child: Center(
              child: Transform.translate(
                offset: Offset(0, -_moveUp * scale * t),
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
                          // white -> green while moving
                          color: Color.lerp(Colors.white, _splashGreen, t),
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