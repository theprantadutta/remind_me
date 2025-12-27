import 'package:flutter/foundation.dart';
import 'logger_service.dart';

/// Base class for all app exceptions
abstract class AppException implements Exception {
  final String message;
  final String? userMessage;
  final Object? originalError;
  final StackTrace? stackTrace;

  AppException(
    this.message, {
    this.userMessage,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message';
}

/// Exception for storage/database operations
class StorageException extends AppException {
  StorageException(
    super.message, {
    super.userMessage = 'Failed to save data. Please try again.',
    super.originalError,
    super.stackTrace,
  });
}

/// Exception for notification operations
class NotificationException extends AppException {
  NotificationException(
    super.message, {
    super.userMessage = 'Failed to schedule notification.',
    super.originalError,
    super.stackTrace,
  });
}

/// Exception for background service operations
class BackgroundServiceException extends AppException {
  BackgroundServiceException(
    super.message, {
    super.userMessage = 'Background service error occurred.',
    super.originalError,
    super.stackTrace,
  });
}

/// Exception for validation errors
class ValidationException extends AppException {
  final Map<String, String> fieldErrors;

  ValidationException(
    super.message, {
    this.fieldErrors = const {},
    super.userMessage = 'Please check your input.',
    super.originalError,
    super.stackTrace,
  });

  bool hasFieldError(String field) => fieldErrors.containsKey(field);
  String? getFieldError(String field) => fieldErrors[field];
}

/// Exception for timezone operations
class TimezoneException extends AppException {
  TimezoneException(
    super.message, {
    super.userMessage = 'Failed to detect timezone.',
    super.originalError,
    super.stackTrace,
  });
}

/// Exception for initialization errors
class InitializationException extends AppException {
  InitializationException(
    super.message, {
    super.userMessage = 'Failed to initialize app. Please restart.',
    super.originalError,
    super.stackTrace,
  });
}

/// Centralized error handling service
class ErrorHandlerService {
  static ErrorHandlerService? _instance;

  ErrorHandlerService._();

  /// Get the singleton instance
  static ErrorHandlerService get instance {
    _instance ??= ErrorHandlerService._();
    return _instance!;
  }

  final LoggerService _logger = LoggerService.instance;

  /// Handle an error and return user-friendly message
  String handle(
    Object error, {
    StackTrace? stackTrace,
    String? context,
  }) {
    final tag = context ?? 'ErrorHandler';

    if (error is AppException) {
      _logger.error(
        error.message,
        tag: tag,
        error: error.originalError ?? error,
        stackTrace: stackTrace ?? error.stackTrace,
      );
      return error.userMessage ?? error.message;
    }

    // Handle standard Flutter errors
    if (error is FlutterError) {
      _logger.error(
        'Flutter error: ${error.message}',
        tag: tag,
        error: error,
        stackTrace: stackTrace,
      );
      return 'An unexpected error occurred.';
    }

    // Handle unknown errors
    _logger.error(
      'Unexpected error: $error',
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );

    return 'Something went wrong. Please try again.';
  }

  /// Wrap an async operation with error handling
  Future<T?> tryAsync<T>(
    Future<T> Function() operation, {
    String? context,
    T? defaultValue,
    void Function(String message)? onError,
  }) async {
    try {
      return await operation();
    } catch (e, stackTrace) {
      final message = handle(e, stackTrace: stackTrace, context: context);
      onError?.call(message);
      return defaultValue;
    }
  }

  /// Wrap a sync operation with error handling
  T? trySync<T>(
    T Function() operation, {
    String? context,
    T? defaultValue,
    void Function(String message)? onError,
  }) {
    try {
      return operation();
    } catch (e, stackTrace) {
      final message = handle(e, stackTrace: stackTrace, context: context);
      onError?.call(message);
      return defaultValue;
    }
  }

  /// Create a storage exception
  StorageException storageError(
    String message, {
    Object? originalError,
    StackTrace? stackTrace,
  }) {
    return StorageException(
      message,
      originalError: originalError,
      stackTrace: stackTrace,
    );
  }

  /// Create a notification exception
  NotificationException notificationError(
    String message, {
    Object? originalError,
    StackTrace? stackTrace,
  }) {
    return NotificationException(
      message,
      originalError: originalError,
      stackTrace: stackTrace,
    );
  }

  /// Create a validation exception
  ValidationException validationError(
    String message, {
    Map<String, String> fieldErrors = const {},
  }) {
    return ValidationException(
      message,
      fieldErrors: fieldErrors,
    );
  }
}
