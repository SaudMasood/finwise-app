
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
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

  void sendReset() {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email.'),
        ),
      );
      return;
    }

    context.read<ForgotPasswordBloc>().add(
      ForgotPasswordButtonPressed(email: email),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onSurface;
    final secondaryText = isDark
        ? AppColors.darkSecondaryText
        : AppColors.lightSecondaryText;

    return MultiBlocListener(
      listeners: [
        BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotPasswordSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Password reset email sent successfully.',
                  ),
                ),
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SecurityPinScreen(
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
        BlocListener<LoginBloc, LoginState>(
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
        ),
      ],
      child: AuthLayout(
        title: 'Forgot Password',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Text(
              'Reset Password?',
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Enter your email address to reset your password.',
              style: GoogleFonts.poppins(
                fontSize: 11,
                height: 1.4,
                color: secondaryText,
              ),
            ),
            const SizedBox(height: 40),
            AuthField(
              label: 'Enter Email Address',
              hint: 'example@example.com',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
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
            Center(
              child: GreenButton(
                text: 'Sign Up',
                filled: false,
                width: 120,
                onTap: () {},
              ),
            ),
            const SizedBox(height: 14),
            Center(
              child: SocialRow(
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
