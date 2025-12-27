import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../entities/task.dart';
import '../enums/priority.dart';
import '../services/hive_service.dart';
import '../services/notification_service.dart';
import '../services/search_filter_service.dart';
import '../services/statistics_service.dart';
import '../services/task_completion_service.dart';

/// Provider for managing tasks and task-related state
class TaskProvider extends ChangeNotifier {
  final _uuid = const Uuid();

  // Current filter state
  TaskFilter _currentFilter = const TaskFilter();
  TaskFilter get currentFilter => _currentFilter;

  // Cached filtered tasks
  List<Task> _filteredTasks = [];
  List<Task> get filteredTasks => _filteredTasks;

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Initialize and load tasks
  void loadTasks() {
    _filteredTasks = SearchFilterService.instance.getFilteredTasks(_currentFilter);
    notifyListeners();
  }

  /// Apply a new filter
  void applyFilter(TaskFilter filter) {
    _currentFilter = filter;
    loadTasks();
  }

  /// Clear all filters
  void clearFilters() {
    _currentFilter = const TaskFilter();
    loadTasks();
  }

  /// Update search query
  void setSearchQuery(String? query) {
    _currentFilter = _currentFilter.copyWith(
      searchQuery: query,
      clearSearchQuery: query == null || query.isEmpty,
    );
    loadTasks();
  }

  /// Update category filter
  void setCategoryFilter(List<String>? categoryIds) {
    _currentFilter = _currentFilter.copyWith(
      categoryIds: categoryIds,
      clearCategoryIds: categoryIds == null || categoryIds.isEmpty,
    );
    loadTasks();
  }

  /// Update priority filter
  void setPriorityFilter(List<Priority>? priorities) {
    _currentFilter = _currentFilter.copyWith(
      priorities: priorities,
      clearPriorities: priorities == null || priorities.isEmpty,
    );
    loadTasks();
  }

  /// Update sort field
  void setSortField(TaskSortField field, {bool? ascending}) {
    _currentFilter = _currentFilter.copyWith(
      sortField: field,
      sortAscending: ascending,
    );
    loadTasks();
  }

  /// Toggle completion filter
  void setCompletionFilter(bool? isCompleted) {
    _currentFilter = _currentFilter.copyWith(
      isCompleted: isCompleted,
      clearIsCompleted: isCompleted == null,
    );
    loadTasks();
  }

  /// Create a new task
  Future<Task?> createTask({
    required String title,
    required String description,
    required List<DateTime> notificationTimes,
    bool deleteWhenExpired = false,
    bool enableRecurring = false,
    int? recurrenceIntervalInSeconds,
    int? recurrenceCount,
    DateTime? recurrenceEndDate,
    bool enableAlarm = false,
    String? categoryId,
    Priority priority = Priority.medium,
    List<String>? tagIds,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final task = Task(
        id: _uuid.v4(),
        title: title,
        description: description,
        notificationTime: notificationTimes,
        deleteWhenExpired: deleteWhenExpired,
        enableRecurring: enableRecurring,
        recurrenceIntervalInSeconds: recurrenceIntervalInSeconds,
        recurrenceCount: recurrenceCount,
        recurrenceEndDate: recurrenceEndDate,
        enableAlarm: enableAlarm,
        categoryId: categoryId,
        priority: priority,
        tagIds: tagIds,
        createdAt: DateTime.now(),
      );

      // Save to Hive
      await HiveService.instance.tasksBox.put(task.id, task);

      // Schedule notifications
      for (final time in notificationTimes) {
        if (time.isAfter(DateTime.now())) {
          await NotificationService().scheduleNotification(
            id: time.millisecondsSinceEpoch ~/ 1000,
            title: title,
            body: description,
            scheduledDateTime: time,
            payload: task.id,
            enableAlarm: enableAlarm,
          );
        }
      }

      // Record statistics
      await StatisticsService.instance.recordTaskCreated();

      loadTasks();
      return task;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update an existing task
  Future<Task?> updateTask({
    required String id,
    String? title,
    String? description,
    List<DateTime>? notificationTimes,
    bool? deleteWhenExpired,
    bool? enableRecurring,
    int? recurrenceIntervalInSeconds,
    int? recurrenceCount,
    DateTime? recurrenceEndDate,
    bool? enableAlarm,
    String? categoryId,
    bool clearCategoryId = false,
    Priority? priority,
    List<String>? tagIds,
    bool clearTagIds = false,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final existing = HiveService.instance.tasksBox.get(id);
      if (existing == null) return null;

      // Cancel old notifications if times changed
      if (notificationTimes != null) {
        await NotificationService().cancelNotificationsForTask(id);
      }

      final updated = existing.copyWith(
        title: title,
        description: description,
        notificationTime: notificationTimes,
        deleteWhenExpired: deleteWhenExpired,
        enableRecurring: enableRecurring,
        recurrenceIntervalInSeconds: recurrenceIntervalInSeconds,
        recurrenceCount: recurrenceCount,
        recurrenceEndDate: recurrenceEndDate,
        enableAlarm: enableAlarm,
        categoryId: categoryId,
        clearCategoryId: clearCategoryId,
        priority: priority,
        tagIds: tagIds,
        clearTagIds: clearTagIds,
      );

      await HiveService.instance.tasksBox.put(id, updated);

      // Schedule new notifications
      if (notificationTimes != null && !updated.isCompleted) {
        for (final time in notificationTimes) {
          if (time.isAfter(DateTime.now())) {
            await NotificationService().scheduleNotification(
              id: time.millisecondsSinceEpoch ~/ 1000,
              title: updated.title,
              body: updated.description,
              scheduledDateTime: time,
              payload: id,
              enableAlarm: updated.enableAlarm,
            );
          }
        }
      }

      loadTasks();
      return updated;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Complete a task
  Future<bool> completeTask(String taskId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await TaskCompletionService.instance.completeTask(taskId);
      if (result != null) {
        loadTasks();
        return true;
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Uncomplete a task
  Future<bool> uncompleteTask(String taskId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await TaskCompletionService.instance.uncompleteTask(taskId);
      if (result != null) {
        loadTasks();
        return true;
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete a task
  Future<bool> deleteTask(String taskId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await TaskCompletionService.instance.deleteTask(taskId);
      if (result) {
        loadTasks();
      }
      return result;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get a task by ID
  Task? getTaskById(String id) {
    return HiveService.instance.tasksBox.get(id);
  }

  /// Get tasks due today
  List<Task> get tasksDueToday => SearchFilterService.instance.getTasksDueToday();

  /// Get tasks due this week
  List<Task> get tasksDueThisWeek => SearchFilterService.instance.getTasksDueThisWeek();

  /// Get overdue tasks
  List<Task> get overdueTasks => SearchFilterService.instance.getOverdueTasks();

  /// Get upcoming tasks
  List<Task> getUpcomingTasks({int limit = 5}) =>
      SearchFilterService.instance.getUpcomingTasks(limit: limit);

  /// Get incomplete task count
  int get incompleteTaskCount =>
      SearchFilterService.instance.getIncompleteTasks().length;

  /// Get completed task count
  int get completedTaskCount =>
      SearchFilterService.instance.getCompletedTasks().length;

  /// Get completed tasks list
  List<Task> get completedTasks =>
      SearchFilterService.instance.getCompletedTasks();

  /// Restore a completed task (uncomplete it)
  Future<bool> restoreTask(String taskId) async {
    return uncompleteTask(taskId);
  }

  /// Delete all completed tasks
  Future<void> deleteAllCompletedTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      final completed = completedTasks;
      for (final task in completed) {
        await TaskCompletionService.instance.deleteTask(task.id);
      }
      loadTasks();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
