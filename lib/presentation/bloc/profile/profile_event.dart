
import 'package:flutter/foundation.dart';

@immutable
abstract class ProfileEvent {
  const ProfileEvent();
}

class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

class UpdateProfile extends ProfileEvent {
  final String name;
  final String email;
  final String phone;

  const UpdateProfile({
    required this.name,
    required this.email,
    required this.phone,
  });
}

class ChangeProfileImage extends ProfileEvent {
  const ChangeProfileImage();
}
