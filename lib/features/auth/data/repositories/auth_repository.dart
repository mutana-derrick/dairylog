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
    // Call API
    final request = LoginRequest(username: username, password: password);
    final response = await _remoteDataSource.login(request);

    // Check if login was successful
    if (!response.success || response.data == null) {
      throw Exception(response.message);
    }

    // Save tokens to secure storage
    await _storageService.saveTokens(
      accessToken: response.data!.token.accessToken,
      refreshToken: response.data!.token.refreshToken,
    );

    // TODO: Fetch user profile from API using the token
    // For now, create a placeholder user
    // You'll need to call GET /profile or similar endpoint
    final user = UserModel(
      id: 'temp_id', // Replace with actual user ID from profile API
      name: username, // Replace with actual name from profile API
      email: '$username@example.com', // Replace with actual email
      phone: '', // Replace with actual phone
      accessToken: response.data!.token.accessToken,
      refreshToken: response.data!.token.refreshToken,
    );

    // Save user to local database
    await _localDataSource.saveUser(user);

    return user;
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await _remoteDataSource.logout();
    } finally {
      // Always clear local data, even if API call fails
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
}