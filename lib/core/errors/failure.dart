/// Failure classes are used in the domain and presentation layers
/// to represent handled errors (converted from Exceptions).
///
/// Example usage:
/// ```dart
/// final result = await repository.getJobs();
/// result.fold(
///   (failure) => showError(failure.message),
///   (data) => displayJobs(data),
/// );
/// ```

abstract class Failure {
  final String message;
  const Failure(this.message);
}

/// Represents a failure due to server or API issues.
class ServerFailure extends Failure {
  const ServerFailure([String message = "Server failure occurred"]) : super(message);
}

/// Represents a failure due to missing cache or read/write errors.
class CacheFailure extends Failure {
  const CacheFailure([String message = "Cache failure occurred"]) : super(message);
}

/// Represents a failure due to no or unstable internet connection.
class NetworkFailure extends Failure {
  const NetworkFailure([String message = "No internet connection"]) : super(message);
}

/// Represents a failure due to unauthorized or invalid credentials.
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([String message = "Unauthorized access"]) : super(message);
}

/// Represents a failure when requested data was not found.
class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = "Requested data not found"]) : super(message);
}

/// Represents a failure due to invalid input or validation error.
class ValidationFailure extends Failure {
  const ValidationFailure([String message = "Invalid input data"]) : super(message);
}

/// Represents any unknown or unclassified failure.
class UnknownFailure extends Failure {
  const UnknownFailure([String message = "An unknown error occurred"]) : super(message);
}
