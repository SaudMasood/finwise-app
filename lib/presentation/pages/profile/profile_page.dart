import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'editprofile.dart';
import 'security.dart';
import '../settings/settings.dart';
import '../help/faq_contact.dart';
import '../logout/logout.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const mainGreen = Color(0xFF00D09E);
    const lightGreen = Color(0xFFF1FFF3);
    const blue = Color(0xFF4DA3FF);
    const darkGreen = Color(0xFF063F3F);

    return Scaffold(
      backgroundColor: mainGreen,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Row(
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
                            'Profile',
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
                  const SizedBox(height: 12),
                  Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/profile.png',
                        ),
                        fit: BoxFit.cover,
                      ),
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
                    const SizedBox(height: 55),

                    Text(
                      'John Smith',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: darkGreen,
                      ),
                    ),

                    Text(
                      'ID: 25030024',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: darkGreen,
                      ),
                    ),

                    const SizedBox(height: 35),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const EditProfileScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const SizedBox(width: 30),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: blue,
                              borderRadius:
                              BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            'Edit Profile',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: darkGreen,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const SecurityScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const SizedBox(width: 30),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: blue,
                              borderRadius:
                              BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.verified_user_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            'Security',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: darkGreen,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const SettingsScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const SizedBox(width: 30),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: blue,
                              borderRadius:
                              BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.settings_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            'Setting',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: darkGreen,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const FaqContactScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const SizedBox(width: 30),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: blue,
                              borderRadius:
                              BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.support_agent,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            'Help',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: darkGreen,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const LogoutScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const SizedBox(width: 30),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: blue,
                              borderRadius:
                              BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            'Logout',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: darkGreen,
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