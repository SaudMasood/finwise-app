import 'package:finwise/presentation/pages/splash/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FinWiseApp());
}

class FinWiseApp extends StatelessWidget {
  const FinWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FinWise',
      home: const SplashScreen(),
    );
  }
}