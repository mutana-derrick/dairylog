/// Custom exception classes used to handle different data source errors.
///
/// These are caught in repositories and then converted into `Failure`
/// objects for consistent error handling across the app.
class ServerException implements Exception {
  final String message;
  const ServerException([this.message = "Server error occurred"]);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = "Cache error occurred"]);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = "No internet connection"]);
}

class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException([this.message = "Unauthorized access"]);
}

class NotFoundException implements Exception {
  final String message;
  const NotFoundException([this.message = "Requested data not found"]);
}

class ValidationException implements Exception {
  final String message;
  const ValidationException([this.message = "Invalid input data"]);
}

class UnknownException implements Exception {
  final String message;
  const UnknownException([this.message = "An unknown error occurred"]);
}
