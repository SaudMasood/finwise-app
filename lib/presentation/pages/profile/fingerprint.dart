import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bloc/profile/fingerprint/fingerprint_bloc.dart';
import '../../bloc/profile/fingerprint/fingerprint_event.dart';
import '../../bloc/profile/fingerprint/fingerprint_state.dart';
import '../notification/notification.dart';
import 'addfingerprint.dart';
import 'fingerprintolddelete.dart';

class FingerprintScreen extends StatelessWidget {
  const FingerprintScreen({super.key});

  static const Color mainGreen = Color(0xFF00D09E);
  static const Color lightGreen = Color(0xFFF1FFF3);
  static const Color darkGreen = Color(0xFF063F3F);
  static const Color tileLight = Color(0xFF6DB6FF);
  static const Color tileMid = Color(0xFF3299FF);

  String _fingerprintLabel() {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName?.trim();

    if (name != null && name.isNotEmpty) return '$name Fingerprint';

    final emailName = user?.email?.split('@').first.trim();

    if (emailName != null && emailName.isNotEmpty) {
      final formatted = emailName
          .replaceAll(RegExp(r'[._-]+'), ' ')
          .split(' ')
          .where((part) => part.isNotEmpty)
          .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
          .join(' ');

      return '$formatted Fingerprint';
    }

    return 'My Fingerprint';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainGreen,
      body: SafeArea(
        child: Column(
          children: [
            _header(context),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(28, 34, 28, 25),
                decoration: const BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(45),
                  ),
                ),
                child: BlocConsumer<FingerprintBloc, FingerprintState>(
                  listener: (context, state) {
                    if (state is FingerprintFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is FingerprintInitial ||
                        state is FingerprintLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: mainGreen),
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
                                color: darkGreen,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<FingerprintBloc>()
                                    .add(LoadFingerprint());
                              },
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
                            icon: Icons.fingerprint,
                            color: tileLight,
                            title: _fingerprintLabel(),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<FingerprintBloc>(),
                                    child: const FingerprintOldDeleteScreen(),
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
                          icon: Icons.add,
                          color: tileMid,
                          title: 'Add A Fingerprint',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<FingerprintBloc>(),
                                  child: const AddFingerprintScreen(),
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

  Widget _header(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Fingerprint',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 46,
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: darkGreen,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: darkGreen, size: 24),
          ],
        ),
      ),
    );
  }
}