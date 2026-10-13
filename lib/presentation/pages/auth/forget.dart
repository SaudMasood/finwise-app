import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/wigit/authn_wid.dart';
import '../../../data/datasources/facebooklogind.dart';
import '../../../data/datasources/forgetpassdatas.dart';
import '../../../data/datasources/goglelogindatas.dart';
import '../../../data/datasources/logindatasource.dart';
import '../../../data/repositories/auth/forget.dart';
import '../../../data/repositories/auth/auth_repository_impl.dart';
import '../../../domain/usecases/auth/forget.dart';
import '../../../domain/usecases/auth/loginusecase.dart';
import '../../bloc/auth/forget/forget_bloc.dart';
import '../../bloc/auth/forget/forget_event.dart';
import '../../bloc/auth/forget/forget_state.dart';
import '../../bloc/auth/login/login_bloc.dart';
import '../../bloc/auth/login/login_event.dart';
import '../../bloc/auth/login/login_state.dart';
import '../MainScreen/mainscreen.dart';
import 'securitypin.dart';


class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ForgotPasswordBloc>(
          create: (_) {
            final dataSource = ForgotPasswordDataSource(
              firebaseAuth: FirebaseAuth.instance,
            );
            final repository = ForgotPasswordRepositoryImpl(
              dataSource: dataSource,
            );

            return ForgotPasswordBloc(
              forgotPasswordUseCase: ForgotPasswordUseCase(
                repository: repository,
              ),
            );
          },
        ),

        BlocProvider<LoginBloc>(
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

            return LoginBloc(
              loginUseCase: LoginUseCase(repository: authRepository),
            );
          },
        ),
      ],
      child: const ForgotPasswordView(),
    );
  }
}

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  // Called when "Next Step" is pressed
  void sendReset() {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email.')),
      );
      return;
    }

    context.read<ForgotPasswordBloc>().add(
      ForgotPasswordButtonPressed(email: email),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen to both blocs
    return MultiBlocListener(
      listeners: [
        // Reset email result
        BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotPasswordSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password reset email sent successfully.'),
                ),
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SecurityPinScreen(
                    email: emailController.text.trim(),
                  ),
                ),
              );
            }

            if (state is ForgotPasswordFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),

        // Social login result
        BlocListener<LoginBloc, LoginState>(
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
        ),
      ],
      child: AuthLayout(
        title: 'Forgot Password',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),

            // Heading
            Text(
              'Reset Password?',
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: dark,
              ),
            ),
            const SizedBox(height: 6),

            // Small description
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do '
                  'eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              style: GoogleFonts.poppins(fontSize: 9, height: 1.3, color: dark),
            ),

            const SizedBox(height: 40),

            // Email field
            AuthField(
              label: 'Enter Email Address',
              hint: 'example@example.com',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 20),

            // Next Step button (shows loading spinner)
            Center(
              child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                builder: (context, state) {
                  return GreenButton(
                    text: 'Next Step',
                    width: 150,
                    loading: state is ForgotPasswordLoading,
                    onTap: sendReset,
                  );
                },
              ),
            ),

            const SizedBox(height: 60),

            // Sign Up button (same as before: does nothing yet)
            Center(
              child: GreenButton(
                text: 'Sign Up',
                filled: false,
                width: 120,
                onTap: () {},
              ),
            ),

            const SizedBox(height: 14),

            // Facebook and Google
            Center(
              child: SocialRow(
                onFacebook: () {
                  context
                      .read<LoginBloc>()
                      .add(const FacebookLoginButtonPressed());
                },
                onGoogle: () {
                  context.read<LoginBloc>().add(const GoogleLoginButtonPressed());
                },
              ),
            ),

            const SizedBox(height: 18),

            Center(
              child: BottomText(
                normalText: 'Don’t have an account? ',
                linkText: 'Sign Up',
                onTap: () {},
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}