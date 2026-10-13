import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finwise/presentation/pages/profile/pinSuccesscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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

    final repository = SecurityRepositoryImpl(dataSource: dataSource);

    return BlocProvider(
      create: (_) =>
      SecurityBloc(repository: repository)..add(const CheckPinRequested()),
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
  static const Color mainGreen = Color(0xFF00D09E);
  static const Color lightGreen = Color(0xFFF1FFF3);
  static const Color softGreen = Color(0xFFDDF5E2);
  static const Color darkGreen = Color(0xFF063F3F);

  final _formKey = GlobalKey<FormState>();

  final _currentPinController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  bool _showCurrentPin = false;
  bool _showNewPin = false;
  bool _showConfirmPin = false;

  @override
  void dispose() {
    _currentPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  String? _validatePin(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your PIN';

    if (!RegExp(r'^\d{4}$').hasMatch(value)) {
      return 'PIN must contain exactly 4 digits';
    }

    return null;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_newPinController.text == _currentPinController.text &&
        _currentPinController.text.isNotEmpty) {
      _showMessage('New PIN must be different from current PIN');
      return;
    }

    if (_newPinController.text != _confirmPinController.text) {
      _showMessage('New PIN and Confirm PIN do not match');
      return;
    }

    context.read<SecurityBloc>().add(
      ChangePinRequested(
        currentPin: _currentPinController.text.trim(),
        newPin: _newPinController.text.trim(),
      ),
    );
  }

  Widget _header() {
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Change Pin',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: darkGreen,
                    ),
                  ),
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: lightGreen,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.notifications_none,
                    color: darkGreen,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pinField({
    required String label,
    required TextEditingController controller,
    required bool visible,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: darkGreen,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          obscureText: !visible,
          maxLength: 4,
          validator: validator ?? _validatePin,
          style: GoogleFonts.poppins(fontSize: 13, color: darkGreen),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: softGreen,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(
                visible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: darkGreen,
                size: 20,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: mainGreen, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red),
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
            MaterialPageRoute(builder: (_) => const PinSuccessScreen()),
          );
        }

        if (state is SecurityFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade700,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: mainGreen,
        body: SafeArea(
          child: Column(
            children: [
              _header(),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: lightGreen,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(45),
                    ),
                  ),
                  child: BlocBuilder<SecurityBloc, SecurityState>(
                    builder: (context, state) {
                      final loading = state is SecurityLoading;

                      return Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(28, 34, 28, 25),
                          child: Column(
                            children: [
                              _pinField(
                                label: 'Current Pin',
                                controller: _currentPinController,
                                visible: _showCurrentPin,
                                onToggle: () => setState(
                                      () => _showCurrentPin = !_showCurrentPin,
                                ),
                                validator: (v) => (v == null || v.isEmpty)
                                    ? null
                                    : _validatePin(v),
                              ),
                              const SizedBox(height: 20),
                              _pinField(
                                label: 'New Pin',
                                controller: _newPinController,
                                visible: _showNewPin,
                                onToggle: () => setState(
                                      () => _showNewPin = !_showNewPin,
                                ),
                              ),
                              const SizedBox(height: 20),
                              _pinField(
                                label: 'Confirm Pin',
                                controller: _confirmPinController,
                                visible: _showConfirmPin,
                                onToggle: () => setState(
                                      () => _showConfirmPin = !_showConfirmPin,
                                ),
                              ),
                              const SizedBox(height: 34),
                              SizedBox(
                                width: 165,
                                height: 38,
                                child: ElevatedButton(
                                  onPressed: loading ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: mainGreen,
                                    disabledBackgroundColor:
                                    mainGreen.withValues(alpha: 0.5),
                                    foregroundColor: darkGreen,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: loading
                                      ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: darkGreen,
                                    ),
                                  )
                                      : Text(
                                    'Change Pin',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
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