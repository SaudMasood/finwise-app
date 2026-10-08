import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/entities/auth/user.dart';


class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
  });

  factory UserModel.fromFirebase(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
    );
  }
}