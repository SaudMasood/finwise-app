
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileLocalDataSource {
  final ImagePicker imagePicker;

  ProfileLocalDataSource({ImagePicker? imagePicker})
      : imagePicker = imagePicker ?? ImagePicker();

  Future<String?> getImagePath(String uid) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final path = preferences.getString('profile_image_$uid');

      if (path == null || path.isEmpty) {
        return null;
      }

      final imageFile = File(path);

      if (!await imageFile.exists()) {
        await preferences.remove('profile_image_$uid');
        return null;
      }

      return path;
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  Future<String?> pickAndSaveImage(String uid) async {
    final selectedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 800,
    );

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

    try {
      final preferences = await SharedPreferences.getInstance();

      await preferences.setString(
        'profile_image_$uid',
        savedImage.path,
      );
    } on PlatformException {
      return savedImage.path;
    } on MissingPluginException {
      return savedImage.path;
    }

    return savedImage.path;
  }
}
