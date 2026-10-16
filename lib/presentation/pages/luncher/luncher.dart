
import 'package:finwise/presentation/pages/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final scale = width / 430;

    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightGreen;

    final descriptionColor = isDark
        ? AppColors.darkSecondaryText
        : AppColors.black;

    final subtitleColor = isDark
        ? AppColors.darkText
        : AppColors.darkGreen;

    final secondaryButtonColor = isDark
        ? AppColors.darkCard
        : AppColors.softGreen;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Transform.translate(
            offset: Offset(0, -35 * scale),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/icons/upicongreen.svg',
                  width: 115 * scale,
                  height: 115 * scale,
                  fit: BoxFit.contain,
                ),

                SizedBox(height: 0 * scale),

                Text(
                  'FinWise',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 52.14 * scale,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                    color: AppColors.primaryGreen,
                  ),
                ),

                SizedBox(height: 7 * scale),

                Text(
                  'Track your spending, set smart budgets\n'
                      'and take control of your money.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 9 * scale,
                    fontWeight: FontWeight.w400,
                    height: 1.15,
                    color: descriptionColor,
                  ),
                ),

                SizedBox(height: 30 * scale),

                // Log In button
                SizedBox(
                  width: 207 * scale,
                  height: 46 * scale,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) =>
                          const OnboardingScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(25 * scale),
                      ),
                    ),
                    child: Text(
                      'Log In',
                      style: GoogleFonts.poppins(
                        fontSize: 16 * scale,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10 * scale),

                // Sign Up button
                SizedBox(
                  width: 207 * scale,
                  height: 46 * scale,
                  child: ElevatedButton(
                    onPressed: () {
                      // Connect your signup screen here.
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryButtonColor,
                      foregroundColor: subtitleColor,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(25 * scale),
                        side: isDark
                            ? BorderSide(
                          color: AppColors.darkDivider,
                        )
                            : BorderSide.none,
                      ),
                    ),
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.poppins(
                        fontSize: 16 * scale,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10 * scale),

                // Forgot Password
                GestureDetector(
                  onTap: () {
                    // Connect your forgot-password screen here.
                  },
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.poppins(
                      fontSize: 12 * scale,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                      color: subtitleColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
