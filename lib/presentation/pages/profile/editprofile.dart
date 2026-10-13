import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
  static const Color mainGreen = Color(0xFF00D09E);
  static const Color lightGreen = Color(0xFFF1FFF3);
  static const Color softGreen = Color(0xFFDDF5E2);
  static const Color darkGreen = Color(0xFF063F3F);

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
      if (mounted) setState(() => settingsLoading = false);
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
      final settings = results[1] as DocumentSnapshot<Map<String, dynamic>>;
      final notifications =
          settings.data()?['notificationsEnabled'] as bool? ?? true;

      if (!mounted) return;

      setState(() {
        darkTheme = dark;
        notification = notifications;
        settingsLoading = false;
      });

      AppTheme.setDarkMode(dark);
    } catch (_) {
      if (mounted) setState(() => settingsLoading = false);
    }
  }

  Future<void> _loadAvatar() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final path = await localDataSource.getImagePath(user.uid);
      if (!mounted) return;
      setState(() => imagePath = path);
    } catch (_) {
      if (mounted) setState(() => imagePath = null);
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
    } catch (_) {
      if (mounted) _showMessage('Unable to select profile picture');
    } finally {
      if (mounted) setState(() => imageLoading = false);
    }
  }

  Future<void> _changeNotifications(bool value) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final oldValue = notification;
    setState(() => notification = value);

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
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
    } catch (_) {
      if (!mounted) return;
      setState(() => notification = oldValue);
      _showMessage('Unable to update notification settings');
    }
  }

  Future<void> _changeTheme(bool value) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final oldValue = darkTheme;

    setState(() => darkTheme = value);
    AppTheme.setDarkMode(value);

    try {
      await AppPreferences.saveDarkMode(user.uid, value);
    } catch (_) {
      if (!mounted) return;
      setState(() => darkTheme = oldValue);
      AppTheme.setDarkMode(oldValue);
      _showMessage('Unable to save theme settings');
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
      UpdateProfile(name: name, email: email, phone: phone),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
        if (state.profile != null) _loadFields(state.profile!);

        if (state.message != null && state.message!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message!), backgroundColor: darkGreen),
          );

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
        if (profile != null) _loadFields(profile);

        final user = FirebaseAuth.instance.currentUser;

        final displayName = nameController.text.isNotEmpty
            ? nameController.text
            : (user?.email?.split('@').first ?? 'Your Name');

        return Scaffold(
          backgroundColor: mainGreen,
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
                          decoration: const BoxDecoration(
                            color: lightGreen,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(45),
                            ),
                          ),
                          child: state.isLoading
                              ? const Center(
                            child: CircularProgressIndicator(
                              color: mainGreen,
                            ),
                          )
                              : profile == null
                              ? _retry(context)
                              : _form(context, state, profile, displayName),
                        ),
                      ),
                      if (profile != null)
                        Positioned(
                          top: -(_avatarSize / 2),
                          left: 0,
                          right: 0,
                          child: Center(child: _avatar(profile.uid)),
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
    return SizedBox(
      height: 125,
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
                    'Edit My Profile',
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

  Widget _avatar(String uid) {
    final hasImage = imagePath != null && File(imagePath!).existsSync();

    return GestureDetector(
      onTap: () => _changeAvatar(uid),
      child: SizedBox(
        width: _avatarSize,
        height: _avatarSize,
        child: Stack(
          children: [
            Container(
              width: _avatarSize,
              height: _avatarSize,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: softGreen,
                border: Border.all(color: lightGreen, width: 3),
              ),
              child: imageLoading
                  ? const Center(
                child: CircularProgressIndicator(color: mainGreen),
              )
                  : hasImage
                  ? Image.file(
                File(imagePath!),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.person,
                  size: 50,
                  color: darkGreen,
                ),
              )
                  : const Icon(Icons.person, size: 50, color: darkGreen),
            ),
            Positioned(
              right: 0,
              bottom: 2,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: mainGreen,
                  shape: BoxShape.circle,
                  border: Border.all(color: lightGreen, width: 2),
                ),
                child: const Icon(Icons.camera_alt, size: 12, color: darkGreen),
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
          const Text('Unable to load profile'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () =>
                context.read<ProfileBloc>().add(const LoadProfile()),
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
    final shortId =
    profile.uid.length > 8 ? profile.uid.substring(0, 8) : profile.uid;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, _avatarSize / 2 + 12, 28, 30),
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
                    color: darkGreen,
                  ),
                ),
                Text(
                  'ID: $shortId',
                  style: GoogleFonts.poppins(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: darkGreen,
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
              color: darkGreen,
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
              width: 130,
              height: 34,
              child: ElevatedButton(
                onPressed: state.isSaving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainGreen,
                  foregroundColor: darkGreen,
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
                  child: CircularProgressIndicator(strokeWidth: 2),
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
          color: darkGreen,
        ),
      ),
    );
  }

  Widget _input(
      TextEditingController controller,
      String hint, {
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: softGreen.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(fontSize: 10.5, color: darkGreen),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            fontSize: 10,
            color: darkGreen.withValues(alpha: 0.6),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _switchRow(String text, bool value, ValueChanged<bool>? onChanged) {
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
              color: darkGreen,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            thumbColor: const WidgetStatePropertyAll(Colors.white),
            trackColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                  ? mainGreen
                  : const Color(0xFF8EE5CC),
            ),
            trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
          ),
        ],
      ),
    );
  }
}