
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';

class FingerprintResultScreen extends StatefulWidget {
  final bool deleted;

  const FingerprintResultScreen({
    super.key,
    required this.deleted,
  });

  @override
  State<FingerprintResultScreen> createState() =>
      _FingerprintResultScreenState();
}

class _FingerprintResultScreenState extends State<FingerprintResultScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> circleAnimation;
  late final Animation<double> tickAnimation;
  late final Animation<double> textAnimation;

  bool get isDark =>
      Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    circleAnimation = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
    );

    tickAnimation = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.35, 0.75, curve: Curves.easeInOut),
    );

    textAnimation = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.65, 1.0, curve: Curves.easeIn),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final background =
    isDark ? AppColors.darkBackground : AppColors.primaryGreen;
    final animationColor =
    isDark ? AppColors.darkText : AppColors.softGreen;
    final textColor = isDark ? AppColors.darkText : AppColors.white;
    final buttonColor =
    isDark ? AppColors.darkCard : AppColors.lightGreen;
    final buttonTextColor =
    isDark ? AppColors.darkText : AppColors.darkGreen;

    final title = widget.deleted
        ? 'Fingerprint Deleted Successfully'
        : 'Fingerprint Added Successfully';

    final subtitle = widget.deleted
        ? 'Your fingerprint has been removed from FinWise.'
        : 'Your fingerprint has been enabled for FinWise access.';

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.scale(
                      scale: 0.7 + (circleAnimation.value * 0.3),
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 105,
                              height: 105,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: animationColor,
                                  width: 4,
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: 1 - tickAnimation.value,
                              child: Transform.translate(
                                offset: Offset(
                                  -18 + (tickAnimation.value * 18),
                                  0,
                                ),
                                child: Container(
                                  width: 9,
                                  height: 9,
                                  decoration: BoxDecoration(
                                    color: animationColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                            if (tickAnimation.value > 0)
                              SizedBox(
                                width: 55,
                                height: 55,
                                child: CustomPaint(
                                  painter: FingerprintTickPainter(
                                    progress: tickAnimation.value,
                                    color: animationColor,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Opacity(
                      opacity: textAnimation.value,
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Opacity(
                      opacity: textAnimation.value,
                      child: Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: textColor,
                          fontSize: 11,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Opacity(
                      opacity: textAnimation.value,
                      child: SizedBox(
                        width: 165,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.popUntil(
                              context,
                                  (route) => route.isFirst,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                            foregroundColor: buttonTextColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            'Done',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class FingerprintTickPainter extends CustomPainter {
  final double progress;
  final Color color;

  FingerprintTickPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width * 0.18, size.height * 0.52)
      ..lineTo(size.width * 0.42, size.height * 0.74)
      ..lineTo(size.width * 0.84, size.height * 0.28);

    final metrics = path.computeMetrics().first;
    final animatedPath = metrics.extractPath(
      0,
      metrics.length * progress.clamp(0.0, 1.0),
    );

    canvas.drawPath(animatedPath, paint);
  }

  @override
  bool shouldRepaint(covariant FingerprintTickPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color;
  }
}
