
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
import '../../../data/datasources/fingerprint_local_datasorce.dart';
import '../../../data/datasources/fingerprintdatas.dart';
import '../../../data/repositories/profile/fingerprint.dart';
import '../../bloc/profile/fingerprint/fingerprint_bloc.dart';
import '../../bloc/profile/fingerprint/fingerprint_event.dart';
import '../notification/notification.dart';
import 'changepin.dart';
import 'fingerprint.dart';
import 'termscondition.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
    isDark ? AppColors.darkBackground : AppColors.primaryGreen;
    final surfaceColor =
    isDark ? AppColors.darkSurface : AppColors.lightGreen;
    final textColor = isDark ? AppColors.darkText : AppColors.darkGreen;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _header(context, isDark, textColor),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(28, 34, 28, 20),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(45),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Security',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _tile(
                      title: 'Change Pin',
                      isDark: isDark,
                      textColor: textColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChangePinScreen(),
                          ),
                        );
                      },
                    ),
                    _tile(
                      title: 'Fingerprint',
                      isDark: isDark,
                      textColor: textColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => FingerprintBloc(
                                FingerprintRepositoryImpl(
                                  biometricDataSource:
                                  FingerprintBiometricDataSource(),
                                  localDataSource:
                                  FingerprintLocalDataSource(),
                                ),
                              )..add(LoadFingerprint()),
                              child: const FingerprintScreen(),
                            ),
                          ),
                        );
                      },
                    ),
                    _tile(
                      title: 'Terms And Conditions',
                      isDark: isDark,
                      textColor: textColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TermsConditionScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(
      BuildContext context,
      bool isDark,
      Color textColor,
      ) {
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: isDark ? AppColors.darkText : AppColors.white,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Security',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightGreen,
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
                  icon: Icon(
                    Icons.notifications_none,
                    color: textColor,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile({
    required String title,
    required VoidCallback onTap,
    required bool isDark,
    required Color textColor,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 52,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: textColor,
                  size: 26,
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        ),
      ],
    );
  }
}
