import 'package:dio/dio.dart';
import '../constants/api_endpoints.dart';
import '../errors/exceptions.dart';
import '../services/storage_service.dart';

class DioClient {
  final Dio _dio;
  final StorageService _storageService;

  DioClient({
    Dio? dio,
    StorageService? storageService,
  })  : _storageService = storageService ?? StorageService(),
        _dio = dio ??
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
    _dio.interceptors.add(_authInterceptor());
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
    ));
  }

  /// Auth interceptor - adds token to requests
  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Get token from storage
        final token = await _storageService.getAccessToken();

        // Add token to header if exists
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
      },
      onError: (error, handler) async {
        // Handle 401 Unauthorized (token expired)
        if (error.response?.statusCode == 401) {
          // TODO: Implement token refresh logic here
          // For now, just clear tokens and let user login again
          await _storageService.clearTokens();
        }

        return handler.next(error);
      },
    );
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
      return const NetworkException("Connection timed out. Please check your internet.");
    } else if (error.response != null) {
      // Try to parse API error response
      try {
        final responseData = error.response?.data;
        if (responseData is Map<String, dynamic> && responseData['error'] != null) {
          return ApiResponseException.fromJson(responseData);
        }
      } catch (_) {
        // Fall through to default handling
      }

      // Default HTTP status code handling
      switch (error.response?.statusCode) {
        case 400:
        case 422:
          return ValidationException(
            error.response?.data?['error']?['message'] ?? "Validation error",
          );
        case 401:
        case 403:
          return UnauthorizedException(
            error.response?.data?['error']?['message'] ?? "Unauthorized access",
          );
        case 404:
          return const NotFoundException("Resource not found");
        case 500:
        default:
          return ServerException(
            "Server error: ${error.response?.statusCode}",
          );
      }
    } else {
      return UnknownException(
        error.message ?? 'No internet connection. Please check your network.',
      );
    }
  }
}