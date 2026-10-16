
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
import '../../bloc/auth/newpassword/newpass_bloc.dart';
import '../../bloc/auth/newpassword/newpass_event.dart';
import '../../bloc/auth/newpassword/newpass_state.dart';
import 'passwordchanged.dart';

class NewPasswordScreen extends StatefulWidget {
  final String email;

  const NewPasswordScreen({
    super.key,
    required this.email,
  });

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final background = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;

    final surface = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;

    final textColor = theme.colorScheme.onSurface;

    final secondaryText = isDark
        ? AppColors.darkSecondaryText
        : AppColors.lightSecondaryText;

    return BlocProvider(
      create: (_) => NewPasswordBloc(),
      child: BlocListener<NewPasswordBloc, NewPasswordState>(
        listener: (context, state) {
          if (state is NewPasswordSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const PasswordChangedScreen(),
              ),
            );
          }

          if (state is NewPasswordFailure) {
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
                  height: size.height * 0.19,
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
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.height * 0.06),
                        Text(
                          'Create New Password',
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Enter your new password below.',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: secondaryText,
                          ),
                        ),
                        SizedBox(height: size.height * 0.04),
                        _fieldLabel('New Password', textColor),
                        const SizedBox(height: 8),
                        _passwordField(
                          context: context,
                          controller: passwordController,
                          hint: 'Enter new password',
                          obscure: obscurePassword,
                          onToggle: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          surface: surface,
                          textColor: textColor,
                          secondaryText: secondaryText,
                        ),
                        SizedBox(height: size.height * 0.025),
                        _fieldLabel('Confirm Password', textColor),
                        const SizedBox(height: 8),
                        _passwordField(
                          context: context,
                          controller: confirmPasswordController,
                          hint: 'Confirm new password',
                          obscure: obscureConfirmPassword,
                          onToggle: () {
                            setState(() {
                              obscureConfirmPassword =
                              !obscureConfirmPassword;
                            });
                          },
                          surface: surface,
                          textColor: textColor,
                          secondaryText: secondaryText,
                        ),
                        SizedBox(height: size.height * 0.05),
                        Center(
                          child: BlocBuilder<
                              NewPasswordBloc, NewPasswordState>(
                            builder: (context, state) {
                              final loading =
                              state is NewPasswordLoading;

                              return SizedBox(
                                width: 165,
                                height: 44,
                                child: ElevatedButton(
                                  onPressed: loading
                                      ? null
                                      : () {
                                    context
                                        .read<NewPasswordBloc>()
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
                                    AppColors.primaryGreen,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: loading
                                      ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child:
                                    CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                      : Text(
                                    'Change Password',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: size.height * 0.08),
                        Center(
                          child: Text(
                            'Don’t have an account?',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: secondaryText,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
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

  Widget _fieldLabel(String label, Color color) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }

  Widget _passwordField({
    required BuildContext context,
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
    required Color surface,
    required Color textColor,
    required Color secondaryText,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: GoogleFonts.poppins(
          color: textColor,
          fontSize: 13,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            fontSize: 13,
            color: secondaryText,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          suffixIcon: IconButton(
            onPressed: onToggle,
            icon: Icon(
              obscure
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
