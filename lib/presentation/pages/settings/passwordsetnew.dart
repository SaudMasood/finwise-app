import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bloc/password/password_bloc.dart';
import '../../bloc/password/password_event.dart';
import '../../bloc/password/password_state.dart';
import '../notification/notification.dart';

class PasswordSettingScreen extends StatefulWidget {
  const PasswordSettingScreen({super.key});

  @override
  State<PasswordSettingScreen> createState() =>
      _PasswordSettingScreenState();
}

class _PasswordSettingScreenState extends State<PasswordSettingScreen> {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool currentHide = true;
  bool newHide = true;
  bool confirmHide = true;

  static const Color mainGreen = Color(0xFF00D09E);
  static const Color lightGreen = Color(0xFFF1FFF3);
  static const Color softGreen = Color(0xFFDDF5E2);
  static const Color darkGreen = Color(0xFF063F3F);

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _passwordDecoration({
    required String label,
    required bool isHidden,
    required VoidCallback onToggle,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.poppins(
        color: darkGreen,
        fontSize: 13,
      ),
      filled: true,
      fillColor: softGreen,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          color: mainGreen,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          color: Colors.redAccent,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.5,
        ),
      ),
      suffixIcon: IconButton(
        tooltip: isHidden ? 'Show password' : 'Hide password',
        onPressed: onToggle,
        icon: Icon(
          isHidden
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: darkGreen,
          size: 21,
        ),
      ),
    );
  }

  void _changePassword() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<PasswordBloc>().add(
      ChangePasswordRequested(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      ),
    );
  }

  void _clearFields() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PasswordBloc, PasswordState>(
      listener: (context, state) {
        if (state is PasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              backgroundColor: darkGreen,
              behavior: SnackBarBehavior.floating,
            ),
          );

          _clearFields();
        }

        if (state is PasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final bool isLoading = state is PasswordLoading;

        return Scaffold(
          backgroundColor: mainGreen,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 23,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Password Setting',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: darkGreen,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            color: lightGreen,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            tooltip: 'Notifications',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                  const NotificationScreen(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.notifications_none,
                              color: darkGreen,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Main content
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: lightGreen,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(45),
                        topRight: Radius.circular(45),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(
                        28,
                        35,
                        28,
                        30,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Heading
                            Text(
                              'Change Password',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: darkGreen,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              'Keep your account secure with a strong password.',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: darkGreen.withValues(alpha: 0.7),
                                height: 1.6,
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Current password
                            TextFormField(
                              controller: _currentPasswordController,
                              obscureText: currentHide,
                              enabled: !isLoading,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [
                                AutofillHints.password,
                              ],
                              decoration: _passwordDecoration(
                                label: 'Current Password',
                                isHidden: currentHide,
                                onToggle: () {
                                  setState(() {
                                    currentHide = !currentHide;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter your current password';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 22),

                            // New password
                            TextFormField(
                              controller: _newPasswordController,
                              obscureText: newHide,
                              enabled: !isLoading,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [
                                AutofillHints.newPassword,
                              ],
                              decoration: _passwordDecoration(
                                label: 'New Password',
                                isHidden: newHide,
                                onToggle: () {
                                  setState(() {
                                    newHide = !newHide;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter your new password';
                                }

                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }

                                if (value ==
                                    _currentPasswordController.text) {
                                  return 'New password must be different';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 22),

                            // Confirm password
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: confirmHide,
                              enabled: !isLoading,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) {
                                if (!isLoading) {
                                  _changePassword();
                                }
                              },
                              decoration: _passwordDecoration(
                                label: 'Confirm New Password',
                                isHidden: confirmHide,
                                onToggle: () {
                                  setState(() {
                                    confirmHide = !confirmHide;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Confirm your new password';
                                }

                                if (value != _newPasswordController.text) {
                                  return 'Passwords do not match';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 18),

                            // Security information
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: softGreen,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.shield_outlined,
                                    color: darkGreen,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Your password is securely managed by '
                                          'Firebase Authentication. It is not '
                                          'stored in Firestore.',
                                      style: GoogleFonts.poppins(
                                        color: darkGreen,
                                        fontSize: 11,
                                        height: 1.6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Change password button
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed:
                                isLoading ? null : _changePassword,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: mainGreen,
                                  foregroundColor: darkGreen,
                                  disabledBackgroundColor:
                                  mainGreen.withValues(alpha: 0.5),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                  width: 23,
                                  height: 23,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: darkGreen,
                                  ),
                                )
                                    : Text(
                                  'Change Password',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}