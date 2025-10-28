import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A wrapper around FlutterSecureStorage for easy key-value storage.
///
/// Usage:
/// ```dart
/// await StorageService().write(key: 'token', value: 'abc123');
/// String? token = await StorageService().read('token');
/// await StorageService().delete('token');
/// ```
class StorageService {
  final FlutterSecureStorage _storage;

  StorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Write a value to secure storage
  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  /// Read a value from secure storage
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Delete a value from secure storage
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Delete all values from secure storage
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  /// Check if a key exists
  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }
}
