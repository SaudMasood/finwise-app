import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState
    extends State<NotificationSettingScreen> {
  bool reminder = true;
  bool transactions = true;
  bool updates = true;

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
                        'Notification Settings',
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
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Reminder Notifications',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: darkGreen,
                          ),
                        ),
                        value: reminder,
                        activeColor: mainGreen,
                        onChanged: (value) {
                          setState(() {
                            reminder = value;
                          });
                        },
                      ),

                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Transaction Notifications',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: darkGreen,
                          ),
                        ),
                        value: transactions,
                        activeColor: mainGreen,
                        onChanged: (value) {
                          setState(() {
                            transactions = value;
                          });
                        },
                      ),

                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'New Updates',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: darkGreen,
                          ),
                        ),
                        value: updates,
                        activeColor: mainGreen,
                        onChanged: (value) {
                          setState(() {
                            updates = value;
                          });
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