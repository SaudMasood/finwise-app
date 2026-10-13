
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bloc/profile/fingerprint/fingerprint_bloc.dart';
import '../../bloc/profile/fingerprint/fingerprint_event.dart';
import '../../bloc/profile/fingerprint/fingerprint_state.dart';
import '../notification/notification.dart';
import 'addfingerprint.dart';

class FingerprintOldDeleteScreen extends StatelessWidget {
  const FingerprintOldDeleteScreen({super.key});

  static const Color mainGreen = Color(0xFF00D09E);
  static const Color lightGreen = Color(0xFFF1FFF3);
  static const Color softGreen = Color(0xFFDDF5E2);
  static const Color darkGreen = Color(0xFF063F3F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainGreen,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 90,
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Fingerprint',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: darkGreen,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: lightGreen,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationScreen(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.notifications_none,
                        color: darkGreen,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                decoration: const BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(40),
                  ),
                ),
                child: BlocConsumer<FingerprintBloc, FingerprintState>(
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
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    final loading = state is FingerprintLoading;

                    final label = state is FingerprintLoaded
                        ? state.label ?? 'Fingerprint'
                        : 'Fingerprint';

                    return Column(
                      children: [
                        const SizedBox(height: 45),
                        Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            color: mainGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.fingerprint,
                            size: 83,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          width: double.infinity,
                          height: 36,
                          decoration: BoxDecoration(
                            color: softGreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            label,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: darkGreen,
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 130,
                          height: 38,
                          child: ElevatedButton(
                            onPressed: loading
                                ? null
                                : () async {
                              final confirmed =
                              await showDialog<bool>(
                                context: context,
                                builder: (dialogContext) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Delete Fingerprint?',
                                    ),
                                    content: const Text(
                                      'Disable fingerprint access in FinWise?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(
                                            dialogContext,
                                            false,
                                          );
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(
                                            dialogContext,
                                            true,
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: mainGreen,
                                          foregroundColor: darkGreen,
                                        ),
                                        child: const Text('Delete'),
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
                              backgroundColor: mainGreen,
                              foregroundColor: darkGreen,
                              elevation: 0,
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
                                color: darkGreen,
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
}
