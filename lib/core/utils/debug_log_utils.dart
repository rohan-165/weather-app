import 'dart:developer' as dev;

/// Log levels for categorizing debug messages.
enum LogLevel { success, info, warning, error, debug }

/// Utility class for flexible debug logging in Flutter apps.
/// Runs only in debug mode via `assert`.
/// Supports log levels, tags, and optional breakpoint for pausing execution.
///
/// Example usage:
/// ```dart
/// DebugUtils.debugLog('A debug message');
/// DebugUtils.debugLog('Login successful', level: LogLevel.success, tag: 'Auth');
/// DebugUtils.debugLog('An error occurred', level: LogLevel.error, breakPoint: true);
/// ```
class DebugUtils {
  static const Map<LogLevel, String> _emojiMap = {
    LogLevel.success: '✅',
    LogLevel.info: 'ℹ️',
    LogLevel.warning: '⚠️',
    LogLevel.error: '❌',
    LogLevel.debug: '🐛',
  };

  /// Logs a message only in debug mode.
  ///
  /// [message] is the text to log.
  /// [level] categorizes the log (default is debug).
  /// [breakPoint], if true, pauses execution for debugger (default is false).
  /// [tag] is an optional string for categorizing logs.
  static void debugLog(
    String message, {
    LogLevel level = LogLevel.debug,
    bool breakPoint = false,
    String? tag,
  }) {
    assert(() {
      if (breakPoint) dev.debugger();
      _logMessage(message, level: level, tag: tag);
      return true;
    }());
  }

  static void _logMessage(
    String message, {
    required LogLevel level,
    String? tag,
  }) {
    final timestamp = DateTime.now().toIso8601String();
    final levelStr = level.toString().split('.').last.toUpperCase();
    final emoji = _emojiMap[level] ?? '';
    final effectiveTag = tag ?? 'DebugUtils';

    final formattedMessage = '[$timestamp][$emoji $levelStr] $message';

    dev.log(
      formattedMessage,
      name: '$effectiveTag - @rohan-165',
      level: _mapLogLevelToInt(level),
    );
  }

  static int _mapLogLevelToInt(LogLevel level) {
    switch (level) {
      case LogLevel.success:
        return 700;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
      case LogLevel.debug:
        return 700;
    }
  }
}

/// Service class to allow dependency injection and mocking of logging.
/// Wraps DebugUtils.debugLog for easier testing and extensibility.
///
/// Example:
/// ```dart
/// final logger = DebugLoggerService();
/// logger.log('Success!', level: LogLevel.success);
/// ```
class DebugLoggerService {
  void log(
    String message, {
    bool breakPoint = false,
    LogLevel level = LogLevel.info,
    String? tag,
  }) {
    DebugUtils.debugLog(
      message,
      breakPoint: breakPoint,
      level: level,
      tag: tag,
    );
  }
}
