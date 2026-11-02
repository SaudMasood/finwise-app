
import 'dart:io';

import '../../../domain/entities/profile/profile.dart';
import '../../../domain/repositories/profile/profile_repository.dart';
import '../../datasources/local/profile_data_locl.dart';
import '../../datasources/remote/cloudnary_datsorce.dart';
import '../../datasources/remote/profile_datas.dart';
import '../../models/profile/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;
  final CloudinaryDataSource cloudinaryDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.cloudinaryDataSource,
  });

  @override
  Future<UserProfile> getProfile() async {
    final profile = await remoteDataSource.getProfile();

    // Retrieve the Cloudinary URL from Firestore.
    final imageUrl = await remoteDataSource.getProfileImageUrl();

    return UserProfile(
      uid: profile.uid,
      name: profile.name,
      email: profile.email,
      phone: profile.phone,
      imagePath: imageUrl,
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
    // Step 1: Pick image from gallery.
    final imagePath = await localDataSource.pickImage();

    if (imagePath == null) {
      return null;
    }

    // Step 2: Upload image to Cloudinary.
    final imageUrl = await cloudinaryDataSource.uploadProfileImage(
      File(imagePath),
    );

    // Step 3: Save Cloudinary URL in Firestore.
    await remoteDataSource.saveProfileImageUrl(imageUrl);

    // Step 4: Return URL to BLoC.
    return imageUrl;
  }
}
