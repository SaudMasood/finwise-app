

import '../../../domain/repositories/profile/security_repo.dart';
import '../../datasources/remote/security_remote_data.dart';

class SecurityRepositoryImpl implements SecurityRepository {
  final SecurityRemoteDataSource dataSource;

  SecurityRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<bool> hasPin() {
    return dataSource.hasPin();
  }

  @override
  Future<void> changePin({
    required String currentPin,
    required String newPin,
  }) {
    return dataSource.changePin(
      currentPin: currentPin,
      newPin: newPin,
    );
  }
}
