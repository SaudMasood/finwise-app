
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bloc/profile/fingerprint/fingerprint_bloc.dart';
import '../../bloc/profile/fingerprint/fingerprint_event.dart';
import '../../bloc/profile/fingerprint/fingerprint_state.dart';
import '../notification/notification.dart';

class AddFingerprintScreen extends StatelessWidget {
  const AddFingerprintScreen({super.key});

  static const Color mainGreen = Color(0xFF00D09E);
  static const Color lightGreen = Color(0xFFF1FFF3);
  static const Color darkGreen = Color(0xFF063F3F);
  static const Color softGreen = Color(0xFFDDF5E2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainGreen,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 90,
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Add Fingerprint',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: darkGreen,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: lightGreen,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationScreen(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.notifications_none,
                        color: darkGreen,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                decoration: const BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(40),
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

                    return Column(
                      children: [
                        const SizedBox(height: 42),
                        Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            color: mainGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.fingerprint,
                            size: 83,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Use Fingerprint To Access',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: darkGreen,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Use the biometric authentication configured on your device to enable fingerprint access.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 9,
                            height: 1.5,
                            color: darkGreen,
                          ),
                        ),
                        const Spacer(),
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
                              backgroundColor: softGreen,
                              foregroundColor: darkGreen,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                            child: loading
                                ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: darkGreen,
                              ),
                            )
                                : Text(
                              'Use Touch Id',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
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
  static const Color mainGreen = Color(0xFF00D09E);
  static const Color lightGreen = Color(0xFFDDF5E2);
  static const Color darkGreen = Color(0xFF063F3F);

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
    final title = widget.deleted
        ? 'Fingerprint Has Been Successfully Deleted.'
        : 'Fingerprint Has Been Successfully Added.';

    final subtitle = widget.deleted
        ? 'Fingerprint access has been disabled successfully.'
        : 'Fingerprint access is now enabled for FinWise.';

    return Scaffold(
      backgroundColor: mainGreen,
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
                                  color: lightGreen,
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
                                  decoration: const BoxDecoration(
                                    color: lightGreen,
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
                                    color: lightGreen,
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
                          color: Colors.white,
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
                          color: Colors.white,
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
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: lightGreen,
                            foregroundColor: darkGreen,
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
