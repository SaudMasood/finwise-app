
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
import '../../bloc/profile/fingerprint/fingerprint_bloc.dart';
import '../../bloc/profile/fingerprint/fingerprint_event.dart';
import '../../bloc/profile/fingerprint/fingerprint_state.dart';
import '../notification/notification.dart';
import 'addfingerprint.dart';
import 'fingerprintolddelete.dart';

class FingerprintScreen extends StatelessWidget {
  const FingerprintScreen({super.key});

  String _fingerprintLabel() {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName?.trim();

    if (name != null && name.isNotEmpty) {
      return '$name Fingerprint';
    }

    final emailName = user?.email?.split('@').first.trim();

    if (emailName != null && emailName.isNotEmpty) {
      final formatted = emailName
          .replaceAll(RegExp(r'[._-]+'), ' ')
          .split(' ')
          .where((part) => part.isNotEmpty)
          .map(
            (part) =>
        '${part[0].toUpperCase()}${part.substring(1)}',
      )
          .join(' ');

      return '$formatted Fingerprint';
    }

    return 'My Fingerprint';
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final background = isDark
        ? AppColors.darkBackground
        : AppColors.primaryGreen;
    final surface =
    isDark ? AppColors.darkSurface : AppColors.lightGreen;
    final textColor =
    isDark ? AppColors.darkText : AppColors.darkGreen;

    final iconTileColor =
    isDark ? AppColors.darkCard : AppColors.blueLight;
    final addTileColor =
    isDark ? AppColors.darkSearchField : AppColors.blue;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            _header(context, isDark, textColor),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  28,
                  34,
                  28,
                  25,
                ),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(45),
                  ),
                ),
                child: BlocConsumer<FingerprintBloc,
                    FingerprintState>(
                  listener: (context, state) {
                    if (state is FingerprintFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is FingerprintInitial ||
                        state is FingerprintLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryGreen,
                        ),
                      );
                    }

                    if (state is FingerprintFailure) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<FingerprintBloc>()
                                    .add(LoadFingerprint());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                AppColors.primaryGreen,
                                foregroundColor:
                                AppColors.darkGreen,
                              ),
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is! FingerprintLoaded) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      children: [
                        if (state.enabled) ...[
                          _tile(
                            context: context,
                            icon: Icons.fingerprint,
                            color: iconTileColor,
                            title: _fingerprintLabel(),
                            textColor: textColor,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      BlocProvider.value(
                                        value: context
                                            .read<FingerprintBloc>(),
                                        child:
                                        const FingerprintOldDeleteScreen(),
                                      ),
                                ),
                              ).then((_) {
                                if (context.mounted) {
                                  context
                                      .read<FingerprintBloc>()
                                      .add(LoadFingerprint());
                                }
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                        _tile(
                          context: context,
                          icon: Icons.add,
                          color: addTileColor,
                          title: 'Add A Fingerprint',
                          textColor: textColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context
                                      .read<FingerprintBloc>(),
                                  child:
                                  const AddFingerprintScreen(),
                                ),
                              ),
                            ).then((_) {
                              if (context.mounted) {
                                context
                                    .read<FingerprintBloc>()
                                    .add(LoadFingerprint());
                              }
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(
      BuildContext context,
      bool isDark,
      Color textColor,
      ) {
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.maybePop(context),
              icon: Icon(
                Icons.arrow_back,
                color: isDark
                    ? AppColors.darkText
                    : AppColors.white,
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Fingerprint',
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.darkText
                        : AppColors.white,
                  ),
                ),
              ),
            ),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkCard
                    : AppColors.lightGreen,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const NotificationScreen(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.notifications_none,
                  color: textColor,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 18),
          ],
        ),
      ),
    );
  }

  Widget _tile({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: 58,
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: isDark
                      ? AppColors.lightGreen
                      : AppColors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isDark
                    ? AppColors.darkSecondaryText
                    : textColor,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
