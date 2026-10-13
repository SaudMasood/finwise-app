import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/datasources/logout_remote_datasorce.dart';
import '../../../data/repositories/logout/logout_repository_impl.dart';
import '../../../domain/usecases/logout/logout_usecase.dart';
import '../../bloc/logout/logout_bloc.dart';
import '../../bloc/logout/logout_event.dart';
import '../../bloc/logout/logout_state.dart';
import '../auth/login_page.dart';

const Color _mainGreen = Color(0xFF00D09E);
const Color _lightGreen = Color(0xFFDFF7E2);
const Color _darkGreen = Color(0xFF063F3F);

Future<void> showLogoutDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (_) => BlocProvider(
      create: (_) {
        final dataSource = LogoutRemoteDataSource(FirebaseAuth.instance);
        final repository = LogoutRepositoryImpl(dataSource);
        final useCase = LogoutUseCase(repository);
        return LogoutBloc(useCase);
      },
      child: const _LogoutDialog(),
    ),
  );
}

class _LogoutDialog extends StatelessWidget {
  const _LogoutDialog();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogoutBloc, LogoutState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          // Dialog lives on the root navigator, so this also removes it.
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
                (route) => false,
          );
        }

        if (state is LogoutFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is LogoutLoading;

        return PopScope(
          canPop: !isLoading,
          child: Dialog(
            backgroundColor: Colors.white,
            insetPadding: const EdgeInsets.symmetric(horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 262),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'End Session',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _darkGreen,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Are you sure you want to log out?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 13,
                        color: _darkGreen,
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: 168,
                      height: 36,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () => context
                            .read<LogoutBloc>()
                            .add(LogoutRequested()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _mainGreen,
                          foregroundColor: _darkGreen,
                          disabledBackgroundColor:
                          _mainGreen.withValues(alpha: 0.5),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: _darkGreen,
                          ),
                        )
                            : Text(
                          'Yes, End Session',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 168,
                      height: 36,
                      child: ElevatedButton(
                        onPressed:
                        isLoading ? null : () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _lightGreen,
                          foregroundColor: _darkGreen,
                          disabledBackgroundColor: _lightGreen,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}