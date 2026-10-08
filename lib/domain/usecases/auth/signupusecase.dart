import '../../entities/auth/user.dart';
import '../../repositories/auth/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase({
    required this.repository,
  });

  Future<UserEntity> call({
    required String email,
    required String password,
  }) {
    return repository.signup(
      email: email,
      password: password,
    );
  }
}