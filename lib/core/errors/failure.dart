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
  const ServerFailure([super.message = "Server failure occurred"]);
}

/// Represents a failure due to missing cache or read/write errors.
class CacheFailure extends Failure {
  const CacheFailure([super.message = "Cache failure occurred"]);
}

/// Represents a failure due to no or unstable internet connection.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = "No internet connection"]);
}

/// Represents a failure due to unauthorized or invalid credentials.
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = "Unauthorized access"]);
}

/// Represents a failure when requested data was not found.
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = "Requested data not found"]);
}

/// Represents a failure due to invalid input or validation error.
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = "Invalid input data"]);
}

/// Represents any unknown or unclassified failure.
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = "An unknown error occurred"]);
}
