import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
import '../../bloc/profile/fingerprint/fingerprint_bloc.dart';
import '../../bloc/profile/fingerprint/fingerprint_event.dart';
import '../../bloc/profile/fingerprint/fingerprint_state.dart';
import '../notification/notification.dart';

class AddFingerprintScreen extends StatelessWidget {
  const AddFingerprintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark
        ? AppColors.darkBackground
        : AppColors.primaryGreen;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightGreen;
    final textColor = isDark ? AppColors.darkText : AppColors.darkGreen;
    final secondaryColor =
    isDark ? AppColors.darkSecondaryText : AppColors.darkGreen;
    final buttonColor = isDark ? AppColors.darkCard : AppColors.softGreen;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 88,
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: Icon(
                      Icons.arrow_back,
                      color: isDark ? AppColors.darkText : AppColors.white,
                      size: 23,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Add Fingerprint',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          // Figma: dark title on the teal header
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.lightGreen,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      tooltip: 'Notifications',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationScreen(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.notifications_none,
                        color: textColor,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 28),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(45),
                  ),
                ),
                child: BlocConsumer<FingerprintBloc, FingerprintState>(
                  listener: (context, state) {
                    if (state is FingerprintSuccess) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FingerprintResultScreen(
                            deleted: false,
                          ),
                        ),
                      );
                    }

                    if (state is FingerprintFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    final loading = state is FingerprintLoading;

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 48),
                          Container(
                            width: 134,
                            height: 134,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.fingerprint,
                              size: 92,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 38),
                          Text(
                            'Use Fingerprint To Access',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'Use the biometric authentication configured on your device to enable fingerprint access.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 9,
                                height: 1.5,
                                color: secondaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 48),
                          SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: loading
                                  ? null
                                  : () {
                                context.read<FingerprintBloc>().add(
                                  EnableFingerprint(),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                foregroundColor: textColor,
                                disabledBackgroundColor:
                                buttonColor.withValues(alpha: 0.6),
                                elevation: 0,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                              ),
                              child: loading
                                  ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: textColor,
                                ),
                              )
                                  : Text(
                                'Use Touch Id',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Result screen + tick painter: intentionally UNCHANGED.
// ---------------------------------------------------------------------------

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background =
    isDark ? AppColors.darkBackground : AppColors.primaryGreen;
    final animationColor =
    isDark ? AppColors.darkText : AppColors.softGreen;
    final textColor = isDark ? AppColors.darkText : AppColors.white;
    final buttonColor =
    isDark ? AppColors.darkCard : AppColors.lightGreen;

    final title = widget.deleted
        ? 'Fingerprint Has Been Successfully Deleted.'
        : 'Fingerprint Has Been Successfully Added.';

    final subtitle = widget.deleted
        ? 'Fingerprint access has been disabled successfully.'
        : 'Fingerprint access is now enabled for FinWise.';

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
                          fontSize: 12,
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
                          fontSize: 10,
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
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                            foregroundColor: isDark
                                ? AppColors.darkText
                                : AppColors.darkGreen,
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