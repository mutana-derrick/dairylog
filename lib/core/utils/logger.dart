import 'dart:developer' as developer;

/// Centralized logger for development and debugging.
///
/// Provides consistent logging format and optional debug toggle.
class Logger {
  static bool _isDebug = true;

  /// Enable or disable logging
  static void setDebug(bool isDebug) {
    _isDebug = isDebug;
  }

  /// Logs informational messages
  static void info(String message, {String? tag}) {
    if (_isDebug) {
      developer.log(message, name: tag ?? 'INFO');
    }
  }

  /// Logs warning messages
  static void warn(String message, {String? tag}) {
    if (_isDebug) {
      developer.log(message, name: tag ?? 'WARN');
    }
  }

  /// Logs error messages
  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    if (_isDebug) {
      developer.log(message, name: tag ?? 'ERROR', error: error, stackTrace: stackTrace);
    }
  }

  /// Logs debug messages
  static void debug(String message, {String? tag}) {
    if (_isDebug) {
      developer.log(message, name: tag ?? 'DEBUG');
    }
  }
}
