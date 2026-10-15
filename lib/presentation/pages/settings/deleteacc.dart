
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
import '../../bloc/deleteacc/deleteaccount_bloc.dart';
import '../../bloc/deleteacc/deleteaccount_event.dart';
import '../../bloc/deleteacc/deleteaccount_state.dart';
import '../notification/notification.dart';
import '../splash/splash.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() =>
      _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  bool _hidePassword = true;

  static const Color _green = Color(0xFF00CBA5);
  static const Color _mint = Color(0xFFDDF5E3);
  static const Color _figmaText = Color(0xFF073B37);
  static const Color _lightPanel = Color(0xFFF0FFF2);

  bool get _isDark =>
      Theme.of(context).brightness == Brightness.dark;

  Color get _background =>
      _isDark ? AppColors.darkBackground : _green;

  Color get _panelColor =>
      _isDark ? AppColors.darkSurface : _lightPanel;

  Color get _textColor =>
      _isDark ? AppColors.darkText : _figmaText;

  Color get _secondaryTextColor =>
      _isDark ? AppColors.darkSecondaryText : _figmaText;

  Color get _cardColor =>
      _isDark ? AppColors.darkCard : _mint;

  Color get _fieldColor =>
      _isDark ? AppColors.darkSearchField : _mint;

  Color get _dividerColor =>
      _isDark ? AppColors.darkDivider : const Color(0xFFD1E8D9);

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  // Responsive confirmation dialog for light and dark themes.
  void _confirmDeletion() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(
        alpha: _isDark ? 0.65 : 0.42,
      ),
      builder: (dialogContext) {
        final dialogWidth =
            MediaQuery.sizeOf(dialogContext).width - 64;

        return Dialog(
          backgroundColor:
          _isDark ? AppColors.darkSurface : Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: _isDark
                ? BorderSide(color: AppColors.darkDivider)
                : BorderSide.none,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 360,
              minWidth: dialogWidth < 280 ? dialogWidth : 280,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Delete Account',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Are You Sure You Want To Delete '
                        'Your Account?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'This action is permanent. Your account and '
                        'supported associated data will be deleted. '
                        'You will not be able to recover your account '
                        'after deletion.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      height: 1.55,
                      color: _secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();

                        context.read<DeleteAccountBloc>().add(
                          DeleteAccountRequested(
                            password: _passwordController.text,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _green,
                        foregroundColor: _figmaText,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        'Yes, Delete Account',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _cardColor,
                        foregroundColor: _textColor,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  InputDecoration _passwordDecoration() {
    return InputDecoration(
      labelText: 'Current Password',
      labelStyle: GoogleFonts.poppins(
        fontSize: 12,
        color: _secondaryTextColor,
      ),
      filled: true,
      fillColor: _fieldColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: _dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(
          color: _green,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1.5,
        ),
      ),
      errorStyle: GoogleFonts.poppins(fontSize: 10),
      suffixIcon: IconButton(
        tooltip: _hidePassword ? 'Show password' : 'Hide password',
        onPressed: () {
          setState(() => _hidePassword = !_hidePassword);
        },
        icon: Icon(
          _hidePassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          size: 20,
          color: _secondaryTextColor,
        ),
      ),
    );
  }

  Widget _header(bool isLoading) {
    return SizedBox(
      height: 70,
      child: Row(
        children: [
          const SizedBox(width: 12),
          IconButton(
            onPressed:
            isLoading ? null : () => Navigator.maybePop(context),
            icon: Icon(
              Icons.arrow_back,
              size: 21,
              color: _isDark ? AppColors.darkText : Colors.white,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Delete Account',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _isDark ? AppColors.darkText : _figmaText,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _isDark
                    ? AppColors.darkCard
                    : _figmaText.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: isLoading
                    ? null
                    : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const NotificationScreen(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.notifications_none,
                  size: 19,
                  color: _isDark ? AppColors.darkText : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String text,
    required VoidCallback? onPressed,
    required Color color,
    required Color foregroundColor,
    bool loading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: color.withValues(alpha: 0.5),
          elevation: 0,
          shape: const StadiumBorder(),
        ),
        child: loading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeleteAccountBloc, DeleteAccountState>(
      listener: (context, state) {
        if (state is DeleteAccountSuccess) {
          _passwordController.clear();

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<void>(
              builder: (_) => const SplashScreen(),
            ),
                (route) => false,
          );
        }

        if (state is DeleteAccountFailure) {
          _passwordController.clear();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is DeleteAccountLoading;

        return Scaffold(
          backgroundColor: _background,
          body: SafeArea(
            child: Column(
              children: [
                _header(isLoading),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _panelColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(42),
                        topRight: Radius.circular(42),
                      ),
                    ),
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.fromLTRB(
                        24, 28, 24, 24,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              'Are You Sure You Want To Delete\n'
                                  'Your Account?',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                                color: _textColor,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 20,
                              ),
                              decoration: BoxDecoration(
                                color: _cardColor,
                                borderRadius: BorderRadius.circular(28),
                                border: _isDark
                                    ? Border.all(
                                  color: AppColors.darkDivider,
                                )
                                    : null,
                              ),
                              child: Text(
                                'This action will permanently delete '
                                    'all of your data, and you will not '
                                    'be able to recover it. Please keep '
                                    'the following in mind before '
                                    'proceeding:\n\n'
                                    '• All your expenses, income and '
                                    'associated transactions will be '
                                    'eliminated.\n\n'
                                    '• You will not be able to access '
                                    'your account or any related '
                                    'information.\n\n'
                                    '• This action cannot be undone.',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  height: 1.45,
                                  color: _secondaryTextColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            Text(
                              'Please Enter Your Password To Confirm\n'
                                  'Deletion Of Your Account.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                                color: _textColor,
                              ),
                            ),
                            const SizedBox(height: 22),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _hidePassword,
                              enabled: !isLoading,
                              autofillHints: const [
                                AutofillHints.password,
                              ],
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: _textColor,
                              ),
                              cursorColor: _green,
                              decoration: _passwordDecoration(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 28),
                            _actionButton(
                              text: 'Yes, Delete Account',
                              onPressed:
                              isLoading ? null : _confirmDeletion,
                              color: _green,
                              foregroundColor: _figmaText,
                              loading: isLoading,
                            ),
                            const SizedBox(height: 12),
                            _actionButton(
                              text: 'Cancel',
                              onPressed: isLoading
                                  ? null
                                  : () => Navigator.maybePop(context),
                              color: _cardColor,
                              foregroundColor: _textColor,
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
