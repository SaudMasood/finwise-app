import '../../../domain/entities/auth/user.dart';
import '../../../domain/repositories/auth/auth_repository.dart';
import '../../datasources/facebooklogind.dart';
import '../../datasources/goglelogindatas.dart';
import '../../datasources/logindatasource.dart';
import '../../datasources/signupdatasorce.dart';
import '../../models/auth/usermodel.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LoginDataSource loginDataSource;
  final SignupDataSource? signupDataSource;
  final GoogleLoginDataSource? googleLoginDataSource;
  final FacebookLoginDataSource? facebookLoginDataSource;

  AuthRepositoryImpl({
    required this.loginDataSource,
    this.signupDataSource,
    this.googleLoginDataSource,
    this.facebookLoginDataSource,
  });

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final result = await loginDataSource.login(
      email: email,
      password: password,
    );

    final user = result.user;

    if (user == null) {
      throw Exception('Login failed');
    }

    return UserModel.fromFirebase(user);
  }

  @override
  Future<UserEntity> signup({
    required String email,
    required String password,
  }) async {
    if (signupDataSource == null) {
      throw Exception(
        'Signup data source is not available',
      );
    }

    final result = await signupDataSource!.signup(
      email: email,
      password: password,
    );

    final user = result.user;

    if (user == null) {
      throw Exception('Signup failed');
    }

    return UserModel.fromFirebase(user);
  }

  @override
  Future<UserEntity> loginWithGoogle() async {
    if (googleLoginDataSource == null) {
      throw Exception(
        'Google login data source is not available',
      );
    }

    final result =
    await googleLoginDataSource!.loginWithGoogle();

    final user = result.user;

    if (user == null) {
      throw Exception('Google login failed');
    }

    return UserModel.fromFirebase(user);
  }

  @override
  Future<UserEntity> loginWithFacebook() async {
    if (facebookLoginDataSource == null) {
      throw Exception(
        'Facebook login data source is not available',
      );
    }

    final result =
    await facebookLoginDataSource!.loginWithFacebook();

    final user = result.user;

    if (user == null) {
      throw Exception('Facebook login failed');
    }

    return UserModel.fromFirebase(user);
  }
}