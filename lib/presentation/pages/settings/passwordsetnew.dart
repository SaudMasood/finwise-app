import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
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

class _PasswordSettingScreenState
    extends State<PasswordSettingScreen> {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool currentHide = true;
  bool newHide = true;
  bool confirmHide = true;

  // Figma colors
  static const Color _figmaMint = Color(0xFFDDF5E3);
  static const Color _figmaDarkTeal = Color(0xFF073B37);
  static const Color _figmaHintColor = Color(0xFF80A99F);
  static const Color _figmaButtonColor = Color(0xFF00CBA5);

  bool get _isDark =>
      Theme.of(context).brightness == Brightness.dark;

  Color get _background =>
      _isDark ? AppColors.darkBackground : AppColors.primaryGreen;

  Color get _surface =>
      _isDark ? AppColors.darkSurface : AppColors.lightGreen;

  // App bar title: same as Settings screen (dark green on light, light on dark).
  Color get _headerTextColor =>
      _isDark ? AppColors.darkText : AppColors.darkGreen;

  // Label sits OUTSIDE the field (like Figma): light on dark, dark on light.
  Color get _labelColor =>
      _isDark ? AppColors.darkText : AppColors.darkGreen;

  Color get _fieldColor =>
      _isDark ? _figmaMint : AppColors.softGreen;

  Color get _fieldTextColor =>
      _isDark ? _figmaDarkTeal : AppColors.darkGreen;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _passwordDecoration({
    required bool isHidden,
    required VoidCallback onToggle,
  }) {
    const radius = 25.0;

    return InputDecoration(
      // No floating label: the label is a Text above the field (Figma).
      hintText: '••••••••',
      hintStyle: GoogleFonts.poppins(
        color: _figmaHintColor,
        fontSize: 13,
        letterSpacing: 4,
      ),
      filled: true,
      fillColor: _fieldColor,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide.none,
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(
          color: _figmaButtonColor,
          width: 1.2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1.2,
        ),
      ),
      errorStyle: GoogleFonts.poppins(
        color: AppColors.error,
        fontSize: 11,
      ),
      suffixIconConstraints: const BoxConstraints(
        minWidth: 44,
        minHeight: 30,
      ),
      suffixIcon: IconButton(
        padding: const EdgeInsets.only(right: 12),
        constraints: const BoxConstraints(
          minWidth: 44,
          minHeight: 30,
        ),
        tooltip: isHidden ? 'Show password' : 'Hide password',
        onPressed: onToggle,
        icon: Icon(
          isHidden
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: _fieldTextColor,
          size: 20,
        ),
      ),
    );
  }

  void _changePassword() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

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

  // App bar: same as Settings screen.
  Widget _header() {
    return SizedBox(
      height: 72,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.maybePop(context),
              child: SizedBox(
                width: 32,
                height: 32,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.arrow_back,
                    color: _isDark ? AppColors.darkText : AppColors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Password Settings',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _headerTextColor,
                  ),
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const NotificationScreen(),
                  ),
                );
              },
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: _isDark ? AppColors.darkCard : AppColors.lightGreen,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_none,
                  color: _isDark ? AppColors.darkText : AppColors.darkGreen,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Label above + pill field below, exactly like the Figma layout.
  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required bool isHidden,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
    Iterable<String>? autofillHints,
    TextInputAction textInputAction = TextInputAction.next,
    VoidCallback? onSubmitted,
    required bool isLoading,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 8),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: _labelColor,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: isHidden,
          obscuringCharacter: '•',
          enabled: !isLoading,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          cursorColor: _figmaButtonColor,
          style: GoogleFonts.poppins(
            fontSize: 13,
            letterSpacing: 4,
            color: _fieldTextColor,
          ),
          decoration: _passwordDecoration(
            isHidden: isHidden,
            onToggle: onToggle,
          ),
          validator: validator,
          onFieldSubmitted:
          onSubmitted == null ? null : (_) => onSubmitted(),
        ),
      ],
    );
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
                  color: AppColors.white,
                  fontSize: 13,
                ),
              ),
              backgroundColor: AppColors.darkGreen,
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
                  color: AppColors.white,
                  fontSize: 13,
                ),
              ),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is PasswordLoading;

        return Scaffold(
          backgroundColor: _background,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _header(),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _surface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(55),
                        topRight: Radius.circular(55),
                      ),
                    ),
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.fromLTRB(
                        31,
                        50,
                        31,
                        28 + MediaQuery.of(context).padding.bottom,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _passwordField(
                              controller: _currentPasswordController,
                              label: 'Current Password',
                              isHidden: currentHide,
                              isLoading: isLoading,
                              autofillHints: const [
                                AutofillHints.password,
                              ],
                              onToggle: () {
                                setState(() {
                                  currentHide = !currentHide;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter your current password';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 28),

                            _passwordField(
                              controller: _newPasswordController,
                              label: 'New Password',
                              isHidden: newHide,
                              isLoading: isLoading,
                              autofillHints: const [
                                AutofillHints.newPassword,
                              ],
                              onToggle: () {
                                setState(() {
                                  newHide = !newHide;
                                });
                              },
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
                            const SizedBox(height: 28),

                            _passwordField(
                              controller: _confirmPasswordController,
                              label: 'Confirm New Password',
                              isHidden: confirmHide,
                              isLoading: isLoading,
                              textInputAction: TextInputAction.done,
                              onToggle: () {
                                setState(() {
                                  confirmHide = !confirmHide;
                                });
                              },
                              onSubmitted: () {
                                if (!isLoading) _changePassword();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Confirm your new password';
                                }

                                if (value !=
                                    _newPasswordController.text) {
                                  return 'Passwords do not match';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 40),

                            Center(
                              child: SizedBox(
                                width: 163,
                                height: 44,
                                child: ElevatedButton(
                                  onPressed: isLoading
                                      ? null
                                      : _changePassword,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _figmaButtonColor,
                                    foregroundColor: _figmaDarkTeal,
                                    disabledBackgroundColor:
                                    _figmaButtonColor.withValues(
                                      alpha: 0.5,
                                    ),
                                    elevation: 0,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child:
                                    CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: _figmaDarkTeal,
                                    ),
                                  )
                                      : Text(
                                    'Change Password',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
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