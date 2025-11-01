import '../../../../core/services/storage_service.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_local_data_source.dart';
import '../models/login_request.dart';
import '../models/user_model.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final StorageService _storageService;

  AuthRepository({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required StorageService storageService,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _storageService = storageService;

  /// Login user
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    // Call login API
    final request = LoginRequest(username: username, password: password);
    final response = await _remoteDataSource.login(request);

    if (!response.success || response.data == null) {
      throw Exception(response.message);
    }

    // Save tokens
    await _storageService.saveTokens(
      accessToken: response.data!.token.accessToken,
      refreshToken: response.data!.token.refreshToken,
    );

    // Fetch user profile
    final profileResponse = await _remoteDataSource.getUserProfile();

    if (!profileResponse.success || profileResponse.data == null) {
      throw Exception('Failed to fetch user profile');
    }

    // Combine profile data with tokens
    final user = profileResponse.data!.copyWithTokens(
      accessToken: response.data!.token.accessToken,
      refreshToken: response.data!.token.refreshToken,
    );

    // Save user ID and user data
    await _storageService.saveUserId(user.id);
    await _localDataSource.saveUser(user);

    return user;
  }

  /// Logout user
  Future<void> logout() async {
    try {
      final refreshToken = await _storageService.getRefreshToken();

      if (refreshToken != null && refreshToken.isNotEmpty) {
        // ✅ Just call logout with refreshToken
        // The API doesn't require userId in the request body
        await _remoteDataSource.logout(refreshToken);
      }
    } catch (e) {
      // Continue with local cleanup even if API fails
      print('Logout API failed: $e');
    } finally {
      // ✅ Clear all local data
      await _storageService.clearTokens();
      await _storageService.deleteUserId(); // ✅ Add this method
      await _localDataSource.deleteUser();
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await _localDataSource.isLoggedIn();
  }

  /// Get current user
  Future<UserModel?> getCurrentUser() async {
    return await _localDataSource.getUser();
  }

  /// Refresh tokens
  Future<void> refreshTokens() async {
    final refreshToken = await _storageService.getRefreshToken();
    final userId = await _storageService.getUserId();

    if (refreshToken == null || userId == null) {
      throw Exception('Missing refresh token or user ID');
    }

    // ✅ Call refresh API with both refreshToken and userId
    final response = await _remoteDataSource.refreshToken(refreshToken, userId);

    if (!response.success || response.data == null) {
      throw Exception('Failed to refresh tokens');
    }

    // Save new tokens
    await _storageService.saveTokens(
      accessToken: response.data!.token.accessToken,
      refreshToken: response.data!.token.refreshToken,
    );
  }
}