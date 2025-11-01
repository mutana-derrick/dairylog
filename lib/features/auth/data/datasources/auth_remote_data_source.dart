import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/logout_models.dart';
import '../models/refresh_token_models.dart';
import '../models/user_profile_models.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);
  Future<LogoutResponse> logout(String refreshToken);
  Future<RefreshTokenResponse> refreshToken(String refreshToken, int userId);
  Future<UserProfileResponse> getUserProfile();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _dioClient.post(
      ApiEndpoints.login,
      data: request.toJson(),
    );
    return LoginResponse.fromJson(response.data);
  }

  @override
  Future<LogoutResponse> logout(String refreshToken) async {
    final request = LogoutRequest(refreshToken: refreshToken);
    final response = await _dioClient.post(
      ApiEndpoints.logout,
      data: request.toJson(),
    );
    return LogoutResponse.fromJson(response.data);
  }

  @override
  Future<RefreshTokenResponse> refreshToken(
      String refreshToken, int userId) async {
    final request = RefreshTokenRequest(
      refreshToken: refreshToken,
      userId: userId,
    );
    final response = await _dioClient.post(
      ApiEndpoints.refreshToken,
      data: request.toJson(),
    );
    return RefreshTokenResponse.fromJson(response.data);
  }

  @override
  Future<UserProfileResponse> getUserProfile() async {
    final response = await _dioClient.get(ApiEndpoints.userProfile);
    return UserProfileResponse.fromJson(response.data);
  }
}
