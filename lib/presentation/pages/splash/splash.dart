import 'dart:async';
import 'package:flutter/material.dart';
import '../luncher/luncher.dart';
import 'package:flutter_svg/flutter_svg.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LaunchScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final logoWidth = width * 0.38;

    return Scaffold(
      backgroundColor: const Color(0xFF05C9A5),
      body: Center(
        child: SvgPicture.asset(
          'assets/icons/upicon.svg',
          width: logoWidth.clamp(130.0, 220.0),
        ),
      ),
    );
  }
}