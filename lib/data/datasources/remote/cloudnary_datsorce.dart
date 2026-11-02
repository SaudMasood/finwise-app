
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../core/config/cloudinary_config.dart';


class CloudinaryDataSource {
  Future<String> uploadProfileImage(File imageFile) async {
    final uri = Uri.parse(CloudinaryConfig.uploadUrl);

    final request = http.MultipartRequest('POST', uri);

    request.fields['upload_preset'] =
        CloudinaryConfig.uploadPreset;

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      ),
    );

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    final data = jsonDecode(responseBody);

    if (response.statusCode == 200) {
      return data['secure_url'] as String;
    }

    throw Exception(
      data['error']?['message'] ?? 'Cloudinary upload failed',
    );
  }
}
