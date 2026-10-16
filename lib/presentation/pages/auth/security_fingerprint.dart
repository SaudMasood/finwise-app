
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';

import '../../../core/color/app_color.dart';
import '../MainScreen/mainscreen.dart';

class SecurityFingerprintScreen extends StatefulWidget {
  const SecurityFingerprintScreen({super.key});

  @override
  State<SecurityFingerprintScreen> createState() =>
      _SecurityFingerprintScreenState();
}

class _SecurityFingerprintScreenState
    extends State<SecurityFingerprintScreen> {
  static const bool _biometricOnly = true;

  final LocalAuthentication _localAuth = LocalAuthentication();

  bool _isAuthenticating = false;

  Future<void> _authenticateFingerprint() async {
    if (_isAuthenticating) return;

    setState(() => _isAuthenticating = true);

    try {
      final supported = await _localAuth.isDeviceSupported();
      final canCheck = await _localAuth.canCheckBiometrics;

      if (!mounted) return;

      if (!supported && !canCheck) {
        _showMessage(
          'Biometric authentication is not available on this device.',
        );
        return;
      }

      final authenticated = await _localAuth.authenticate(
        localizedReason:
        'Verify your fingerprint to access FinWise',
        biometricOnly: _biometricOnly,
        persistAcrossBackgrounding: true,
      );

      if (!mounted) return;

      if (authenticated) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const MainScreen(),
          ),
              (route) => false,
        );
      } else {
        _showMessage(
          'Fingerprint not verified. Please try again.',
        );
      }
    } on LocalAuthException catch (e) {
      debugPrint('LocalAuth error: ${e.code}');

      if (!mounted) return;

      switch (e.code) {
        case LocalAuthExceptionCode.userCanceled:
          break;

        case LocalAuthExceptionCode.noBiometricsEnrolled:
          _showMessage(
            'No fingerprint is enrolled. Add one in phone Settings > Security.',
          );
          break;

        case LocalAuthExceptionCode.noBiometricHardware:
          _showMessage(
            'This device has no fingerprint sensor.',
          );
          break;

        case LocalAuthExceptionCode.temporaryLockout:
        case LocalAuthExceptionCode.biometricLockout:
          _showMessage(
            'Too many attempts. Try again later.',
          );
          break;

        default:
          _showMessage('Fingerprint error: ${e.code.name}');
      }
    } catch (e, stackTrace) {
      debugPrint('Unexpected fingerprint error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (mounted) {
        _showMessage(
          'Unable to authenticate. Please try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAuthenticating = false);
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.18,
              child: Center(
                child: Text(
                  'Security Fingerprint',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.065),
                      Container(
                        width: 128,
                        height: 128,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryGreen,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.fingerprint,
                            size: 92,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.045),
                      Text(
                        'Use Fingerprint To Access',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.14,
                        ),
                        child: Text(
                          'Verify your identity securely using your registered '
                              'device fingerprint to access your FinWise account.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            height: 1.5,
                            color: secondaryText,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.055),
                      SizedBox(
                        width: size.width * 0.80,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: _isAuthenticating
                              ? null
                              : _authenticateFingerprint,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            AppColors.primaryGreen,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                            AppColors.primaryGreen
                                .withValues(alpha: 0.6),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(25),
                            ),
                          ),
                          child: _isAuthenticating
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
                            'Use Fingerprint',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Back to Login',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: secondaryText,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.08),
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
