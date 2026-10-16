
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
import '../../../data/datasources/logout_remote_datasorce.dart';
import '../../../data/repositories/logout/logout_repository_impl.dart';
import '../../../domain/usecases/logout/logout_usecase.dart';
import '../../bloc/logout/logout_bloc.dart';
import '../../bloc/logout/logout_event.dart';
import '../../bloc/logout/logout_state.dart';
import '../auth/login_page.dart';

const Color _mainGreen = AppColors.primaryGreen;
const Color _lightGreen = AppColors.lightGreen;
const Color _darkGreen = AppColors.darkGreen;

Future<void> showLogoutDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: AppColors.black.withValues(alpha: 0.35),
    builder: (_) => BlocProvider<LogoutBloc>(
      create: (_) {
        final dataSource =
        LogoutRemoteDataSource(FirebaseAuth.instance);
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
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final dialogColor = isDark
        ? AppColors.darkSurface
        : AppColors.white;

    final titleColor = isDark
        ? AppColors.darkText
        : _darkGreen;

    final messageColor = isDark
        ? AppColors.darkSecondaryText
        : _darkGreen;

    final cancelColor = isDark
        ? AppColors.darkCard
        : _lightGreen;

    final cancelTextColor = isDark
        ? AppColors.darkText
        : _darkGreen;

    return BlocConsumer<LogoutBloc, LogoutState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          Navigator.of(context, rootNavigator: true)
              .pushAndRemoveUntil(
            MaterialPageRoute<void>(
              builder: (_) => const LoginScreen(),
            ),
                (route) => false,
          );
        }

        if (state is LogoutFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
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
            backgroundColor: dialogColor,
            insetPadding:
            const EdgeInsets.symmetric(horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Padding(
                padding:
                const EdgeInsets.fromLTRB(24, 32, 24, 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      size: 34,
                      color: _mainGreen,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'End Session',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Are you sure you want to log out?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 13,
                        color: messageColor,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Confirm logout
                    SizedBox(
                      width: 180,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                          context
                              .read<LogoutBloc>()
                              .add(LogoutRequested());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _mainGreen,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                          _mainGreen.withValues(alpha: 0.5),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(18),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child:
                          CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : Text(
                          'Yes, End Session',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Cancel
                    SizedBox(
                      width: 180,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cancelColor,
                          foregroundColor: cancelTextColor,
                          disabledBackgroundColor: cancelColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(18),
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
