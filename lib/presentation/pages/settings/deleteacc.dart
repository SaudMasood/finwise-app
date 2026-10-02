import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../splash/splash.dart';


class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

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
                        'Delete Account',
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
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Text(
                        'Are You Sure You Want To Delete\n'
                            'Your Account?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: darkGreen,
                        ),
                      ),

                      const SizedBox(height: 25),

                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: softGreen,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          'This action will permanently delete all of your '
                              'data, and you will not be able to recover it. '
                              'Please keep the following in mind before proceeding:\n\n'
                              '• All your expenses, income and associated '
                              'transactions will be eliminated.\n\n'
                              '• You will not be able to access your account '
                              'or any related information.\n\n'
                              '• This action cannot be undone.',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            height: 1.3,
                            color: darkGreen,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Text(
                        'Please Enter Your Password To Confirm\n'
                            'Deletion Of Your Account.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: darkGreen,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: softGreen,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixText: '••••••••',
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 18),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: 180,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text(
                                    'Delete Account',
                                  ),
                                  content: const Text(
                                    'Are You Sure You Want To Delete Your Account?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                            const SplashScreen(),
                                          ),
                                              (route) => false,
                                        );
                                      },
                                      child: const Text(
                                        'Yes, Delete Account',
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
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
                            'Yes, Delete Account',
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: 180,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: softGreen,
                            foregroundColor: darkGreen,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(22),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
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