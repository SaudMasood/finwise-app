import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool notification = true;
  bool darkTheme = false;

  final TextEditingController nameController =
  TextEditingController(text: 'John Smith');

  final TextEditingController phoneController =
  TextEditingController(text: '+44 555 5555 55');

  final TextEditingController emailController =
  TextEditingController(text: 'example@example.com');

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
                        'Edit My Profile',
                        style: GoogleFonts.poppins(
                          fontSize: 17,
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
                    0,
                    30,
                    30,
                  ),
                  child: Column(
                    children: [
                      Transform.translate(
                        offset: const Offset(0, -10),
                        child: Column(
                          children: [
                            Container(
                              width: 95,
                              height: 95,
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
                            const SizedBox(height: 10),
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
                                fontSize: 9,
                                color: darkGreen,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Account Settings',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: darkGreen,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Username',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: darkGreen,
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Container(
                        height: 38,
                        padding:
                        const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: softGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: nameController,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: darkGreen,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Phone',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: darkGreen,
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Container(
                        height: 38,
                        padding:
                        const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: softGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: phoneController,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: darkGreen,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Email Address',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: darkGreen,
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Container(
                        height: 38,
                        padding:
                        const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: softGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: emailController,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: darkGreen,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Push Notifications',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: darkGreen,
                            ),
                          ),
                          Switch(
                            value: notification,
                            activeColor: mainGreen,
                            onChanged: (value) {
                              setState(() {
                                notification = value;
                              });
                            },
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Turn Dark Theme',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: darkGreen,
                            ),
                          ),
                          Switch(
                            value: darkTheme,
                            activeColor: mainGreen,
                            onChanged: (value) {
                              setState(() {
                                darkTheme = value;
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        width: 140,
                        height: 38,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
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
                          child: Text(
                            'Update Profile',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
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