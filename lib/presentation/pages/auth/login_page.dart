import 'package:finwise/presentation/pages/auth/security_fingerprint.dart';
import 'package:finwise/presentation/pages/auth/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../MainScreen/mainscreen.dart';
import 'forget.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = false;

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
              height: height * 0.20,
              child: Center(
                child: Text(
                  'Welcome',
                  style: GoogleFonts.poppins(
                    fontSize: 30,
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
                      horizontal: width * 0.085,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.065),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Username Or Email',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: darkGreen,
                            ),
                          ),
                        ),

                        const SizedBox(height: 7),

                        SizedBox(
                          width: double.infinity,
                          height: 41,
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: darkGreen,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: fieldGreen,
                              hintText: 'example@example.com',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 15,
                                color: const Color(0xFF82A99F),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.025),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Password',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: darkGreen,
                            ),
                          ),
                        ),

                        const SizedBox(height: 7),

                        SizedBox(
                          width: double.infinity,
                          height: 41,
                          child: TextField(
                            obscureText: !isPasswordVisible,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: darkGreen,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: fieldGreen,
                              hintText: '●●●●●●●●',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 14,
                                color: const Color(0xFF82A99F),
                              ),
                              contentPadding: const EdgeInsets.only(
                                left: 24,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible =
                                    !isPasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 18,
                                  color: darkGreen,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.085),

                        SizedBox(
                          width: 207,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainScreen(),
                                ),
                              );

                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainGreen,
                              foregroundColor: darkGreen,
                              elevation: 0,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              'Log In',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 9),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: darkGreen,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: 207,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const CreateAccountScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: fieldGreen,
                              foregroundColor: darkGreen,
                              elevation: 0,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.035),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const SecurityFingerprintScreen(),
                              ),
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: darkGreen,
                              ),
                              children: const [
                                TextSpan(
                                  text: 'Use ',
                                ),
                                TextSpan(
                                  text: 'Fingerprint',
                                  style: TextStyle(
                                    color: blue,
                                  ),
                                ),
                                TextSpan(
                                  text: ' To Access',
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.025),

                        Text(
                          'or sign up with',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
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

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const CreateAccountScreen(),
                              ),
                            );
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                fontSize: 11,
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