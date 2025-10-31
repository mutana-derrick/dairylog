import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/services/storage_service.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> deleteUser();
  Future<bool> isLoggedIn();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final StorageService _storageService;
  static const String _userBoxName = 'userBox';

  AuthLocalDataSourceImpl({required StorageService storageService})
      : _storageService = storageService;

  @override
  Future<void> saveUser(UserModel user) async {
    final box = await Hive.openBox<UserModel>(_userBoxName);
    await box.put('currentUser', user);

    // Save user ID to secure storage
    await _storageService.saveUserId(user.id);
  }

  @override
  Future<UserModel?> getUser() async {
    final box = await Hive.openBox<UserModel>(_userBoxName);
    return box.get('currentUser');
  }

  @override
  Future<void> deleteUser() async {
    final box = await Hive.openBox<UserModel>(_userBoxName);
    await box.delete('currentUser');
    await _storageService.clearTokens();
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _storageService.isLoggedIn();
  }
}