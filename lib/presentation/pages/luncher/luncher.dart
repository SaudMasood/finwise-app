import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../login/login.dart';

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final logoWidth = width * 0.90;
    final titleSize = width * 0.083;
    final descriptionSize = width * 0.018;
    final buttonWidth = width * 0.36;
    final buttonHeight = height * 0.052;

    return Scaffold(
      backgroundColor: const Color(0xFFF1FFF3),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/upicongreen.svg',
                width: logoWidth.clamp(120.0, 190.0),
              ),

              SizedBox(height: height * 0.012),

              Text(
                'FinWise',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: titleSize.clamp(32.0, 52.14),
                  fontWeight: FontWeight.w600,
                  height: 57.36 / 52.14,
                  color: const Color(0xFF05C9A5),
                ),
              ),

              SizedBox(height: height * 0.008),

              Text(
                'Lorem ipsum dolor sit amet, consectetur\n'
                    'adipiscing elit, sed do eiusmod.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: descriptionSize.clamp(8.0, 11.0),
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),

              SizedBox(height: height * 0.025),

              SizedBox(
                width: buttonWidth.clamp(130.0, 200.0),
                height: buttonHeight.clamp(38.0, 48.0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF05C9A5),
                    foregroundColor: Colors.black,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Log In',
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.030,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              SizedBox(height: height * 0.012),

              SizedBox(
                width: buttonWidth.clamp(130.0, 200.0),
                height: buttonHeight.clamp(38.0, 48.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDDF5E2),
                    foregroundColor: Colors.black,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.030,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              SizedBox(height: height * 0.014),

              Text(
                'Forgot Password?',
                style: GoogleFonts.poppins(
                  fontSize: width * 0.020,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}