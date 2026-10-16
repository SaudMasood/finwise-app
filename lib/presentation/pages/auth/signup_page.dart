
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
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword =
    confirmPasswordController.text.trim();

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter your name, email, and password.',
          ),
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match.'),
        ),
      );
      return;
    }

    context.read<SignupBloc>().add(
      SignupButtonPressed(
        email: email,
        password: password,
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
            ),
            AuthField(
              label: 'Email',
              hint: 'example@example.com',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            AuthField(
              label: 'Mobile Number',
              hint: '+123456789',
              controller: mobileController,
              keyboardType: TextInputType.phone,
            ),
            AuthField(
              label: 'Date Of Birth',
              hint: 'DD / MM / YYYY',
              controller: dateOfBirthController,
              keyboardType: TextInputType.datetime,
            ),
            AuthField(
              label: 'Password',
              hint: 'Enter password',
              controller: passwordController,
              isPassword: true,
              hidden: !isPasswordVisible,
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
