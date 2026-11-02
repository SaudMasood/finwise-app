import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
import '../../../core/wigit/authn_wid.dart';
import '../../../data/datasources/logindatasource.dart';
import '../../../data/datasources/signupdatasorce.dart';
import '../../../data/repositories/auth/auth_repository_impl.dart';
import '../../../domain/usecases/auth/signupusecase.dart';
import '../../bloc/auth/signup/signup_bloc.dart';
import '../../bloc/auth/signup/signup_event.dart';
import '../../bloc/auth/signup/signup_state.dart';
import 'login_page.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final auth = FirebaseAuth.instance;

        final loginDataSource =
        LoginDataSource(firebaseAuth: auth);

        final signupDataSource =
        SignupDataSource(firebaseAuth: auth);

        final repository = AuthRepositoryImpl(
          loginDataSource: loginDataSource,
          signupDataSource: signupDataSource,
        );

        return SignupBloc(
          signupUseCase: SignupUseCase(
            repository: repository,
          ),
        );
      },
      child: const CreateAccountView(),
    );
  }
}

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({super.key});

  @override
  State<CreateAccountView> createState() =>
      _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? _validateFullName(String value) {
    final name = value.trim();

    if (name.isEmpty) {
      return 'Full name is required.';
    }

    if (name.length < 2) {
      return 'Name must contain at least 2 characters.';
    }

    if (!RegExp(r"^[a-zA-Z][a-zA-Z\s'-]*$").hasMatch(name)) {
      return 'Enter a valid name.';
    }

    return null;
  }

  String? _validateEmail(String value) {
    final email = value.trim();

    if (email.isEmpty) {
      return 'Email is required.';
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Enter a valid email address.';
    }

    return null;
  }

  String? _validateMobile(String value) {
    final mobile = value.trim();

    if (mobile.isEmpty) {
      return 'Mobile number is required.';
    }

    if (!RegExp(r'^\+?[0-9\s()-]+$').hasMatch(mobile)) {
      return 'Enter a valid mobile number.';
    }

    final digits = mobile.replaceAll(RegExp(r'\D'), '');

    if (digits.length < 7 || digits.length > 15) {
      return 'Mobile number must contain 7–15 digits.';
    }

    return null;
  }

  String? _validateDateOfBirth(String value) {
    final date = value.trim();

    if (date.isEmpty) {
      return 'Date of birth is required.';
    }

    if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(date)) {
      return 'Use DD/MM/YYYY format.';
    }

    final parts = date.split('/');
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      return 'Enter a valid date.';
    }

    final parsedDate = DateTime(year, month, day);

    if (parsedDate.day != day ||
        parsedDate.month != month ||
        parsedDate.year != year) {
      return 'Enter a valid date.';
    }

    if (parsedDate.isAfter(DateTime.now())) {
      return 'Date of birth cannot be in the future.';
    }

    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required.';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters.';
    }

    return null;
  }

  String? _validateConfirmPassword(String value) {
    if (value.isEmpty) {
      return 'Please confirm your password.';
    }

    if (value != passwordController.text) {
      return 'Passwords do not match.';
    }

    return null;
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    dateOfBirthController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void signUp() {
    final errors = [
      _validateFullName(fullNameController.text),
      _validateEmail(emailController.text),
      _validateMobile(mobileController.text),
      _validateDateOfBirth(dateOfBirthController.text),
      _validatePassword(passwordController.text),
      _validateConfirmPassword(confirmPasswordController.text),
    ];

    final firstError = errors.whereType<String>().firstOrNull;

    if (firstError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(firstError)),
      );
      return;
    }

    context.read<SignupBloc>().add(
      SignupButtonPressed(
        email: emailController.text.trim(),
        password: passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final secondaryText = isDark
        ? AppColors.darkSecondaryText
        : AppColors.lightSecondaryText;

    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully.'),
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            ),
          );
        }

        if (state is SignupFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: AuthLayout(
        title: 'Create Account',
        child: Column(
          children: [
            const SizedBox(height: 25),

            AuthField(
              label: 'Full Name',
              hint: 'Enter your full name',
              controller: fullNameController,
              validator: _validateFullName,
            ),

            AuthField(
              label: 'Email',
              hint: 'example@example.com',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
            ),

            AuthField(
              label: 'Mobile Number',
              hint: '+123456789',
              controller: mobileController,
              keyboardType: TextInputType.phone,
              validator: _validateMobile,
            ),

            AuthField(
              label: 'Date Of Birth',
              hint: 'DD / MM / YYYY',
              controller: dateOfBirthController,
              keyboardType: TextInputType.datetime,
              validator: _validateDateOfBirth,
            ),

            AuthField(
              label: 'Password',
              hint: 'Enter password',
              controller: passwordController,
              isPassword: true,
              hidden: !isPasswordVisible,
              validator: _validatePassword,
              onChanged: (_) {
                // Rebuild the confirm-password field so it
                // checks again when the original password changes.
                setState(() {});
              },
              onEyeTap: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            ),

            AuthField(
              label: 'Confirm Password',
              hint: 'Confirm password',
              controller: confirmPasswordController,
              isPassword: true,
              hidden: !isConfirmPasswordVisible,
              validator: _validateConfirmPassword,
              onEyeTap: () {
                setState(() {
                  isConfirmPasswordVisible =
                  !isConfirmPasswordVisible;
                });
              },
            ),

            const SizedBox(height: 8),

            Text(
              'By continuing, you agree to\n'
                  'Terms of Use and Privacy Policy.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: secondaryText,
              ),
            ),

            const SizedBox(height: 16),

            BlocBuilder<SignupBloc, SignupState>(
              builder: (context, state) {
                return GreenButton(
                  text: 'Sign Up',
                  loading: state is SignupLoading,
                  onTap: signUp,
                );
              },
            ),

            const SizedBox(height: 12),

            BottomText(
              normalText: 'Already have an account? ',
              linkText: 'Log In',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}