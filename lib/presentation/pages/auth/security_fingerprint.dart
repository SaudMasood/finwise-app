import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityFingerprintScreen extends StatelessWidget {
  const SecurityFingerprintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    const mainGreen = Color(0xFF00D09E);
    const lightGreen = Color(0xFFF1FFF3);
    const fieldGreen = Color(0xFFDDF5E2);
    const darkGreen = Color(0xFF093030);

    return Scaffold(
      backgroundColor: mainGreen,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.18,
              child: Center(
                child: Text(
                  'Security Fingerprint',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: darkGreen,
                  ),
                ),
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: height * 0.065),

                      Container(
                        width: 128,
                        height: 128,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: mainGreen,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.fingerprint,
                            size: 92,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.045),

                      Text(
                        'Use Fingerprint To Access',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: darkGreen,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.14,
                        ),
                        child: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing\n'
                              'elit, sed do eiusmod tempor incididunt.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 8,
                            fontWeight: FontWeight.w400,
                            height: 1.3,
                            color: darkGreen,
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.055),

                      SizedBox(
                        width: width * 0.80,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: fieldGreen,
                            foregroundColor: darkGreen,
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            'Use Touch Id',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'Or prefer use pin code?',
                        style: GoogleFonts.poppins(
                          fontSize: 8,
                          fontWeight: FontWeight.w400,
                          color: darkGreen,
                        ),
                      ),

                      SizedBox(height: height * 0.08),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}