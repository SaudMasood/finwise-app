import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// Password dependencies
import '../../../data/datasources/deleteaccount.dart';
import '../../../data/datasources/password_datasorce.dart';
import '../../../data/repositories/deleteacc/deleteacc_repo_imp.dart';
import '../../../data/repositories/paswword_repo_imp/pasword_repo_imp.dart';
import '../../../domain/repositories/deleteaccount/deleteaccount_repo.dart';
import '../../../domain/repositories/password/password.dart';
import '../../../domain/usecases/deleteacc/deleteacc.dart';
import '../../../domain/usecases/paswrd/password.dart';
import '../../bloc/deleteacc/deleteaccount_bloc.dart';
import '../../bloc/password/password_bloc.dart';


import '../notification/notification.dart';
import 'notifsetting.dart';
import 'passwordsetnew.dart';
import 'deleteacc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const Color mainGreen = Color(0xFF00D09E);
  static const Color lightGreen = Color(0xFFF1FFF3);
  static const Color softGreen = Color(0xFFDDF5E2);
  static const Color darkGreen = Color(0xFF063F3F);

  void _openPasswordSettings(BuildContext context) {
    final dataSource = PasswordRemoteDataSource();

    final PasswordRepository repository = PasswordRepositoryImpl(
      remoteDataSource: dataSource,
    );

    final useCase = ChangePasswordUseCase(
      repository: repository,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => PasswordBloc(
            changePasswordUseCase: useCase,
          ),
          child: const PasswordSettingScreen(),
        ),
      ),
    );
  }

  // Open notifications
  void _openNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NotificationScreen(),
      ),
    );
  }

  // Open notification settings
  void _openNotificationSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NotificationSettingsScreen(),
      ),
    );
  }

  void _openDeleteAccount(BuildContext context) {
    final dataSource = DeleteAccountRemoteDataSource();

    final DeleteAccountRepository repository =
    DeleteAccountRepositoryImpl(
      remoteDataSource: dataSource,
    );

    final useCase = DeleteAccountUseCase(
      repository: repository,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => DeleteAccountBloc(
            deleteAccountUseCase: useCase,
          ),
          child: const DeleteAccountScreen(),
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final Color iconColor = isDestructive ? Colors.red : mainGreen;
    final Color textColor = isDestructive ? Colors.red : darkGreen;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 7,
      ),
      leading: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 23,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: textColor,
        size: 25,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainGreen,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            SizedBox(
              height: 110,
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 23,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Settings',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: darkGreen,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: lightGreen,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        tooltip: 'Notifications',
                        onPressed: () => _openNotifications(context),
                        icon: const Icon(
                          Icons.notifications_none,
                          color: darkGreen,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    25,
                    35,
                    25,
                    30,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Settings',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: darkGreen,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        'Manage your account and preferences.',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: darkGreen.withValues(alpha: 0.65),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Settings options
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: darkGreen.withValues(alpha: 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildSettingsTile(
                              icon: Icons.notifications_none_rounded,
                              title: 'Notification Settings',
                              onTap: () =>
                                  _openNotificationSettings(context),
                            ),
                            const Divider(
                              height: 1,
                              indent: 76,
                              endIndent: 20,
                              color: Color(0xFFE8F2EB),
                            ),
                            _buildSettingsTile(
                              icon: Icons.lock_outline_rounded,
                              title: 'Password Settings',
                              onTap: () =>
                                  _openPasswordSettings(context),
                            ),
                            const Divider(
                              height: 1,
                              indent: 76,
                              endIndent: 20,
                              color: Color(0xFFE8F2EB),
                            ),
                            _buildSettingsTile(
                              icon: Icons.person_outline_rounded,
                              title: 'Delete Account',
                              isDestructive: true,
                              onTap: () =>
                                  _openDeleteAccount(context),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Security information
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(17),
                        decoration: BoxDecoration(
                          color: softGreen,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 43,
                              height: 43,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(
                                  alpha: 0.7,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.shield_outlined,
                                color: darkGreen,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 13),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Your Security Matters',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: darkGreen,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Use a strong password and keep your '
                                        'account information secure.',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      height: 1.7,
                                      color: darkGreen.withValues(
                                        alpha: 0.75,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}