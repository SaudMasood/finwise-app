import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/widgets/authn_wid.dart';
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
      create: (context) {
        final loginDataSource = LoginDataSource(
          firebaseAuth: FirebaseAuth.instance,
        );
        final signupDataSource = SignupDataSource(
          firebaseAuth: FirebaseAuth.instance,
        );

        final authRepository = AuthRepositoryImpl(
          loginDataSource: loginDataSource,
          signupDataSource: signupDataSource,
        );

        return SignupBloc(
          signupUseCase: SignupUseCase(repository: authRepository),
        );
      },
      child: const CreateAccountView(),
    );
  }
}

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({super.key});

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
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
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password.')),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }

    context.read<SignupBloc>().add(
      SignupButtonPressed(email: email, password: password),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen to sign up result
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account created successfully.')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
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
              hint: 'example@example.com',
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
              hint: '+ 123 456 789',
              controller: mobileController,
              keyboardType: TextInputType.phone,
            ),

            AuthField(
              label: 'Date Of Birth',
              hint: 'DD / MM /YYY',
              controller: dateOfBirthController,
              keyboardType: TextInputType.datetime,
            ),

            AuthField(
              label: 'Password',
              hint: '●●●●●●●●',
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
              hint: '●●●●●●●●',
              controller: confirmPasswordController,
              isPassword: true,
              hidden: !isConfirmPasswordVisible,
              onEyeTap: () {
                setState(() {
                  isConfirmPasswordVisible = !isConfirmPasswordVisible;
                });
              },
            ),

            // Terms text
            Text(
              'By continuing, you agree to\nTerms of Use and Privacy Policy.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 9, color: dark),
            ),

            const SizedBox(height: 10),

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
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
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