import 'package:flutter/foundation.dart';

/// Provider for managing loading states across the app
class LoadingProvider extends ChangeNotifier {
  final Map<String, bool> _loadingStates = {};

  /// Check if a specific operation is loading
  bool isLoading(String key) => _loadingStates[key] ?? false;

  /// Check if any operation is loading
  bool get hasAnyLoading => _loadingStates.values.any((v) => v);

  /// Set loading state for a specific operation
  void setLoading(String key, bool loading) {
    if (_loadingStates[key] != loading) {
      _loadingStates[key] = loading;
      notifyListeners();
    }
  }

  /// Clear loading state for a specific operation
  void clearLoading(String key) {
    if (_loadingStates.containsKey(key)) {
      _loadingStates.remove(key);
      notifyListeners();
    }
  }

  /// Clear all loading states
  void clearAll() {
    if (_loadingStates.isNotEmpty) {
      _loadingStates.clear();
      notifyListeners();
    }
  }

  /// Execute an async operation with loading state management
  Future<T?> withLoading<T>(
    String key,
    Future<T> Function() operation, {
    void Function(Object error)? onError,
  }) async {
    try {
      setLoading(key, true);
      final result = await operation();
      return result;
    } catch (e) {
      onError?.call(e);
      return null;
    } finally {
      setLoading(key, false);
    }
  }
}

/// Common loading keys
class LoadingKeys {
  static const String taskList = 'task_list';
  static const String taskCreate = 'task_create';
  static const String taskUpdate = 'task_update';
  static const String taskDelete = 'task_delete';
  static const String taskComplete = 'task_complete';
  static const String categories = 'categories';
  static const String statistics = 'statistics';
  static const String calendar = 'calendar';
  static const String search = 'search';
  static const String initialization = 'initialization';
}
