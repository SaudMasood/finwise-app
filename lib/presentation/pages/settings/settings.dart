import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'notifsetting.dart';
import 'passwordsetnew.dart';
import 'deleteacc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                        'Settings',
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
                  padding: const EdgeInsets.fromLTRB(
                    30,
                    35,
                    30,
                    20,
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.notifications_none,
                          color: mainGreen,
                        ),
                        title: Text(
                          'Notification Settings',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: darkGreen,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: darkGreen,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const NotificationSettingScreen(),
                            ),
                          );
                        },
                      ),

                      ListTile(
                        leading: const Icon(
                          Icons.key_outlined,
                          color: mainGreen,
                        ),
                        title: Text(
                          'Password Settings',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: darkGreen,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: darkGreen,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const PasswordSettingScreen(),
                            ),
                          );
                        },
                      ),

                      ListTile(
                        leading: const Icon(
                          Icons.person_outline,
                          color: mainGreen,
                        ),
                        title: Text(
                          'Delete Account',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: darkGreen,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: darkGreen,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const DeleteAccountScreen(),
                            ),
                          );
                        },
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