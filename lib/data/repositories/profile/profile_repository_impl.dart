
import '../../../domain/entities/profile/profile.dart';
import '../../../domain/repositories/profile/profile_repository.dart';
import '../../datasources/local/profile_data_locl.dart';
import '../../datasources/remote/profile_datas.dart';
import '../../models/profile/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserProfile> getProfile() async {
    final profile = await remoteDataSource.getProfile();
    final imagePath = await localDataSource.getImagePath(profile.uid);

    return UserProfile(
      uid: profile.uid,
      name: profile.name,
      email: profile.email,
      phone: profile.phone,
      imagePath: imagePath,
    );
  }

  @override
  Future<void> saveProfile(UserProfile profile) {
    return remoteDataSource.saveProfile(
      UserProfileModel.fromEntity(profile),
    );
  }

  @override
  Future<String?> pickAndSaveImage() async {
    final profile = await remoteDataSource.getProfile();
    return localDataSource.pickAndSaveImage(profile.uid);
  }
}
