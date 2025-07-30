import 'dart:developer' as dev;

enum LogLevel { success, info, warning, error, debug }

/// Utility class for flexible debug logging in Flutter apps.
/// Runs only in debug mode via `assert`.
/// Supports log levels, tags, and optional breakpoint for pausing execution.
class DebugUtils {
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
    final effectiveTag = tag ?? 'DebugUtils';

    final formattedMessage = '[$timestamp][$levelStr] $message';

    dev.log(
      formattedMessage,
      name: '$effectiveTag - @rohan-165',
      level: _mapLogLevelToInt(level),
    );
  }

  static int _mapLogLevelToInt(LogLevel level) {
    switch (level) {
      case LogLevel.success:
        return 600;
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

/// Example Usages:
void main() {
  DebugUtils.debugLog("App Init sucessfully", level: LogLevel.info);

  DebugUtils.debugLog("No Data Fount");

  DebugUtils.debugLog(
    "Failed to load used data",
    level: LogLevel.error,
    tag: 'UserModel',
  );
}
