import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage _storage;

  // Storage keys
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id';

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

  // ===== TOKEN MANAGEMENT =====

  /// Save access and refresh tokens
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await write(key: _keyAccessToken, value: accessToken);
    await write(key: _keyRefreshToken, value: refreshToken);
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    return await read(_keyAccessToken);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await read(_keyRefreshToken);
  }

  /// Save user ID
  Future<void> saveUserId(String userId) async {
    await write(key: _keyUserId, value: userId);
  }

  /// Get user ID
  Future<String?> getUserId() async {
    return await read(_keyUserId);
  }

  /// Clear all tokens (logout)
  Future<void> clearTokens() async {
    await delete(_keyAccessToken);
    await delete(_keyRefreshToken);
    await delete(_keyUserId);
  }

  /// Check if user is logged in (has access token)
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
