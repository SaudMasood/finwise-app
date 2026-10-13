
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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

  static const Color mainGreen = Color(0xFF00D09E);
  static const Color lightGreen = Color(0xFFF1FFF3);
  static const Color softGreen = Color(0xFFDDF5E2);
  static const Color darkGreen = Color(0xFF063F3F);

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _confirmDeletion() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: lightGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            'Delete Account?',
            style: GoogleFonts.poppins(
              color: darkGreen,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          content: Text(
            'This action is permanent. Your account and supported '
                'user data will be deleted. Do you want to continue?',
            style: GoogleFonts.poppins(
              color: darkGreen,
              fontSize: 12,
              height: 1.6,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: darkGreen),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);

                context.read<DeleteAccountBloc>().add(
                  DeleteAccountRequested(
                    password: _passwordController.text,
                  ),
                );
              },
              child: Text(
                'Delete Permanently',
                style: GoogleFonts.poppins(fontSize: 11),
              ),
            ),
          ],
        );
      },
    );
  }

  InputDecoration _passwordDecoration() {
    return InputDecoration(
      labelText: 'Current Password',
      labelStyle: GoogleFonts.poppins(
        fontSize: 12,
        color: darkGreen,
      ),
      filled: true,
      fillColor: softGreen,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 17,
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
      errorStyle: GoogleFonts.poppins(fontSize: 10),
      suffixIcon: IconButton(
        tooltip: _hidePassword ? 'Show password' : 'Hide password',
        onPressed: () {
          setState(() {
            _hidePassword = !_hidePassword;
          });
        },
        icon: Icon(
          _hidePassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: darkGreen,
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

          // Navigate only after actual deletion succeeds.
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
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is DeleteAccountLoading;

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
                        onPressed: isLoading
                            ? null
                            : () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Delete Account',
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
                            onPressed: isLoading
                                ? null
                                : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
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
                        26,
                        32,
                        26,
                        30,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Delete icon
                            Container(
                              width: 75,
                              height: 75,
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.08),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.delete_forever_outlined,
                                color: Colors.red,
                                size: 39,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Heading
                            Text(
                              'Are You Sure You Want To Delete '
                                  'Your Account?',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: darkGreen,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Warning information
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: softGreen,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                'This action cannot be undone.\n\n'
                                    '• Your account will be permanently deleted.\n\n'
                                    '• Supported account data in Firestore '
                                    'will be removed.\n\n'
                                    '• You will need to create a new account '
                                    'to use FinWise again.',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  height: 1.6,
                                  color: darkGreen,
                                ),
                              ),
                            ),

                            const SizedBox(height: 27),

                            // Password instruction
                            Text(
                              'Enter your current password to confirm '
                                  'account deletion.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: darkGreen,
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Current password
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _hidePassword,
                              enabled: !isLoading,
                              autofillHints: const [
                                AutofillHints.password,
                              ],
                              decoration: _passwordDecoration(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 28),

                            // Delete button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : _confirmDeletion,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade600,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor:
                                  Colors.red.shade200,
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
                                    color: Colors.white,
                                  ),
                                )
                                    : Text(
                                  'Delete My Account',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Cancel button
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: OutlinedButton(
                                onPressed: isLoading
                                    ? null
                                    : () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: darkGreen,
                                  side: const BorderSide(
                                    color: mainGreen,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
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
