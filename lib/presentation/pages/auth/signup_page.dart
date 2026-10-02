import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_page.dart';


class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    const mainGreen = Color(0xFF00D09E);
    const lightGreen = Color(0xFFF1FFF3);
    const fieldGreen = Color(0xFFDDF5E2);
    const darkGreen = Color(0xFF093030);
    const hintColor = Color(0xFF82A99F);
    const blue = Color(0xFF168BFF);

    return Scaffold(
      backgroundColor: mainGreen,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.17,
              child: Center(
                child: Text(
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 25,
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
                    topLeft: Radius.circular(42),
                    topRight: Radius.circular(42),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.065,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.025),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Full Name',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: darkGreen,
                            ),
                          ),
                        ),

                        const SizedBox(height: 5),

                        SizedBox(
                          height: 40,
                          child: TextField(
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
                                color: hintColor,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 22,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Email',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: darkGreen,
                            ),
                          ),
                        ),

                        const SizedBox(height: 5),

                        SizedBox(
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
                                color: hintColor,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 22,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Mobile Number',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: darkGreen,
                            ),
                          ),
                        ),

                        const SizedBox(height: 5),

                        SizedBox(
                          height: 40,
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: darkGreen,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: fieldGreen,
                              hintText: '+ 123 456 789',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 12,
                                color: hintColor,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 22,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Date Of Birth',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: darkGreen,
                            ),
                          ),
                        ),

                        const SizedBox(height: 5),

                        SizedBox(
                          height: 40,
                          child: TextField(
                            keyboardType: TextInputType.datetime,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: darkGreen,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: fieldGreen,
                              hintText: 'DD / MM / YYY',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 12,
                                color: hintColor,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 22,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Password',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: darkGreen,
                            ),
                          ),
                        ),

                        const SizedBox(height: 5),

                        SizedBox(
                          height: 40,
                          child: TextField(
                            obscureText: !isPasswordVisible,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: darkGreen,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: fieldGreen,
                              hintText: '●●●●●●●●',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 12,
                                color: hintColor,
                              ),
                              contentPadding: const EdgeInsets.only(
                                left: 22,
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
                                  size: 17,
                                  color: darkGreen,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Confirm Password',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: darkGreen,
                            ),
                          ),
                        ),

                        const SizedBox(height: 5),

                        SizedBox(
                          height: 40,
                          child: TextField(
                            obscureText: !isConfirmPasswordVisible,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: darkGreen,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: fieldGreen,
                              hintText: '●●●●●●●●',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 12,
                                color: hintColor,
                              ),
                              contentPadding: const EdgeInsets.only(
                                left: 22,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isConfirmPasswordVisible =
                                    !isConfirmPasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  isConfirmPasswordVisible
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 17,
                                  color: darkGreen,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        Text(
                          'By continuing, you agree to',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 8,
                            fontWeight: FontWeight.w400,
                            color: darkGreen,
                          ),
                        ),

                        Text(
                          'Terms of Use and Privacy Policy.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                            color: darkGreen,
                          ),
                        ),

                        const SizedBox(height: 8),

                        SizedBox(
                          width: 135,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const LoginScreen(),
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
                              'Sign Up',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const LoginScreen(),
                              ),
                            );
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                fontSize: 8,
                                fontWeight: FontWeight.w400,
                                color: darkGreen,
                              ),
                              children: const [
                                TextSpan(
                                  text: 'Already have an account? ',
                                ),
                                TextSpan(
                                  text: 'Log In',
                                  style: TextStyle(
                                    color: blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),
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