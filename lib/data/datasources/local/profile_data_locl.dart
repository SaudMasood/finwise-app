
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ProfileLocalDataSource {
  final ImagePicker imagePicker;

  ProfileLocalDataSource({ImagePicker? imagePicker})
      : imagePicker = imagePicker ?? ImagePicker();

  // Pick an imag
  // Return its temporary path for Cloudinary upload.
  Future<String?> pickImage() async {
    try {
      final selectedImage = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (selectedImage == null) {
        return null;
      }

      return selectedImage.path;
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }
}
