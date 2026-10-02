import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsConditionScreen extends StatefulWidget {
  const TermsConditionScreen({super.key});

  @override
  State<TermsConditionScreen> createState() =>
      _TermsConditionScreenState();
}

class _TermsConditionScreenState
    extends State<TermsConditionScreen> {
  bool accepted = false;

  @override
  Widget build(BuildContext context) {
    const mainGreen = Color(0xFF00D09E);
    const lightGreen = Color(0xFFF1FFF3);
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
                        'Terms And Conditions',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Est Fugiat Assumenda Aut Reprehenderit',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: darkGreen,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        'Lorem ipsum dolor sit amet. Et odio officia aut '
                            'voluptate internos est omnis vitae ut architecto '
                            'sunt non tenetur fuga ut provident vero.',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          height: 1.2,
                          color: darkGreen,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        '1. Ea voluptates omnis aut sequi sequi.\n'
                            '2. Est dolore quae in aliquid ducimus et autem repellendus.\n'
                            '3. Aut ipsum quis qui porro quia aut minus placeat!\n'
                            '4. Sit consequatur neque ab vitae facere.',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          height: 1.5,
                          color: darkGreen,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        'Aut quidem accusantium nam alias autem eum officiis '
                            'placeat et omnis autem id officiis perspiciatis qui '
                            'corrupti officia eum aliquam provident.',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          height: 1.2,
                          color: darkGreen,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        'Read the terms and conditions in more detail at',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: darkGreen,
                        ),
                      ),

                      Text(
                        'www.finwiseapp.de',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.blue,
                          decoration:
                          TextDecoration.underline,
                        ),
                      ),

                      Row(
                        children: [
                          Checkbox(
                            value: accepted,
                            activeColor: mainGreen,
                            onChanged: (value) {
                              setState(() {
                                accepted = value ?? false;
                              });
                            },
                          ),
                          Expanded(
                            child: Text(
                              'I accept all the terms and conditions',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: darkGreen,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      Center(
                        child: SizedBox(
                          width: 165,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: accepted ? () {} : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainGreen,
                              foregroundColor: darkGreen,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(22),
                              ),
                            ),
                            child: Text(
                              'Accept',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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