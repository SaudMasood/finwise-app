import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
import '../../../core/prefrences/app_prefrences.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/datasources/local/profile_data_locl.dart';
import '../../../data/datasources/remote/profile_datas.dart';
import '../../../data/repositories/profile/profile_repository_impl.dart';
import '../../../domain/entities/profile/profile.dart';
import '../../../domain/usecases/profile/profile_usecase.dart';
import '../../bloc/profile/profile_bloc.dart';
import '../../bloc/profile/profile_event.dart';
import '../../bloc/profile/profile_state.dart';
import '../notification/notification.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ProfileRepositoryImpl(
      remoteDataSource: ProfileRemoteDataSource(),
      localDataSource: ProfileLocalDataSource(),
    );

    return BlocProvider(
      create: (_) => ProfileBloc(
        getProfile: GetProfile(repository),
        saveProfile: SaveProfile(repository),
        pickProfileImage: PickProfileImage(repository),
      )..add(const LoadProfile()),
      child: const _EditProfileView(),
    );
  }
}

class _EditProfileView extends StatefulWidget {
  const _EditProfileView();

  @override
  State<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<_EditProfileView> {
  static const double _avatarSize = 88;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final localDataSource = ProfileLocalDataSource();

  String? imagePath;
  String? loadedUid;

  bool imageLoading = false;
  bool fieldsLoaded = false;
  bool notification = true;
  bool darkTheme = false;
  bool settingsLoading = true;

  bool get _isDark =>
      Theme.of(context).brightness == Brightness.dark;

  Color get _primaryGreen => AppColors.primaryGreen;

  // Fix: the outside area remains green in light mode.
  Color get _backgroundColor =>
      _isDark ? AppColors.darkBackground : AppColors.primaryGreen;

  // Fix: do not rely on the theme surface, which may be white.
  Color get _surfaceColor =>
      _isDark ? AppColors.darkSurface : AppColors.lightGreen;

  Color get _textColor =>
      _isDark ? AppColors.darkText : AppColors.darkGreen;

  Color get _secondaryTextColor =>
      _isDark ? AppColors.darkSecondaryText : AppColors.darkGreen;

  Color get _fieldColor =>
      _isDark ? AppColors.darkSearchField : AppColors.softGreen;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadAvatar();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (mounted) {
        setState(() {
          settingsLoading = false;
          darkTheme =
              AppTheme.themeMode.value == ThemeMode.dark;
        });
      }
      return;
    }

    try {
      final results = await Future.wait([
        AppPreferences.getDarkMode(user.uid),
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('settings')
            .doc('preferences')
            .get(),
      ]);

      final dark = results[0] as bool;
      final settings =
      results[1] as DocumentSnapshot<Map<String, dynamic>>;

      final notifications =
          settings.data()?['notificationsEnabled'] as bool? ?? true;

      if (!mounted) return;

      setState(() {
        darkTheme = dark;
        notification = notifications;
        settingsLoading = false;
      });

      AppTheme.setDarkMode(dark);
    } catch (e) {
      debugPrint('Unable to load profile settings: $e');

      if (!mounted) return;

      setState(() {
        darkTheme =
            AppTheme.themeMode.value == ThemeMode.dark;
        settingsLoading = false;
      });
    }
  }

  Future<void> _loadAvatar() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final path = await localDataSource.getImagePath(user.uid);

      if (!mounted) return;

      setState(() => imagePath = path);
    } catch (e) {
      debugPrint('Unable to load avatar: $e');

      if (!mounted) return;

      setState(() => imagePath = null);
    }
  }

  void _loadFields(UserProfile profile) {
    if (fieldsLoaded && loadedUid == profile.uid) return;

    fieldsLoaded = true;
    loadedUid = profile.uid;

    final user = FirebaseAuth.instance.currentUser;

    nameController.text = profile.name.isNotEmpty
        ? profile.name
        : (user?.email?.split('@').first ?? '');

    phoneController.text = profile.phone;
    emailController.text = user?.email ?? profile.email;
  }

  Future<void> _changeAvatar(String uid) async {
    if (imageLoading) return;

    setState(() => imageLoading = true);

    try {
      final path = await localDataSource.pickAndSaveImage(uid);

      if (!mounted) return;

      if (path != null) {
        setState(() => imagePath = path);
        _showMessage('Profile picture saved successfully');
      }
    } catch (e) {
      debugPrint('Unable to select profile picture: $e');

      if (mounted) {
        _showMessage('Unable to select profile picture');
      }
    } finally {
      if (mounted) {
        setState(() => imageLoading = false);
      }
    }
  }

  Future<void> _changeNotifications(bool value) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _showMessage('Please log in to change notification settings.');
      return;
    }

    final oldValue = notification;

    setState(() => notification = value);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('settings')
          .doc('preferences')
          .set({
        'notificationsEnabled': value,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (value) {
        await FirebaseMessaging.instance
            .subscribeToTopic('finwise_notifications');
      } else {
        await FirebaseMessaging.instance
            .unsubscribeFromTopic('finwise_notifications');
      }
    } catch (e) {
      debugPrint('Unable to update notifications: $e');

      if (!mounted) return;

      setState(() => notification = oldValue);
      _showMessage('Unable to update notification settings');
    }
  }

  Future<void> _changeTheme(bool value) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _showMessage('Please log in to save theme settings.');
      return;
    }

    final previousValue = darkTheme;

    setState(() => darkTheme = value);
    AppTheme.setDarkMode(value);

    try {
      await AppPreferences.saveDarkMode(user.uid, value);
    } catch (e) {
      debugPrint('Unable to save theme settings: $e');

      if (!mounted) return;

      setState(() => darkTheme = previousValue);
      AppTheme.setDarkMode(previousValue);

      _showMessage('Unable to save theme settings.');
    }
  }

  void _saveProfile() {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();

    if (name.isEmpty) {
      _showMessage('Please enter your name.');
      return;
    }

    if (email.isEmpty ||
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      _showMessage('Please enter a valid email address.');
      return;
    }

    context.read<ProfileBloc>().add(
      UpdateProfile(
        name: name,
        email: email,
        phone: phone,
      ),
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
        Theme.of(context).colorScheme.inverseSurface,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) =>
      previous.profile != current.profile ||
          previous.message != current.message ||
          previous.error != current.error,
      listener: (context, state) {
        if (state.profile != null) {
          _loadFields(state.profile!);
        }

        if (state.message != null && state.message!.isNotEmpty) {
          _showMessage(state.message!);

          if (state.message!.contains('successfully')) {
            Navigator.pop(context, true);
          }
        }

        if (state.error != null && state.error!.isNotEmpty) {
          _showMessage(state.error!);
        }
      },
      builder: (context, state) {
        final profile = state.profile;

        if (profile != null) {
          _loadFields(profile);
        }

        final user = FirebaseAuth.instance.currentUser;

        final displayName = nameController.text.isNotEmpty
            ? nameController.text
            : (user?.email?.split('@').first ?? 'Your Name');

        return Scaffold(
          backgroundColor: _backgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                _header(context),
                Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: _surfaceColor,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(45),
                            ),
                          ),
                          child: state.isLoading
                              ? Center(
                            child: CircularProgressIndicator(
                              color: _primaryGreen,
                            ),
                          )
                              : profile == null
                              ? _retry(context)
                              : _form(
                            context,
                            state,
                            profile,
                            displayName,
                          ),
                        ),
                      ),
                      if (profile != null)
                        Positioned(
                          top: -(_avatarSize / 2),
                          left: 0,
                          right: 0,
                          child: Center(
                            child: _avatar(context, profile.uid),
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

  Widget _header(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final headerTextColor =
    isDark ? AppColors.darkText : AppColors.white;

    return Container(
      width: double.infinity,
      color: isDark ? AppColors.darkBackground : AppColors.primaryGreen,
      child: SizedBox(
        height: 140,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: headerTextColor,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Edit My Profile',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkText : Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                width: 36,
                height: 36,
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
                    color: isDark
                        ? AppColors.darkText
                        : AppColors.darkGreen,
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

  Widget _avatar(BuildContext context, String uid) {
    final hasImage =
        imagePath != null && File(imagePath!).existsSync();
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _changeAvatar(uid),
      child: SizedBox(
        width: _avatarSize,
        height: _avatarSize,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipOval(
              child: SizedBox(
                width: _avatarSize,
                height: _avatarSize,
                child: Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: imageLoading
                      ? Center(
                    child: CircularProgressIndicator(
                      color: _primaryGreen,
                    ),
                  )
                      : hasImage
                      ? Image.file(
                    File(imagePath!),
                    width: _avatarSize,
                    height: _avatarSize,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.person,
                      size: 50,
                      color: _textColor,
                    ),
                  )
                      : Icon(
                    Icons.person,
                    size: 50,
                    color: _textColor,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 2,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _primaryGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 12,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _retry(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Unable to load profile',
            style: GoogleFonts.poppins(color: _textColor),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              context.read<ProfileBloc>().add(const LoadProfile());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _form(
      BuildContext context,
      ProfileState state,
      UserProfile profile,
      String displayName,
      ) {
    final shortId = profile.uid.length > 8
        ? profile.uid.substring(0, 8)
        : profile.uid;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        28,
        _avatarSize / 2 + 12,
        28,
        30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  displayName,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _textColor,
                  ),
                ),
                Text(
                  'ID: $shortId',
                  style: GoogleFonts.poppins(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: _textColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Account Settings',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 16),
          _label('Username'),
          _input(nameController, 'Enter your name'),
          const SizedBox(height: 14),
          _label('Phone'),
          _input(
            phoneController,
            'Enter your phone number',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 14),
          _label('Email Address'),
          _input(
            emailController,
            'Enter your email address',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),
          _switchRow(
            'Push Notifications',
            notification,
            settingsLoading ? null : _changeNotifications,
          ),
          _switchRow(
            'Turn Dark Theme',
            darkTheme,
            settingsLoading ? null : _changeTheme,
          ),
          const SizedBox(height: 14),
          Center(
            child: SizedBox(
              width: 150,
              height: 38,
              child: ElevatedButton(
                onPressed: state.isSaving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: state.isSaving
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
                    : Text(
                  'Update Profile',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: _textColor,
        ),
      ),
    );
  }

  // Smaller text field: height 42 -> 34. isDense + zero contentPadding
  // keeps the text vertically centered inside the shorter box.
  Widget _input(
      TextEditingController controller,
      String hint, {
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Container(
      height: 34,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: _fieldColor,
        borderRadius: BorderRadius.circular(10),
        border: _isDark
            ? Border.all(color: AppColors.darkDivider)
            : null,
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(
          fontSize: 10.5,
          color: _textColor,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            fontSize: 10,
            color: _secondaryTextColor.withValues(alpha: 0.7),
          ),
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _switchRow(
      String text,
      bool value,
      ValueChanged<bool>? onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: _textColor,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeThumbColor: AppColors.white,
            activeTrackColor: _primaryGreen,
            inactiveThumbColor: AppColors.white,
            inactiveTrackColor: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.25),
            trackOutlineColor:
            const WidgetStatePropertyAll<Color>(
              Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}