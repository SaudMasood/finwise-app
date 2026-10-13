
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PinSuccessScreen extends StatefulWidget {
  const PinSuccessScreen({super.key});

  @override
  State<PinSuccessScreen> createState() => _PinSuccessScreenState();
}

class _PinSuccessScreenState extends State<PinSuccessScreen>
    with SingleTickerProviderStateMixin {
  static const mainGreen = Color(0xFF00D09E);
  static const lightGreen = Color(0xFFF1FFF3);

  late final AnimationController _tickController;
  late final Animation<double> _tickScale;

  Timer? _dotTimer;
  Timer? _navigationTimer;

  int _dotCount = 1;
  bool _showTick = false;

  @override
  void initState() {
    super.initState();

    _tickController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _tickScale = CurvedAnimation(
      parent: _tickController,
      curve: Curves.elasticOut,
    );

    _dotTimer = Timer.periodic(
      const Duration(milliseconds: 650),
          (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_dotCount < 3) {
          setState(() {
            _dotCount++;
          });
        } else {
          timer.cancel();

          setState(() {
            _showTick = true;
          });

          _tickController.forward();
        }
      },
    );

    _navigationTimer = Timer(
      const Duration(seconds: 5),
          () {
        if (mounted) {
          Navigator.of(context).popUntil(
                (route) => route.isFirst,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _dotTimer?.cancel();
    _navigationTimer?.cancel();
    _tickController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainGreen,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: lightGreen,
                    width: 5,
                  ),
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: _showTick
                        ? ScaleTransition(
                      key: const ValueKey('tick'),
                      scale: _tickScale,
                      child: const Icon(
                        Icons.check,
                        color: lightGreen,
                        size: 60,
                      ),
                    )
                        : Text(
                      '.' * _dotCount,
                      key: ValueKey(_dotCount),
                      style: GoogleFonts.poppins(
                        fontSize: 42,
                        fontWeight: FontWeight.w600,
                        color: lightGreen,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'PIN Has Been\nChanged Successfully',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
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
