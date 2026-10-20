
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/prefrences/app_prefrences.dart';

class ProfileLocalDataSource {
  final ImagePicker imagePicker;

  ProfileLocalDataSource({ImagePicker? imagePicker})
      : imagePicker = imagePicker ?? ImagePicker();

  /// Get the saved profile image path.
  Future<String?> getImagePath(String uid) async {
    try {
      final path = await AppPreferences.getProfileImagePath(uid);

      if (path == null || path.isEmpty) {
        return null;
      }

      final imageFile = File(path);

      if (!await imageFile.exists()) {
        await AppPreferences.removeProfileImagePath(uid);
        return null;
      }

      return path;
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  /// Pick an image, save it locally, and store its path.
  Future<String?> pickAndSaveImage(String uid) async {
    try {
      final selectedImage = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
      );

      // User cancelled image selection.
      if (selectedImage == null) {
        return null;
      }

      final directory = await getApplicationDocumentsDirectory();

      final profileDirectory = Directory(
        '${directory.path}/profile_images',
      );

      if (!await profileDirectory.exists()) {
        await profileDirectory.create(recursive: true);
      }

      final extension = selectedImage.path.contains('.')
          ? selectedImage.path.split('.').last.toLowerCase()
          : 'jpg';

      final destination =
          '${profileDirectory.path}/profile_$uid.$extension';

      final sourceFile = File(selectedImage.path);
      final savedImage = await sourceFile.copy(destination);

      // Save the image path using AppPreferences.
      await AppPreferences.saveProfileImagePath(
        uid: uid,
        imagePath: savedImage.path,
      );

      return savedImage.path;
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  /// Delete the local profile image and its saved path.
  Future<void> removeProfileImage(String uid) async {
    final path = await AppPreferences.getProfileImagePath(uid);

    if (path != null && path.isNotEmpty) {
      final file = File(path);

      if (await file.exists()) {
        await file.delete();
      }
    }

    await AppPreferences.removeProfileImagePath(uid);
  }
}
