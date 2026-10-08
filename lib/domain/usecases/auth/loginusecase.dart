import '../../entities/auth/user.dart';
import '../../repositories/auth/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({
    required this.repository,
  });

  Future<UserEntity> call({
    required String email,
    required String password,
  }) {
    return repository.login(
      email: email,
      password: password,
    );
  }

  Future<UserEntity> loginWithGoogle() {
    return repository.loginWithGoogle();
  }

  Future<UserEntity> loginWithFacebook() {
    return repository.loginWithFacebook();
  }
}