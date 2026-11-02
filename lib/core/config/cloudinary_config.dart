
class CloudinaryConfig {
  // Your Cloudinary Cloud Name
  static const String cloudName = 'i534rxdw';

  // Your Cloudinary Unsigned Upload Preset
  static const String uploadPreset = 'finwise_profile';

  // Cloudinary Image Upload API URL
  static String get uploadUrl =>
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
}
