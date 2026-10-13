
class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String? imagePath;

  const UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    this.imagePath,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? imagePath,
  }) {
    return UserProfile(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
