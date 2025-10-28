import 'package:hive/hive.dart';
import '../models/user_model.dart';


abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  UserModel? getCachedUser();
  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box<UserModel> userBox;

  AuthLocalDataSourceImpl({required this.userBox});

  @override
  Future<void> cacheUser(UserModel user) async {
    await userBox.put(user.id, user);
  }

  @override
  UserModel? getCachedUser() {
    if (userBox.isEmpty) return null;
    return userBox.values.first;
  }

  @override
  Future<void> clearUser() async {
    await userBox.clear();
  }
}
