import '../../entities/auth/user.dart';

abstract class AuthRepository {
  Future<UserEntity> login({
    required String email,
    required String password,
  });

  Future<UserEntity> signup({
    required String email,
    required String password,
  });

  Future<UserEntity> loginWithGoogle();

  Future<UserEntity> loginWithFacebook();
}