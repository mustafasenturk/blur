/// Base exception class for app-specific errors
sealed class AppException implements Exception {
  const AppException(this.message, [this.code]);

  final String message;
  final String? code;

  @override
  String toString() =>
      'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException([
    super.message = 'Network error occurred',
    super.code,
  ]);
}

/// No internet connection
class NoInternetException extends NetworkException {
  const NoInternetException() : super('No internet connection');
}

/// Server error (5xx)
class ServerException extends NetworkException {
  const ServerException([super.message = 'Server error occurred', super.code]);
}

/// Client error (4xx)
class ClientException extends NetworkException {
  const ClientException([super.message = 'Client error occurred', super.code]);
}

/// Timeout exception
class TimeoutException extends NetworkException {
  const TimeoutException() : super('Request timed out');
}

/// Authentication exceptions
class AuthException extends AppException {
  const AuthException([super.message = 'Authentication error', super.code]);
}

/// User not authenticated
class UnauthenticatedException extends AuthException {
  const UnauthenticatedException() : super('User not authenticated');
}

/// Session expired
class SessionExpiredException extends AuthException {
  const SessionExpiredException() : super('Session expired');
}

/// Invalid credentials
class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException() : super('Invalid credentials');
}

/// Validation exceptions
class ValidationException extends AppException {
  const ValidationException(super.message, [super.code]);
}

/// Storage exceptions
class StorageException extends AppException {
  const StorageException([
    super.message = 'Storage error occurred',
    super.code,
  ]);
}

/// Permission exceptions
class PermissionException extends AppException {
  const PermissionException([super.message = 'Permission denied', super.code]);
}

/// Feature-specific exceptions
class ChatException extends AppException {
  const ChatException([super.message = 'Chat error occurred', super.code]);
}

class ProfileException extends AppException {
  const ProfileException([
    super.message = 'Profile error occurred',
    super.code,
  ]);
}
