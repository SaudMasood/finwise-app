

import '../../../data/repositories/profile/profile_repository_impl.dart';
import '../../entities/profile/profile.dart';
import '../../repositories/profile/profile_repository.dart';

class GetProfile {
  final ProfileRepository repository;

  GetProfile(this.repository);

  Future<UserProfile> call() {
    return repository.getProfile();
  }
}

class SaveProfile {
  final ProfileRepository repository;

  SaveProfile(this.repository);

  Future<void> call(UserProfile profile) {
    return repository.saveProfile(profile);
  }
}

class PickProfileImage {
  final ProfileRepository repository;

  PickProfileImage(this.repository);

  Future<String?> call() {
    return repository.pickAndSaveImage();
  }
}
