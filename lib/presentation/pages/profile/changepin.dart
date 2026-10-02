import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({super.key});

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  bool hideCurrent = true;
  bool hideNew = true;
  bool hideConfirm = true;

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
                        'Change Pin',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
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
                  padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Current Pin',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: darkGreen,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Container(
                        height: 38,
                        decoration: BoxDecoration(
                          color: softGreen,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          obscureText: hideCurrent,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixText: '••••',
                            prefixStyle: const TextStyle(
                              color: Color(0xFF80A8A0),
                              letterSpacing: 5,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hideCurrent = !hideCurrent;
                                });
                              },
                              icon: Icon(
                                hideCurrent
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 18,
                                color: darkGreen,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'New Pin',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: darkGreen,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Container(
                        height: 38,
                        decoration: BoxDecoration(
                          color: softGreen,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          obscureText: hideNew,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixText: '••••',
                            prefixStyle: const TextStyle(
                              color: Color(0xFF80A8A0),
                              letterSpacing: 5,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hideNew = !hideNew;
                                });
                              },
                              icon: Icon(
                                hideNew
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 18,
                                color: darkGreen,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Confirm Pin',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: darkGreen,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Container(
                        height: 38,
                        decoration: BoxDecoration(
                          color: softGreen,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          obscureText: hideConfirm,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixText: '••••',
                            prefixStyle: const TextStyle(
                              color: Color(0xFF80A8A0),
                              letterSpacing: 5,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hideConfirm = !hideConfirm;
                                });
                              },
                              icon: Icon(
                                hideConfirm
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 18,
                                color: darkGreen,
                              ),
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
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                          child: Text(
                            'Change Pin',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
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