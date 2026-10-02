import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../auth/login_page.dart';

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    final scale = width / 430;

    return Scaffold(
      backgroundColor: const Color(0xFFF1FFF3),
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
                    color: const Color(0xFF05C9A5),
                  ),
                ),

                SizedBox(height: 7 * scale),

                Text(
                  'Lorem ipsum dolor sit amet, consectetur\n'
                      'adipiscing elit, sed do eiusmod.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 9 * scale,
                    fontWeight: FontWeight.w400,
                    height: 1.15,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: 30 * scale),

                SizedBox(
                  width: 207 * scale,
                  height: 46 * scale,
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
                      backgroundColor: const Color(0xFF05C9A5),
                      foregroundColor: const Color(0xFF063F3F),
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25 * scale),
                      ),
                    ),
                    child: Text(
                      'Log In',
                      style: GoogleFonts.poppins(
                        fontSize: 14 * scale,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 9 * scale),

                SizedBox(
                  width: 207 * scale,
                  height: 46 * scale,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDDF5E2),
                      foregroundColor: const Color(0xFF063F3F),
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25 * scale),
                      ),
                    ),
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.poppins(
                        fontSize: 14 * scale,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10 * scale),

                Text(
                  'Forgot Password?',
                  style: GoogleFonts.poppins(
                    fontSize: 9 * scale,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                    color: const Color(0xFF063F3F),
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