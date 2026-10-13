import 'package:finwise/presentation/pages/auth/security_fingerprint.dart';
import 'package:finwise/presentation/pages/auth/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/wigit/authn_wid.dart';
import '../../../data/datasources/facebooklogind.dart';
import '../../../data/datasources/goglelogindatas.dart';
import '../../../data/datasources/logindatasource.dart';
import '../../../data/repositories/auth/auth_repository_impl.dart';
import '../../../domain/usecases/auth/loginusecase.dart';
import '../../bloc/auth/login/login_bloc.dart';
import '../../bloc/auth/login/login_event.dart';
import '../../bloc/auth/login/login_state.dart';
import '../MainScreen/mainscreen.dart';
import 'forget.dart';
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final loginDataSource = LoginDataSource(
          firebaseAuth: FirebaseAuth.instance,
        );
        final googleLoginDataSource = GoogleLoginDataSource(
          firebaseAuth: FirebaseAuth.instance,
        );
        final facebookLoginDataSource = FacebookLoginDataSource(
          firebaseAuth: FirebaseAuth.instance,
        );

        final authRepository = AuthRepositoryImpl(
          loginDataSource: loginDataSource,
          googleLoginDataSource: googleLoginDataSource,
          facebookLoginDataSource: facebookLoginDataSource,
        );

        return LoginBloc(loginUseCase: LoginUseCase(repository: authRepository));
      },
      child: const LoginView(),
    );
  }
}

// -----------------------------------------------------
// View: the UI
// -----------------------------------------------------
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isPasswordVisible = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Called when "Log In" is pressed
  void login() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password.')),
      );
      return;
    }

    context.read<LoginBloc>().add(
      LoginButtonPressed(email: email, password: password),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen to login result: success -> main screen, failure -> message
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }

        if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: AuthLayout(
        title: 'Welcome',
        child: Column(
          children: [
            const SizedBox(height: 50),

            AuthField(
              label: 'Username Or Email',
              hint: 'example@example.com',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),

            // Password
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

            const SizedBox(height: 40),

            // Log In button (shows loading spinner)
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return GreenButton(
                  text: 'Log In',
                  loading: state is LoginLoading,
                  onTap: login,
                );
              },
            ),

            const SizedBox(height: 10),

            // Forgot password
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ForgotPasswordScreen(),
                  ),
                );
              },
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: dark,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Sign Up button
            GreenButton(
              text: 'Sign Up',
              filled: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateAccountScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 22),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SecurityFingerprintScreen(),
                  ),
                );
              },
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: dark,
                  ),
                  children: const [
                    TextSpan(text: 'Use '),
                    TextSpan(text: 'Fingerprint', style: TextStyle(color: blue)),
                    TextSpan(text: ' To Access'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 22),

            // Facebook and Google
            SocialRow(
              onFacebook: () {
                context.read<LoginBloc>().add(const FacebookLoginButtonPressed());
              },
              onGoogle: () {
                context.read<LoginBloc>().add(const GoogleLoginButtonPressed());
              },
            ),

            const SizedBox(height: 18),
            BottomText(
              normalText: 'Don’t have an account? ',
              linkText: 'Sign Up',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateAccountScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}