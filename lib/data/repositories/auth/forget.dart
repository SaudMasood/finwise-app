import '../../../domain/repositories/auth/forget.dart';
import '../../datasources/forgetpassdatas.dart';

class ForgotPasswordRepositoryImpl
    implements ForgotPasswordRepository {
  final ForgotPasswordDataSource dataSource;

  ForgotPasswordRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<void> sendPasswordResetEmail({
    required String email,
  }) {
    return dataSource.sendPasswordResetEmail(
      email: email,
    );
  }
}