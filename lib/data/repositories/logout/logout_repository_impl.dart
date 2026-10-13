
import '../../../domain/repositories/logout/logout_repository.dart';
import '../../datasources/logout_remote_datasorce.dart';

class LogoutRepositoryImpl implements LogoutRepository {
  final LogoutRemoteDataSource dataSource;

  LogoutRepositoryImpl(this.dataSource);

  @override
  Future<void> logout() async {
    await dataSource.logout();
  }
}