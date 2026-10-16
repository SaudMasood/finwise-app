import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finwise/presentation/pages/profile/pinSuccesscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
import '../../../data/datasources/remote/security_remote_data.dart';
import '../../../data/repositories/profile/security_repo_imp.dart';
import '../../bloc/profile/securty/security_bloc.dart';
import '../../bloc/profile/securty/security_event.dart';
import '../../bloc/profile/securty/security_state.dart';
import '../notification/notification.dart';

class ChangePinScreen extends StatelessWidget {
  const ChangePinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataSource = SecurityRemoteDataSource(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    );

    final repository = SecurityRepositoryImpl(
      dataSource: dataSource,
    );

    return BlocProvider(
      create: (_) => SecurityBloc(repository: repository)
        ..add(const CheckPinRequested()),
      child: const _ChangePinView(),
    );
  }
}

class _ChangePinView extends StatefulWidget {
  const _ChangePinView();

  @override
  State<_ChangePinView> createState() => _ChangePinViewState();
}

class _ChangePinViewState extends State<_ChangePinView> {
  final _formKey = GlobalKey<FormState>();

  final _currentPinController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  bool _showCurrentPin = false;
  bool _showNewPin = false;
  bool _showConfirmPin = false;

  // Figma colors
  static const Color _figmaHintColor = Color(0xFF80A99F);

  bool get _isDark =>
      Theme.of(context).brightness == Brightness.dark;

  Color get _background =>
      _isDark ? AppColors.darkBackground : AppColors.primaryGreen;

  Color get _surface =>
      _isDark ? AppColors.darkSurface : AppColors.lightGreen;

  Color get _fieldColor =>
      _isDark ? AppColors.darkSearchField : AppColors.softGreen;

  Color get _textColor =>
      _isDark ? AppColors.darkText : AppColors.darkGreen;

  Color get _secondaryTextColor =>
      _isDark ? AppColors.darkSecondaryText : AppColors.darkGreen;

  @override
  void dispose() {
    _currentPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  String? _validatePin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your PIN';
    }

    if (!RegExp(r'^\d{4}$').hasMatch(value)) {
      return 'PIN must contain exactly 4 digits';
    }

    return null;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _isDark
            ? AppColors.darkSurface
            : AppColors.darkGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final currentPin = _currentPinController.text.trim();
    final newPin = _newPinController.text.trim();
    final confirmPin = _confirmPinController.text.trim();

    if (newPin == currentPin) {
      _showMessage('New PIN must be different from current PIN');
      return;
    }

    if (newPin != confirmPin) {
      _showMessage('New PIN and Confirm PIN do not match');
      return;
    }

    context.read<SecurityBloc>().add(
      ChangePinRequested(
        currentPin: currentPin,
        newPin: newPin,
      ),
    );
  }

  Widget _header() {
    return SizedBox(
      height: 88,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 16, 0),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.maybePop(context),
              icon: Icon(
                Icons.arrow_back,
                color: _isDark ? AppColors.darkText : AppColors.white,
                size: 23,
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Change Pin',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    // Figma: dark title on the teal header
                    color: _isDark
                        ? AppColors.darkText
                        : AppColors.darkGreen,
                  ),
                ),
              ),
            ),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _isDark
                    ? AppColors.darkCard
                    : AppColors.lightGreen,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                tooltip: 'Notifications',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationScreen(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.notifications_none,
                  color: _isDark
                      ? AppColors.darkText
                      : AppColors.darkGreen,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Label above + pill field with dotted hint, like Figma.
  Widget _pinField({
    required String label,
    required TextEditingController controller,
    required bool visible,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    const radius = 25.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: _textColor,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          obscureText: !visible,
          obscuringCharacter: '•',
          maxLength: 4,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          validator: validator ?? _validatePin,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: _textColor,
            letterSpacing: visible ? 4 : 6,
          ),
          cursorColor: AppColors.primaryGreen,
          decoration: InputDecoration(
            counterText: '',
            hintText: '••••',
            hintStyle: GoogleFonts.poppins(
              fontSize: 13,
              letterSpacing: 6,
              color: _isDark
                  ? _secondaryTextColor.withValues(alpha: 0.7)
                  : _figmaHintColor,
            ),
            filled: true,
            fillColor: _fieldColor,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
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
              onPressed: onToggle,
              tooltip: visible ? 'Hide PIN' : 'Show PIN',
              icon: Icon(
                visible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: _secondaryTextColor,
                size: 20,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(
                color: _isDark
                    ? AppColors.darkDivider
                    : Colors.transparent,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: const BorderSide(
                color: AppColors.primaryGreen,
                width: 1.2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: const BorderSide(
                color: AppColors.error,
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
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SecurityBloc, SecurityState>(
      listener: (context, state) {
        if (state is SecurityPinChanged) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const PinSuccessScreen(),
            ),
          );
        }

        if (state is SecurityFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: _background,
        body: SafeArea(
          child: Column(
            children: [
              _header(),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(45),
                    ),
                  ),
                  child: BlocBuilder<SecurityBloc, SecurityState>(
                    builder: (context, state) {
                      final loading = state is SecurityLoading;

                      return Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: const EdgeInsets.fromLTRB(
                            28,
                            42,
                            28,
                            25,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _pinField(
                                label: 'Current Pin',
                                controller: _currentPinController,
                                visible: _showCurrentPin,
                                onToggle: () {
                                  setState(() {
                                    _showCurrentPin = !_showCurrentPin;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return null;
                                  }
                                  return _validatePin(value);
                                },
                              ),
                              const SizedBox(height: 26),
                              _pinField(
                                label: 'New Pin',
                                controller: _newPinController,
                                visible: _showNewPin,
                                onToggle: () {
                                  setState(() {
                                    _showNewPin = !_showNewPin;
                                  });
                                },
                              ),
                              const SizedBox(height: 26),
                              _pinField(
                                label: 'Confirm Pin',
                                controller: _confirmPinController,
                                visible: _showConfirmPin,
                                onToggle: () {
                                  setState(() {
                                    _showConfirmPin = !_showConfirmPin;
                                  });
                                },
                              ),
                              const SizedBox(height: 38),
                              Center(
                                child: SizedBox(
                                  width: 150,
                                  height: 42,
                                  child: ElevatedButton(
                                    onPressed: loading ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      AppColors.primaryGreen,
                                      disabledBackgroundColor:
                                      AppColors.primaryGreen.withValues(
                                        alpha: 0.5,
                                      ),
                                      foregroundColor:
                                      AppColors.darkGreen,
                                      elevation: 0,
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(25),
                                      ),
                                    ),
                                    child: loading
                                        ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child:
                                      CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.darkGreen,
                                      ),
                                    )
                                        : Text(
                                      'Change Pin',
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
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}