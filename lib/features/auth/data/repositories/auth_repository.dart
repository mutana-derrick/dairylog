import '../../data/datasources/auth_local_data_source.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login({required String email, required String password});
  UserModel? getCachedUser();
  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserModel> login({required String email, required String password}) async {
    final user = await remoteDataSource.login(email: email, password: password);
    await localDataSource.cacheUser(user);
    return user;
  }

  @override
  UserModel? getCachedUser() => localDataSource.getCachedUser();

  @override
  Future<void> logout() async => await localDataSource.clearUser();
}
