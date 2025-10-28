import 'package:dio/dio.dart';
import '../constants/api_endpoints.dart';
import '../errors/exceptions.dart';

/// Centralized Dio API client
///
/// Handles network requests, default headers, timeouts, and error parsing.
class DioClient {
  final Dio _dio;

  DioClient({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiEndpoints.baseUrl,
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ) {
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
    ));
  }

  /// GET request
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST request
  Future<Response> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PUT request
  Future<Response> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// DELETE request
  Future<Response> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Converts DioError to custom exceptions
  Exception _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const NetworkException("Connection timed out");
    } else if (error.response != null) {
      switch (error.response?.statusCode) {
        case 400:
        case 422:
          return ValidationException(error.response?.data.toString() ?? "Validation error");
        case 401:
        case 403:
          return const UnauthorizedException("Unauthorized access");
        case 404:
          return const NotFoundException("Resource not found");
        case 500:
        default:
          return ServerException("Server error: ${error.response?.statusCode}");
      }
    } else {
      return UnknownException(error.message ?? 'Unknown error');
    }
  }
}
