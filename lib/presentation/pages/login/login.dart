import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final contentWidth = (width * 0.72).clamp(220.0, 300.0);

    return Scaffold(
      backgroundColor: const Color(0xFF05C9A5),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.26,
              child: Center(
                child: Text(
                  'Welcome',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: (width * 0.060).clamp(20.0, 28.0),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF063F3F),
                  ),
                ),
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1FFF3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(42),
                    topRight: Radius.circular(42),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Center(
                    child: SizedBox(
                      width: contentWidth,
                      child: Column(
                        children: [
                          SizedBox(height: height * 0.075),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Username Or Email',
                              style: GoogleFonts.poppins(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF063F3F),
                              ),
                            ),
                          ),

                          const SizedBox(height: 5),

                          Container(                            height: 29,
                            width: double.infinity,
                            padding: const EdgeInsets.only(left: 13,top: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDDF5E2),
                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: TextField(
                              style: GoogleFonts.poppins(
                                fontSize: 9,
                                color: const Color(0xFF063F3F),
                              ),
                              decoration: InputDecoration(
                                hintText: 'example@example.com',
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 9,
                                  color: const Color(0xFF8AAEAA),
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 7,
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
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF063F3F),
                              ),
                            ),
                          ),

                          const SizedBox(height: 5),

                          Container(
                            height: 29,
                            width: double.infinity,
                            padding: const EdgeInsets.only(left: 13,top: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDDF5E2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              obscureText: true,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: const Color(0xFF063F3F),
                              ),
                              decoration: InputDecoration(
                                hintText: '•••••••••',
                                hintStyle: const TextStyle(
                                  fontSize: 13,
                                  letterSpacing: 2,
                                  color: Color(0xFF8AAEAA),
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                suffixIcon: const Icon(
                                  Icons.visibility_off_outlined,
                                  size: 14,
                                  color: Color(0xFF063F3F),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: height * 0.07),

                          SizedBox(
                            width: 124,
                            height: 29,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF05C9A5),
                                foregroundColor: const Color(0xFF063F3F),
                                elevation: 0,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Log In',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 7),

                          Text(
                            'Forgot Password?',
                            style: GoogleFonts.poppins(
                              fontSize: 7,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF063F3F),
                            ),
                          ),

                          SizedBox(height: height * 0.018),

                          SizedBox(
                            width: 124,
                            height: 29,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFDDF5E2),
                                foregroundColor: const Color(0xFF063F3F),
                                elevation: 0,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Sign Up',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: height * 0.025),

                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                fontSize: 8,
                                color: const Color(0xFF063F3F),
                              ),
                              children: const [
                                TextSpan(text: 'Use '),
                                TextSpan(
                                  text: 'Fingerprint',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(text: ' To Access'),
                              ],
                            ),
                          ),

                          SizedBox(height: height * 0.025),

                          Text(
                            'or sign up with',
                            style: GoogleFonts.poppins(
                              fontSize: 7,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 9),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF063F3F),
                                    width: 1,
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'f',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF063F3F),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF063F3F),
                                    width: 1,
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'G',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF063F3F),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: height * 0.025),

                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                fontSize: 7,
                                color: const Color(0xFF063F3F),
                              ),
                              children: const [
                                TextSpan(
                                  text: "Don't have an account? ",
                                ),
                                TextSpan(
                                  text: 'Sign Up',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: height * 0.04),
                        ],
                      ),
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