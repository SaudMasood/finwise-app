import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnlineSupportScreen extends StatefulWidget {
  const OnlineSupportScreen({super.key});

  @override
  State<OnlineSupportScreen> createState() =>
      _OnlineSupportScreenState();
}

class _OnlineSupportScreenState
    extends State<OnlineSupportScreen> {
  final TextEditingController messageController =
  TextEditingController();

  final List<String> messages = [];

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
              height: 95,
              child: Row(
                children: [
                  const SizedBox(width: 25),

                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Text(
                            'Online Support',
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: darkGreen,
                            ),
                          ),
                          Text(
                            'Online',
                            style: GoogleFonts.poppins(
                              fontSize: 8,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.only(right: 25),
                    decoration: const BoxDecoration(
                      color: lightGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.support_agent,
                      color: darkGreen,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: messages.isEmpty
                          ? Center(
                        child: Text(
                          'How can we help you?',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: darkGreen,
                          ),
                        ),
                      )
                          : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: messages.length,
                        itemBuilder:
                            (context, index) {
                          return Align(
                            alignment:
                            Alignment.centerRight,
                            child: Container(
                              margin:
                              const EdgeInsets.only(
                                bottom: 10,
                              ),
                              padding:
                              const EdgeInsets
                                  .symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: mainGreen,
                                borderRadius:
                                BorderRadius.circular(
                                  15,
                                ),
                              ),
                              child: Text(
                                messages[index],
                                style:
                                GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: darkGreen,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        10,
                        20,
                        20,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 45,
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              decoration: BoxDecoration(
                                color: softGreen,
                                borderRadius:
                                BorderRadius.circular(25),
                              ),
                              child: TextField(
                                controller:
                                messageController,
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: darkGreen,
                                ),
                                decoration: InputDecoration(
                                  hintText:
                                  'Write a message...',
                                  hintStyle:
                                  GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: darkGreen,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          GestureDetector(
                            onTap: () {
                              if (messageController
                                  .text
                                  .trim()
                                  .isEmpty) {
                                return;
                              }

                              setState(() {
                                messages.add(
                                  messageController.text
                                      .trim(),
                                );
                                messageController.clear();
                              });
                            },
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: const BoxDecoration(
                                color: mainGreen,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.send,
                                color: darkGreen,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}