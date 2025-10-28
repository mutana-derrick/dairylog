import '../../data/datasources/auth_local_data_source.dart';
import '../models/user_model.dart';

abstract class AuthLocalRepository {
  UserModel? getUser();
  Future<void> saveUser(UserModel user);
  Future<void> clearUser();
}

class AuthLocalRepositoryImpl implements AuthLocalRepository {
  final AuthLocalDataSource localDataSource;

  AuthLocalRepositoryImpl({required this.localDataSource});

  @override
  UserModel? getUser() => localDataSource.getCachedUser();

  @override
  Future<void> saveUser(UserModel user) => localDataSource.cacheUser(user);

  @override
  Future<void> clearUser() => localDataSource.clearUser();
}
