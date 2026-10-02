import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordSettingScreen extends StatefulWidget {
  const PasswordSettingScreen({super.key});

  @override
  State<PasswordSettingScreen> createState() =>
      _PasswordSettingScreenState();
}

class _PasswordSettingScreenState
    extends State<PasswordSettingScreen> {
  bool currentHide = true;
  bool newHide = true;
  bool confirmHide = true;

  @override
  Widget build(BuildContext context) {
    const mainGreen = Color(0xFF00D09E);
    const lightGreen = Color(0xFFF1FFF3);
    const softGreen = Color(0xFFDDF5E2);
    const darkGreen = Color(0xFF063F3F);

    return Scaffold(
      backgroundColor: mainGreen,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 110,
              child: Row(
                children: [
                  const SizedBox(width: 25),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Password Settings',
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: darkGreen,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 57),
                ],
              ),
            ),

            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    30,
                    50,
                    30,
                    30,
                  ),
                  child: Column(
                    children: [
                      TextField(
                        obscureText: currentHide,
                        decoration: InputDecoration(
                          labelText: 'Current Password',
                          filled: true,
                          fillColor: softGreen,
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                currentHide = !currentHide;
                              });
                            },
                            icon: Icon(
                              currentHide
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      TextField(
                        obscureText: newHide,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          filled: true,
                          fillColor: softGreen,
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                newHide = !newHide;
                              });
                            },
                            icon: Icon(
                              newHide
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      TextField(
                        obscureText: confirmHide,
                        decoration: InputDecoration(
                          labelText: 'Confirm New Password',
                          filled: true,
                          fillColor: softGreen,
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                confirmHide = !confirmHide;
                              });
                            },
                            icon: Icon(
                              confirmHide
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 45),

                      SizedBox(
                        width: 180,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainGreen,
                            foregroundColor: darkGreen,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(22),
                            ),
                          ),
                          child: const Text(
                            'Change Password',
                          ),
                        ),
                      ),
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