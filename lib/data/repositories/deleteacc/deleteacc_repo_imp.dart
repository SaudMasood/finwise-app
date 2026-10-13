
import '../../../domain/repositories/deleteaccount/deleteaccount_repo.dart';
import '../../datasources/deleteaccount.dart';

class DeleteAccountRepositoryImpl
    implements DeleteAccountRepository {
  final DeleteAccountRemoteDataSource remoteDataSource;

  DeleteAccountRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<void> deleteAccount({
    required String password,
  }) {
    return remoteDataSource.deleteAccount(
      password: password,
    );
  }
}