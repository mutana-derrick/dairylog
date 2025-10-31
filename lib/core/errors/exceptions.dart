/// Base exception class
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException(String message) : super(message, 0);
}

/// Server error (5xx)
class ServerException extends AppException {
  const ServerException(String message) : super(message, 500);
}

/// Unauthorized (401, 403)
class UnauthorizedException extends AppException {
  const UnauthorizedException(String message) : super(message, 401);
}

/// Not found (404)
class NotFoundException extends AppException {
  const NotFoundException(String message) : super(message, 404);
}

/// Validation error (400, 422)
class ValidationException extends AppException {
  const ValidationException(String message) : super(message, 400);
}

/// Unknown error
class UnknownException extends AppException {
  const UnknownException(super.message);
}

/// API Response wrapper exception
class ApiResponseException extends AppException {
  final String code;
  final dynamic details;

  const ApiResponseException({
    required this.code,
    required String message,
    int? statusCode,
    this.details,
  }) : super(message, statusCode);

  factory ApiResponseException.fromJson(Map<String, dynamic> json) {
    final error = json['error'] as Map<String, dynamic>?;
    
    return ApiResponseException(
      code: error?['code'] ?? 'UNKNOWN_ERROR',
      message: error?['message'] ?? 'An error occurred',
      statusCode: error?['statusCode'] as int?,
      details: error,
    );
  }
}