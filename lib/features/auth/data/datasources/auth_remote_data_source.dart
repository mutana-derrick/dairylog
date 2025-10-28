import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../../../../core/constants/api_endpoints.dart';

abstract class AuthRemoteDataSource {
  /// Logs in the user with email/phone and password.
  Future<UserModel> login({required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> login({required String email, required String password}) async {
    try {
      final response = await dio.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw Exception('Login failed with status: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('Login error: ${e.message}');
    }
  }
}
