import 'package:flutter/foundation.dart';

/// Log level severity
enum LogLevel {
  debug,
  info,
  warning,
  error,
  fatal,
}

/// A single log entry
class LogEntry {
  final LogLevel level;
  final String message;
  final String? tag;
  final Object? error;
  final StackTrace? stackTrace;
  final DateTime timestamp;

  LogEntry({
    required this.level,
    required this.message,
    this.tag,
    this.error,
    this.stackTrace,
    required this.timestamp,
  });

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('[${timestamp.toIso8601String()}]');
    buffer.write('[${level.name.toUpperCase()}]');
    if (tag != null) buffer.write('[$tag]');
    buffer.write(' $message');
    if (error != null) buffer.write('\nError: $error');
    if (stackTrace != null) buffer.write('\nStackTrace: $stackTrace');
    return buffer.toString();
  }

  /// Convert to JSON for potential export
  Map<String, dynamic> toJson() => {
        'level': level.name,
        'message': message,
        'tag': tag,
        'error': error?.toString(),
        'timestamp': timestamp.toIso8601String(),
      };
}

/// Centralized logging service for the app
class LoggerService {
  static LoggerService? _instance;

  LoggerService._();

  /// Get the singleton instance
  static LoggerService get instance {
    _instance ??= LoggerService._();
    return _instance!;
  }

  final List<LogEntry> _logs = [];
  static const int _maxLogs = 1000;

  // Minimum log level to store (in production, might want to set to warning)
  LogLevel _minLevel = kDebugMode ? LogLevel.debug : LogLevel.info;

  /// Set the minimum log level
  void setMinLevel(LogLevel level) {
    _minLevel = level;
  }

  /// Log a message with the specified level
  void log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Skip logs below minimum level
    if (level.index < _minLevel.index) return;

    final entry = LogEntry(
      level: level,
      message: message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      timestamp: DateTime.now(),
    );

    // Add to in-memory log buffer
    _logs.add(entry);
    if (_logs.length > _maxLogs) {
      _logs.removeAt(0);
    }

    // Print to console in debug mode
    if (kDebugMode) {
      _printLog(entry);
    }

    // Handle critical errors (error and fatal levels)
    if (level == LogLevel.error || level == LogLevel.fatal) {
      _handleCriticalError(entry);
    }
  }

  /// Log debug message
  void debug(String message, {String? tag}) =>
      log(LogLevel.debug, message, tag: tag);

  /// Log info message
  void info(String message, {String? tag}) =>
      log(LogLevel.info, message, tag: tag);

  /// Log warning message
  void warning(String message, {String? tag}) =>
      log(LogLevel.warning, message, tag: tag);

  /// Log error message
  void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      log(LogLevel.error, message,
          tag: tag, error: error, stackTrace: stackTrace);

  /// Log fatal error message
  void fatal(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      log(LogLevel.fatal, message,
          tag: tag, error: error, stackTrace: stackTrace);

  void _printLog(LogEntry entry) {
    final prefix = '[${entry.level.name.toUpperCase()}]';
    final tagStr = entry.tag != null ? '[${entry.tag}]' : '';
    final timeStr =
        '${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}:${entry.timestamp.second.toString().padLeft(2, '0')}';

    // Use color codes based on level
    String coloredOutput;
    switch (entry.level) {
      case LogLevel.debug:
        coloredOutput = '\x1B[37m$timeStr $prefix$tagStr ${entry.message}\x1B[0m';
      case LogLevel.info:
        coloredOutput = '\x1B[34m$timeStr $prefix$tagStr ${entry.message}\x1B[0m';
      case LogLevel.warning:
        coloredOutput = '\x1B[33m$timeStr $prefix$tagStr ${entry.message}\x1B[0m';
      case LogLevel.error:
        coloredOutput = '\x1B[31m$timeStr $prefix$tagStr ${entry.message}\x1B[0m';
      case LogLevel.fatal:
        coloredOutput = '\x1B[35m$timeStr $prefix$tagStr ${entry.message}\x1B[0m';
    }

    debugPrint(coloredOutput);

    if (entry.error != null) {
      debugPrint('  Error: ${entry.error}');
    }
    if (entry.stackTrace != null && entry.level.index >= LogLevel.error.index) {
      debugPrint('  StackTrace: ${entry.stackTrace}');
    }
  }

  void _handleCriticalError(LogEntry entry) {
    // TODO: Integrate with crash reporting service (Firebase Crashlytics, Sentry)
    // Example:
    // FirebaseCrashlytics.instance.recordError(
    //   entry.error,
    //   entry.stackTrace,
    //   reason: entry.message,
    // );
  }

  /// Get all logs, optionally filtered by minimum level
  List<LogEntry> getLogs({LogLevel? minLevel}) {
    if (minLevel == null) return List.unmodifiable(_logs);
    return _logs.where((e) => e.level.index >= minLevel.index).toList();
  }

  /// Get logs as JSON array
  List<Map<String, dynamic>> getLogsAsJson({LogLevel? minLevel}) {
    return getLogs(minLevel: minLevel).map((e) => e.toJson()).toList();
  }

  /// Clear all logs
  void clearLogs() => _logs.clear();

  /// Get log count
  int get logCount => _logs.length;

  /// Get error count
  int get errorCount =>
      _logs.where((e) => e.level.index >= LogLevel.error.index).length;
}
