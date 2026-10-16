import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
import '../../bloc/profile/fingerprint/fingerprint_bloc.dart';
import '../../bloc/profile/fingerprint/fingerprint_event.dart';
import '../../bloc/profile/fingerprint/fingerprint_state.dart';
import '../notification/notification.dart';
import 'addfingerprint.dart';

class FingerprintOldDeleteScreen extends StatelessWidget {
  const FingerprintOldDeleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final background =
    isDark ? AppColors.darkBackground : AppColors.primaryGreen;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightGreen;
    final textColor = isDark ? AppColors.darkText : AppColors.darkGreen;
    final fieldColor = isDark ? AppColors.darkCard : AppColors.softGreen;

    return BlocConsumer<FingerprintBloc, FingerprintState>(
      listener: (context, state) {
        if (state is FingerprintSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const FingerprintResultScreen(
                deleted: true,
              ),
            ),
          );
        }

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
        final loading = state is FingerprintLoading;

        final label = state is FingerprintLoaded
            ? state.label ?? 'Fingerprint'
            : 'Fingerprint';

        return Scaffold(
          backgroundColor: background,
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 88,
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: () => Navigator.maybePop(context),
                        icon: Icon(
                          Icons.arrow_back,
                          color: isDark
                              ? AppColors.darkText
                              : AppColors.white,
                          size: 23,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          // Figma: the fingerprint name is the screen title.
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 36,
                        height: 36,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkCard
                              : AppColors.lightGreen,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          tooltip: 'Notifications',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const NotificationScreen(),
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
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(45),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 48),

                          // Fingerprint icon
                          Container(
                            width: 134,
                            height: 134,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkCard
                                  : AppColors.primaryGreen,
                              shape: BoxShape.circle,
                              border: isDark
                                  ? Border.all(
                                color: AppColors.lightGreen,
                                width: 1.5,
                              )
                                  : null,
                            ),
                            child: Icon(
                              Icons.fingerprint,
                              size: 92,
                              color: isDark
                                  ? AppColors.lightGreen
                                  : AppColors.white,
                            ),
                          ),

                          const SizedBox(height: 38),

                          // Fingerprint name pill (Figma: centered bold text)
                          Container(
                            width: double.infinity,
                            height: 30,
                            alignment: Alignment.center,
                            padding:
                            const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: fieldColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              label,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                          ),

                          const SizedBox(height: 62),

                          // Delete button stays green in dark mode.
                          SizedBox(
                            width: 140,
                            height: 32,
                            child: ElevatedButton(
                              onPressed: loading
                                  ? null
                                  : () async {
                                final confirmed =
                                await showDialog<bool>(
                                  context: context,
                                  builder: (dialogContext) {
                                    return AlertDialog(
                                      backgroundColor: isDark
                                          ? AppColors.darkSurface
                                          : AppColors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(18),
                                      ),
                                      title: Text(
                                        'Delete Fingerprint?',
                                        style: GoogleFonts.poppins(
                                          color: textColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      content: Text(
                                        'Disable fingerprint access in FinWise?',
                                        style: GoogleFonts.poppins(
                                          color: isDark
                                              ? AppColors
                                              .darkSecondaryText
                                              : AppColors.darkGreen,
                                          fontSize: 13,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(
                                            dialogContext,
                                            false,
                                          ),
                                          child: Text(
                                            'Cancel',
                                            style: GoogleFonts.poppins(
                                              color: isDark
                                                  ? AppColors.darkText
                                                  : AppColors.darkGreen,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => Navigator.pop(
                                            dialogContext,
                                            true,
                                          ),
                                          style:
                                          ElevatedButton.styleFrom(
                                            backgroundColor:
                                            AppColors.primaryGreen,
                                            foregroundColor:
                                            AppColors.darkGreen,
                                            elevation: 0,
                                          ),
                                          child: Text(
                                            'Delete',
                                            style: GoogleFonts.poppins(
                                              fontWeight:
                                              FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirmed == true &&
                                    context.mounted) {
                                  context.read<FingerprintBloc>().add(
                                    DisableFingerprint(),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryGreen,
                                disabledBackgroundColor:
                                AppColors.primaryGreen.withValues(
                                  alpha: 0.5,
                                ),
                                foregroundColor: AppColors.darkGreen,
                                elevation: 0,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                              ),
                              child: loading
                                  ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.darkGreen,
                                ),
                              )
                                  : Text(
                                'Delete',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 35),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}