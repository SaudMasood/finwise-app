

import '../../entities/profile/profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getProfile();
  Future<void> saveProfile(UserProfile profile);
  Future<String?> pickAndSaveImage();
}
