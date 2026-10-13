
import '../../../domain/repositories/password/password.dart';
import '../../datasources/password_datasorce.dart';

class PasswordRepositoryImpl implements PasswordRepository {
  final PasswordRemoteDataSource remoteDataSource;

  PasswordRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return remoteDataSource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}