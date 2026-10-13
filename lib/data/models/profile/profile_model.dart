

import '../../../domain/entities/profile/profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.phone,
    super.imagePath,
  });

  factory UserProfileModel.fromEntity(UserProfile profile) {
    return UserProfileModel(
      uid: profile.uid,
      name: profile.name,
      email: profile.email,
      phone: profile.phone,
      imagePath: profile.imagePath,
    );
  }
}
