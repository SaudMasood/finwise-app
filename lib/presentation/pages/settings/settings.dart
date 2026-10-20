import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
import '../../../data/datasources/deleteaccount.dart';
import '../../../data/datasources/local_notification.dart';
import '../../../data/datasources/password_datasorce.dart';
import '../../../data/repositories/deleteacc/deleteacc_repo_imp.dart';
import '../../../data/repositories/local_noti/local_noti_repo.dart';
import '../../../data/repositories/paswword_repo_imp/pasword_repo_imp.dart';
import '../../../domain/repositories/deleteaccount/deleteaccount_repo.dart';
import '../../../domain/repositories/local_notific/local.dart';
import '../../../domain/repositories/password/password.dart';
import '../../../domain/usecases/deleteacc/deleteacc.dart';
import '../../../domain/usecases/paswrd/password.dart';
import '../../bloc/deleteacc/deleteaccount_bloc.dart';
import '../../bloc/local_noti/local_bloc.dart';
import '../../bloc/local_noti/local_event.dart';
import '../../bloc/password/password_bloc.dart';
import '../notification/notification.dart';
import 'notifsetting.dart';
import 'passwordsetnew.dart';
import 'deleteacc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  // ---------------------------------------------------------------------------
  // Navigation / logic (unchanged)
  // ---------------------------------------------------------------------------

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
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) => PasswordBloc(
            changePasswordUseCase: useCase,
          ),
          child: const PasswordSettingScreen(),
        ),
      ),
    );
  }

  void _openNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const NotificationScreen(),
      ),
    );
  }

  void _openNotificationSettings(BuildContext context) {
    final notificationService = LocalNotificationService();

    final NotificationSettingsRepository repository =
    NotificationSettingsRepositoryImpl(
      dataSource: notificationService,
    );

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider<NotificationSettingsBloc>(
          create: (_) => NotificationSettingsBloc(
            repository: repository,
            notificationService: notificationService,
          )..add(const LoadNotificationSettings()),
          child: const NotificationSettingsScreen(),
        ),
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
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) => DeleteAccountBloc(
            deleteAccountUseCase: useCase,
          ),
          child: const DeleteAccountScreen(),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // UI (matched to Figma)
  // ---------------------------------------------------------------------------

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final isDark = _isDark(context);

    final circleColor =
    isDestructive ? AppColors.error : AppColors.primaryGreen;

    final iconColor =
    isDark ? AppColors.darkBackground : AppColors.darkGreen;

    final textColor = isDestructive
        ? AppColors.error
        : (isDark ? AppColors.darkText : AppColors.darkGreen);

    final chevronColor = textColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 15,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: chevronColor,
              size: 13,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final headerTextColor =
    isDark ? AppColors.darkText : AppColors.darkGreen;

    return SizedBox(
      height: 72,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.maybePop(context),
              child: SizedBox(
                width: 32,
                height: 32,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.arrow_back,
                    color: isDark ? AppColors.darkText : AppColors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Settings',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: headerTextColor,
                  ),
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _openNotifications(context),
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightGreen,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_none,
                  color: isDark ? AppColors.darkText : AppColors.darkGreen,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _isDark(context);

    final background =
    isDark ? AppColors.darkBackground : AppColors.primaryGreen;
    final surface =
    isDark ? AppColors.darkSurface : AppColors.lightGreen;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(context, isDark),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(55),
                    topRight: Radius.circular(55),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(31, 50, 31, 30),
                  child: Column(
                    children: [
                      _buildSettingsTile(
                        context: context,
                        icon: Icons.notifications_none_rounded,
                        title: 'Notification Settings',
                        onTap: () => _openNotificationSettings(context),
                      ),
                      _buildSettingsTile(
                        context: context,
                        icon: Icons.vpn_key_outlined,
                        title: 'Password Settings',
                        onTap: () => _openPasswordSettings(context),
                      ),
                      _buildSettingsTile(
                        context: context,
                        icon: Icons.person_outline_rounded,
                        title: 'Delete Account',
                        onTap: () => _openDeleteAccount(context),
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