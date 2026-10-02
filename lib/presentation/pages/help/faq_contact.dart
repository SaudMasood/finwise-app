import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'online_support.dart';

class FaqContactScreen extends StatefulWidget {
  const FaqContactScreen({super.key});

  @override
  State<FaqContactScreen> createState() => _FaqContactScreenState();
}

class _FaqContactScreenState extends State<FaqContactScreen> {
  bool isContact = false;
  int selectedCategory = 0;
  int openedQuestion = -1;

  final List<String> categories = [
    'General',
    'Account',
    'Services',
  ];

  final List<String> questions = [
    'How to use FinWise?',
    'How much does it cost to use FinWise?',
    'How to contact support?',
    'How can I reset my password if I forget it?',
    'Are there any privacy or data security measures in place?',
    'Can I customize settings within the application?',
    'How can I delete my account?',
    'How do I access my expense history?',
    'Can I use the app offline?',
  ];

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
                      child: Text(
                        'Help & FAQs',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: darkGreen,
                        ),
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
                      Icons.notifications_none,
                      color: darkGreen,
                      size: 21,
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    30,
                    25,
                    30,
                    30,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'How Can We Help You?',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: darkGreen,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: softGreen,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isContact = false;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: isContact
                                        ? Colors.transparent
                                        : mainGreen,
                                    borderRadius:
                                    BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'FAQ',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: darkGreen,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isContact = true;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: isContact
                                        ? mainGreen
                                        : Colors.transparent,
                                    borderRadius:
                                    BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Contact Us',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: darkGreen,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),

                      if (!isContact) ...[
                        Container(
                          height: 34,
                          decoration: BoxDecoration(
                            color: softGreen,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              for (int i = 0;
                              i < categories.length;
                              i++)
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedCategory = i;
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color:
                                        selectedCategory == i
                                            ? mainGreen
                                            : Colors.transparent,
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          categories[i],
                                          style:
                                          GoogleFonts.poppins(
                                            fontSize: 9,
                                            color: darkGreen,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        Container(
                          height: 38,
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: softGreen,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: darkGreen,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 10,
                                color: darkGreen,
                              ),
                              icon: const Icon(
                                Icons.search,
                                size: 18,
                                color: darkGreen,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        for (int i = 0;
                        i < questions.length;
                        i++) ...[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (openedQuestion == i) {
                                  openedQuestion = -1;
                                } else {
                                  openedQuestion = i;
                                }
                              });
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    questions[i],
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: darkGreen,
                                    ),
                                  ),
                                ),
                                Icon(
                                  openedQuestion == i
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: darkGreen,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),

                          if (openedQuestion == i)
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(
                                top: 10,
                                bottom: 12,
                              ),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: softGreen,
                                borderRadius:
                                BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Lorem ipsum dolor sit amet, '
                                    'consectetur adipiscing elit. '
                                    'Sed do eiusmod tempor incididunt '
                                    'ut labore et dolore magna aliqua.',
                                style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  height: 1.4,
                                  color: darkGreen,
                                ),
                              ),
                            ),

                          const SizedBox(height: 14),
                        ],
                      ],

                      if (isContact) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: softGreen,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.support_agent,
                                color: mainGreen,
                                size: 45,
                              ),

                              const SizedBox(height: 12),

                              Text(
                                'Need More Help?',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: darkGreen,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                'Our support team is here to help you '
                                    'with any questions or problems.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  height: 1.4,
                                  color: darkGreen,
                                ),
                              ),

                              const SizedBox(height: 20),

                              SizedBox(
                                width: 180,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        const OnlineSupportScreen(),
                                      ),
                                    );
                                  },
                                  style:
                                  ElevatedButton.styleFrom(
                                    backgroundColor: mainGreen,
                                    foregroundColor: darkGreen,
                                    elevation: 0,
                                    shape:
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(22),
                                    ),
                                  ),
                                  child: Text(
                                    'Online Support',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight:
                                      FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(
                            Icons.email_outlined,
                            color: mainGreen,
                          ),
                          title: Text(
                            'Email Support',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: darkGreen,
                            ),
                          ),
                          subtitle: Text(
                            'support@finwise.com',
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              color: darkGreen,
                            ),
                          ),
                        ),

                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(
                            Icons.phone_outlined,
                            color: mainGreen,
                          ),
                          title: Text(
                            'Call Support',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: darkGreen,
                            ),
                          ),
                          subtitle: Text(
                            '+1 555 555 5555',
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              color: darkGreen,
                            ),
                          ),
                        ),

                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(
                            Icons.language,
                            color: mainGreen,
                          ),
                          title: Text(
                            'Website',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: darkGreen,
                            ),
                          ),
                        ),
                      ],
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