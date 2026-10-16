
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
import '../../bloc/auth/securitypin/securitypin_bloc.dart';
import '../../bloc/auth/securitypin/securitypin_event.dart';
import '../../bloc/auth/securitypin/securitypin_state.dart';
import 'login_page.dart';
import 'newpassword.dart';

class SecurityPinScreen extends StatelessWidget {
  final String email;

  const SecurityPinScreen({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final background = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;

    final surface = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;

    final textColor = isDark
        ? AppColors.darkText
        : AppColors.lightText;

    final secondaryText = isDark
        ? AppColors.darkSecondaryText
        : AppColors.lightSecondaryText;

    return BlocProvider(
      create: (_) => SecurityPinBloc(
        firebaseAuth: FirebaseAuth.instance,
      ),
      child: BlocListener<SecurityPinBloc, SecurityPinState>(
        listener: (context, state) {
          if (state is SecurityPinSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please check your email.'),
              ),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginScreen(),
              ),
            );
          }

          if (state is SecurityPinFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Scaffold(
          backgroundColor: background,
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  height: height * 0.19,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(45),
                      bottomRight: Radius.circular(45),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Check Your Email',
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.07),
                        Text(
                          'Password Reset Email',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'We have sent a password reset link to:',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: secondaryText,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius:
                            BorderRadius.circular(12),
                            border: Border.all(
                              color:
                              Theme.of(context).dividerColor,
                            ),
                          ),
                          child: Text(
                            email,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          'Open your email and tap the password reset link. '
                              'The link will allow you to reset your password.',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            height: 1.6,
                            color: secondaryText,
                          ),
                        ),
                        SizedBox(height: height * 0.08),
                        Center(
                          child: BlocBuilder<
                              SecurityPinBloc,
                              SecurityPinState>(
                            builder: (context, state) {
                              final loading =
                              state is SecurityPinLoading;

                              return SizedBox(
                                width: 145,
                                height: 42,
                                child: ElevatedButton(
                                  onPressed: loading
                                      ? null
                                      : () {
                                    context
                                        .read<
                                        SecurityPinBloc>()
                                        .add(
                                      SecurityEmailChecked(
                                        email: email,
                                      ),
                                    );
                                  },
                                  style:
                                  ElevatedButton.styleFrom(
                                    backgroundColor:
                                    AppColors.primaryGreen,
                                    foregroundColor:
                                    Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(25),
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
                                    'Continue',
                                    style:
                                    GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        Center(
                          child: BlocBuilder<
                              SecurityPinBloc,
                              SecurityPinState>(
                            builder: (context, state) {
                              final loading =
                              state is SecurityPinLoading;

                              return TextButton(
                                onPressed: loading
                                    ? null
                                    : () {
                                  context
                                      .read<
                                      SecurityPinBloc>()
                                      .add(
                                    SecurityEmailResend(
                                      email: email,
                                    ),
                                  );
                                },
                                child: Text(
                                  'Send Again',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blue,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      NewPasswordScreen(
                                        email: email,
                                      ),
                                ),
                              );
                            },
                            child: Text(
                              'Set New Password',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
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
