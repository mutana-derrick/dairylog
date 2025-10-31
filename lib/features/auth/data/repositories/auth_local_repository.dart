import '../datasources/auth_local_data_source.dart';
import '../models/user_model.dart';

abstract class AuthLocalRepository {
  Future<UserModel?> getUser();
  Future<void> saveUser(UserModel user);
  Future<void> clearUser();
  Future<bool> isLoggedIn();
}

class AuthLocalRepositoryImpl implements AuthLocalRepository {
  final AuthLocalDataSource localDataSource;

  AuthLocalRepositoryImpl({required this.localDataSource});

  @override
  Future<UserModel?> getUser() async {
    return await localDataSource.getUser();
  }

  @override
  Future<void> saveUser(UserModel user) async {
    return await localDataSource.saveUser(user);
  }

  @override
  Future<void> clearUser() async {
    return await localDataSource.deleteUser();
  }

  @override
  Future<bool> isLoggedIn() async {
    return await localDataSource.isLoggedIn();
  }
}