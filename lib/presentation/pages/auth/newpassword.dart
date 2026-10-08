import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bloc/auth/newpassword/newpass_bloc.dart';
import '../../bloc/auth/newpassword/newpass_event.dart';
import '../../bloc/auth/newpassword/newpass_state.dart';
import 'passwordchanged.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key, required String email});

  @override
  State<NewPasswordScreen> createState() =>
      _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController passwordController =
  TextEditingController();

  final TextEditingController confirmPasswordController =
  TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (_) => NewPasswordBloc(),
      child: BlocListener<NewPasswordBloc, NewPasswordState>(
        listener: (context, state) {
          if (state is NewPasswordSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                const PasswordChangedScreen(),
              ),
            );
          }

          if (state is NewPasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF1FFF3),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  height: height * 0.19,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00D09E),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(45),
                      bottomRight: Radius.circular(45),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'New Password',
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height * 0.06,
                          ),

                          Text(
                            'Create New Password',
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF093030),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Enter your new password below.',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: const Color(0xFF093030),
                            ),
                          ),

                          SizedBox(
                            height: height * 0.04,
                          ),

                          Text(
                            'New Password',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF093030),
                            ),
                          ),

                          const SizedBox(height: 8),

                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDFF7E2),
                              borderRadius:
                              BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: passwordController,
                              obscureText: obscurePassword,
                              decoration: InputDecoration(
                                hintText: 'Enter new password',
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                                contentPadding:
                                const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword =
                                      !obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color:
                                    const Color(0xFF093030),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: height * 0.025,
                          ),

                          Text(
                            'Confirm Password',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF093030),
                            ),
                          ),

                          const SizedBox(height: 8),

                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDFF7E2),
                              borderRadius:
                              BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller:
                              confirmPasswordController,
                              obscureText:
                              obscureConfirmPassword,
                              decoration: InputDecoration(
                                hintText: 'Confirm new password',
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                                contentPadding:
                                const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscureConfirmPassword =
                                      !obscureConfirmPassword;
                                    });
                                  },
                                  icon: Icon(
                                    obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color:
                                    const Color(0xFF093030),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: height * 0.05,
                          ),

                          Center(
                            child: BlocBuilder<
                                NewPasswordBloc,
                                NewPasswordState>(
                              builder: (context, state) {
                                final loading =
                                state is NewPasswordLoading;

                                return SizedBox(
                                  width: 145,
                                  height: 42,
                                  child: ElevatedButton(
                                    onPressed: loading
                                        ? null
                                        : () {
                                      context
                                          .read<
                                          NewPasswordBloc>()
                                          .add(
                                        NewPasswordSubmitted(
                                          password:
                                          passwordController
                                              .text
                                              .trim(),
                                          confirmPassword:
                                          confirmPasswordController
                                              .text
                                              .trim(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      const Color(0xFF00D09E),
                                      shape:
                                      RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                          25,
                                        ),
                                      ),
                                    ),
                                    child: loading
                                        ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child:
                                      CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                        : Text(
                                      'Change Password',
                                      style:
                                      GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight:
                                        FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          SizedBox(
                            height: height * 0.08,
                          ),

                          Center(
                            child: Text(
                              'Don’t have an account? ',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color:
                                const Color(0xFF093030),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}