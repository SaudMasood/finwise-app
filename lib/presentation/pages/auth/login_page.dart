
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
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
import 'security_fingerprint.dart';
import 'signup_page.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final auth = FirebaseAuth.instance;

        final loginDataSource = LoginDataSource(
          firebaseAuth: auth,
        );
        final googleDataSource = GoogleLoginDataSource(
          firebaseAuth: auth,
        );
        final facebookDataSource = FacebookLoginDataSource(
          firebaseAuth: auth,
        );

        final repository = AuthRepositoryImpl(
          loginDataSource: loginDataSource,
          googleLoginDataSource: googleDataSource,
          facebookLoginDataSource: facebookDataSource,
        );

        return LoginBloc(
          loginUseCase: LoginUseCase(repository: repository),
        );
      },
      child: const LoginView(),
    );
  }
}

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

  void login() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter email and password.'),
        ),
      );
      return;
    }

    context.read<LoginBloc>().add(
      LoginButtonPressed(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const MainScreen(),
            ),
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
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordScreen(),
                    ),
                  );
                },
                child: Text(
                  'Forgot Password?',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return GreenButton(
                  text: 'Log In',
                  loading: state is LoginLoading,
                  onTap: login,
                );
              },
            ),
            const SizedBox(height: 12),
            GreenButton(
              text: 'Sign Up',
              filled: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateAccountScreen(),
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
                    builder: (_) => const SecurityFingerprintScreen(),
                  ),
                );
              },
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  children: [
                    const TextSpan(text: 'Use '),
                    TextSpan(
                      text: 'Fingerprint',
                      style: TextStyle(color: AppColors.blue),
                    ),
                    const TextSpan(text: ' To Access'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            SocialRow(
              onFacebook: () {
                context.read<LoginBloc>().add(
                  const FacebookLoginButtonPressed(),
                );
              },
              onGoogle: () {
                context.read<LoginBloc>().add(
                  const GoogleLoginButtonPressed(),
                );
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
                    builder: (_) => const CreateAccountScreen(),
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
