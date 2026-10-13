import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/datasources/fingerprint_local_datasorce.dart';
import '../../../data/datasources/fingerprintdatas.dart';
import '../../../data/repositories/profile/fingerprint.dart';
import '../../bloc/profile/fingerprint/fingerprint_bloc.dart';
import '../../bloc/profile/fingerprint/fingerprint_event.dart';
import '../notification/notification.dart';
import 'changepin.dart';
import 'fingerprint.dart';
import 'termscondition.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  static const Color mainGreen = Color(0xFF00D09E);
  static const Color lightGreen = Color(0xFFF1FFF3);
  static const Color darkGreen = Color(0xFF063F3F);

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
                padding: const EdgeInsets.fromLTRB(28, 34, 28, 20),
                decoration: const BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(45),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Security',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: darkGreen,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _tile(
                      title: 'Change Pin',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChangePinScreen(),
                          ),
                        );
                      },
                    ),
                    _tile(
                      title: 'Fingerprint',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => FingerprintBloc(
                                FingerprintRepositoryImpl(
                                  biometricDataSource:
                                  FingerprintBiometricDataSource(),
                                  localDataSource: FingerprintLocalDataSource(),
                                ),
                              )..add(LoadFingerprint()),
                              child: const FingerprintScreen(),
                            ),
                          ),
                        );
                      },
                    ),
                    _tile(
                      title: 'Terms And Conditions',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TermsConditionScreen(),
                          ),
                        );
                      },
                    ),
                  ],
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
                    'Security',
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

  Widget _tile({required String title, required VoidCallback onTap}) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 52,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: darkGreen,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: darkGreen, size: 26),
              ],
            ),
          ),
        ),
        const Divider(height: 1, color: Color(0xFFDFF1E3)),
      ],
    );
  }
}