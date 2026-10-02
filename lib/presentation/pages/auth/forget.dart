import 'package:finwise/presentation/pages/auth/securitypin.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';


class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    const mainGreen = Color(0xFF00D09E);
    const lightGreen = Color(0xFFF1FFF3);
    const fieldGreen = Color(0xFFDFF7E2);
    const darkGreen = Color(0xFF093030);
    const blue = Color(0xFF168BFF);

    return Scaffold(
      backgroundColor: mainGreen,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.19,
              child: Center(
                child: Text(
                  'Forgot Password',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 26,
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.075,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.075),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Reset Password?',
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: darkGreen,
                            ),
                          ),
                        ),

                        const SizedBox(height: 7),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do\n'
                                'eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                            style: GoogleFonts.poppins(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                              color: darkGreen,
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.075),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Enter Email Address',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: darkGreen,
                            ),
                          ),
                        ),

                        const SizedBox(height: 7),

                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: darkGreen,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: fieldGreen,
                              hintText: 'example@example.com',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 12,
                                color: const Color(0xFF82A99F),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.045),

                        SizedBox(
                          width: 145,
                          height: 42,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const SecurityPinScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainGreen,
                              foregroundColor: darkGreen,
                              elevation: 0,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Text(
                              'Next Step',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.105),

                        SizedBox(
                          width: 117,
                          height: 38,
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
                              'Sign Up',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        Text(
                          'or sign up with',
                          style: GoogleFonts.poppins(
                            fontSize: 9,
                            fontWeight: FontWeight.w300,
                            color: darkGreen,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/login_facebook.svg',
                              width: 33,
                              height: 33,
                            ),
                            const SizedBox(width: 17),
                            SvgPicture.asset(
                              'assets/icons/login_google.svg',
                              width: 33,
                              height: 33,
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              fontSize: 8,
                              fontWeight: FontWeight.w300,
                              color: darkGreen,
                            ),
                            children: const [
                              TextSpan(
                                text: 'Don’t have an account? ',
                              ),
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  color: blue,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
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