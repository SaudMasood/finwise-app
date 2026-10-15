
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
import '../../../data/datasources/local/profile_data_locl.dart';
import '../../../data/datasources/remote/profile_datas.dart';
import '../../../data/repositories/profile/profile_repository_impl.dart';
import '../../../domain/usecases/profile/profile_usecase.dart';
import '../../bloc/profile/profile_bloc.dart';
import '../../bloc/profile/profile_event.dart';
import '../../bloc/profile/profile_state.dart';
import '../notification/notification.dart';
import 'editprofile.dart';
import 'security.dart';
import '../settings/settings.dart';
import '../help/help_faq_contact.dart';
import '../logout/logout.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localDataSource = ProfileLocalDataSource();
    final remoteDataSource = ProfileRemoteDataSource();

    final repository = ProfileRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );

    return BlocProvider(
      create: (_) => ProfileBloc(
        getProfile: GetProfile(repository),
        saveProfile: SaveProfile(repository),
        pickProfileImage: PickProfileImage(repository),
      )..add(const LoadProfile()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  static const double _avatarSize = 84;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor =
    isDark ? AppColors.darkBackground : AppColors.primaryGreen;
    final surfaceColor =
    isDark ? AppColors.darkSurface : AppColors.lightGreen;
    final textColor = isDark ? AppColors.darkText : AppColors.darkGreen;
    final secondaryColor =
    isDark ? AppColors.darkSecondaryText : AppColors.darkGreen;
    final avatarBackground =
    isDark ? AppColors.darkCard : AppColors.softGreen;

    return BlocConsumer<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) =>
      previous.error != current.error ||
          previous.message != current.message,
      listener: (context, state) {
        final message = state.message ?? state.error;

        if (message != null && message.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: state.error != null
                  ? AppColors.error
                  : AppColors.darkGreen,
            ),
          );
        }
      },
      builder: (context, state) {
        final profile = state.profile;
        final user = FirebaseAuth.instance.currentUser;

        final displayName = profile?.name.trim().isNotEmpty == true
            ? profile!.name.trim()
            : (user?.displayName?.trim().isNotEmpty == true
            ? user!.displayName!.trim()
            : (user?.email?.split('@').first ?? 'Your Name'));

        final uid = user?.uid ?? profile?.uid ?? '';
        final shortId = uid.length > 8 ? uid.substring(0, 8) : uid;

        return Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 125,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: IconButton(
                            onPressed: () => Navigator.maybePop(context),
                            icon: Icon(
                              Icons.arrow_back,
                              color: isDark
                                  ? AppColors.darkText
                                  : AppColors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 60),
                            child: Center(
                              child: Text(
                                'Profile',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppColors.darkText
                                      : AppColors.darkGreen,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            width: 30,
                            height: 30,
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
                                size: 19,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(45),
                            topRight: Radius.circular(45),
                          ),
                        ),
                        child: state.isLoading
                            ? Center(
                          child: CircularProgressIndicator(
                            color: isDark
                                ? AppColors.lightGreen
                                : AppColors.primaryGreen,
                          ),
                        )
                            : profile == null
                            ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Unable to load profile.',
                                style: TextStyle(
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<ProfileBloc>()
                                      .add(const LoadProfile());
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                            : SingleChildScrollView(
                          padding: const EdgeInsets.only(
                            top: _avatarSize / 2 + 14,
                            bottom: 24,
                          ),
                          child: Column(
                            children: [
                              Text(
                                displayName,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'ID: $shortId',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: secondaryColor,
                                ),
                              ),
                              const SizedBox(height: 28),
                              _ProfileMenuItem(
                                icon: Icons.person_outline,
                                title: 'Edit Profile',
                                color: AppColors.blue,
                                textColor: textColor,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                      const EditProfileScreen(),
                                    ),
                                  );

                                  if (context.mounted) {
                                    context
                                        .read<ProfileBloc>()
                                        .add(const LoadProfile());
                                  }
                                },
                              ),
                              _ProfileMenuItem(
                                icon: Icons.verified_user_outlined,
                                title: 'Security',
                                color: AppColors.strongBlue,
                                textColor: textColor,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                      const SecurityScreen(),
                                    ),
                                  );
                                },
                              ),
                              _ProfileMenuItem(
                                icon: Icons.settings_outlined,
                                title: 'Setting',
                                color: AppColors.calendarBlue,
                                textColor: textColor,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                      const SettingsScreen(),
                                    ),
                                  );
                                },
                              ),
                              _ProfileMenuItem(
                                icon: Icons.support_agent,
                                title: 'Help',
                                color: AppColors.blue,
                                textColor: textColor,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                      const FaqContactScreen(),
                                    ),
                                  );
                                },
                              ),
                              _ProfileMenuItem(
                                icon: Icons.logout,
                                title: 'Logout',
                                color: AppColors.strongBlue,
                                textColor: textColor,
                                onTap: () =>
                                    showLogoutDialog(context),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Positioned(
                        top: -(_avatarSize / 2),
                        left: 0,
                        right: 0,
                        child: Center(
                          child: ClipOval(
                            child: SizedBox(
                              width: _avatarSize,
                              height: _avatarSize,
                              child: profile?.imagePath != null &&
                                  File(profile!.imagePath!).existsSync()
                                  ? Image.file(
                                File(profile.imagePath!),
                                width: _avatarSize,
                                height: _avatarSize,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: avatarBackground,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.person,
                                    size: 44,
                                    color: textColor,
                                  ),
                                ),
                              )
                                  : Image.asset(
                                'assets/images/profile.png',
                                width: _avatarSize,
                                height: _avatarSize,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: avatarBackground,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.person,
                                    size: 44,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
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

class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 11,
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: AppColors.white,
                size: 25,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: textColor,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
