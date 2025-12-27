import '../entities/task.dart';
import '../enums/priority.dart';
import 'hive_service.dart';

/// Filter criteria for tasks
class TaskFilter {
  final String? searchQuery;
  final List<String>? categoryIds;
  final List<Priority>? priorities;
  final List<String>? tagIds;
  final bool? isCompleted;
  final DateTime? dueDateFrom;
  final DateTime? dueDateTo;
  final TaskSortField sortField;
  final bool sortAscending;

  const TaskFilter({
    this.searchQuery,
    this.categoryIds,
    this.priorities,
    this.tagIds,
    this.isCompleted,
    this.dueDateFrom,
    this.dueDateTo,
    this.sortField = TaskSortField.dueDate,
    this.sortAscending = true,
  });

  TaskFilter copyWith({
    String? searchQuery,
    List<String>? categoryIds,
    List<Priority>? priorities,
    List<String>? tagIds,
    bool? isCompleted,
    DateTime? dueDateFrom,
    DateTime? dueDateTo,
    TaskSortField? sortField,
    bool? sortAscending,
    bool clearSearchQuery = false,
    bool clearCategoryIds = false,
    bool clearPriorities = false,
    bool clearTagIds = false,
    bool clearIsCompleted = false,
    bool clearDueDateFrom = false,
    bool clearDueDateTo = false,
  }) {
    return TaskFilter(
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      categoryIds: clearCategoryIds ? null : (categoryIds ?? this.categoryIds),
      priorities: clearPriorities ? null : (priorities ?? this.priorities),
      tagIds: clearTagIds ? null : (tagIds ?? this.tagIds),
      isCompleted: clearIsCompleted ? null : (isCompleted ?? this.isCompleted),
      dueDateFrom: clearDueDateFrom ? null : (dueDateFrom ?? this.dueDateFrom),
      dueDateTo: clearDueDateTo ? null : (dueDateTo ?? this.dueDateTo),
      sortField: sortField ?? this.sortField,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }

  bool get hasActiveFilters =>
      searchQuery != null ||
      categoryIds != null ||
      priorities != null ||
      tagIds != null ||
      isCompleted != null ||
      dueDateFrom != null ||
      dueDateTo != null;

  static const TaskFilter empty = TaskFilter();
}

/// Sort fields for tasks
enum TaskSortField {
  dueDate,
  priority,
  title,
  createdAt,
  category,
}

/// Service for searching and filtering tasks
class SearchFilterService {
  static SearchFilterService? _instance;
  static SearchFilterService get instance =>
      _instance ??= SearchFilterService._();
  SearchFilterService._();

  /// Get all tasks with filter applied
  List<Task> getFilteredTasks(TaskFilter filter) {
    var tasks = HiveService.instance.tasksBox.values.toList();

    // Apply filters
    tasks = _applyFilters(tasks, filter);

    // Apply sorting
    tasks = _applySorting(tasks, filter);

    return tasks;
  }

  /// Get incomplete tasks only
  List<Task> getIncompleteTasks({TaskFilter? filter}) {
    final effectiveFilter =
        (filter ?? const TaskFilter()).copyWith(isCompleted: false);
    return getFilteredTasks(effectiveFilter);
  }

  /// Get completed tasks only
  List<Task> getCompletedTasks({TaskFilter? filter}) {
    final effectiveFilter =
        (filter ?? const TaskFilter()).copyWith(isCompleted: true);
    return getFilteredTasks(effectiveFilter);
  }

  /// Search tasks by query
  List<Task> searchTasks(String query, {bool includeCompleted = false}) {
    final filter = TaskFilter(
      searchQuery: query,
      isCompleted: includeCompleted ? null : false,
    );
    return getFilteredTasks(filter);
  }

  List<Task> _applyFilters(List<Task> tasks, TaskFilter filter) {
    // Search query filter
    if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
      final query = filter.searchQuery!.toLowerCase();
      tasks = tasks.where((task) {
        return task.title.toLowerCase().contains(query) ||
            task.description.toLowerCase().contains(query);
      }).toList();
    }

    // Category filter
    if (filter.categoryIds != null && filter.categoryIds!.isNotEmpty) {
      tasks = tasks.where((task) {
        return task.categoryId != null &&
            filter.categoryIds!.contains(task.categoryId);
      }).toList();
    }

    // Priority filter
    if (filter.priorities != null && filter.priorities!.isNotEmpty) {
      tasks = tasks.where((task) {
        return filter.priorities!.contains(task.priority);
      }).toList();
    }

    // Tag filter
    if (filter.tagIds != null && filter.tagIds!.isNotEmpty) {
      tasks = tasks.where((task) {
        if (task.tagIds == null) return false;
        return filter.tagIds!.any((tagId) => task.tagIds!.contains(tagId));
      }).toList();
    }

    // Completion status filter
    if (filter.isCompleted != null) {
      tasks = tasks.where((task) {
        return task.isCompleted == filter.isCompleted;
      }).toList();
    }

    // Due date range filter
    if (filter.dueDateFrom != null || filter.dueDateTo != null) {
      tasks = tasks.where((task) {
        if (task.notificationTime.isEmpty) return false;

        // Get the earliest notification time as due date
        final dueDate = task.notificationTime.reduce(
          (a, b) => a.isBefore(b) ? a : b,
        );

        if (filter.dueDateFrom != null && dueDate.isBefore(filter.dueDateFrom!)) {
          return false;
        }
        if (filter.dueDateTo != null && dueDate.isAfter(filter.dueDateTo!)) {
          return false;
        }
        return true;
      }).toList();
    }

    return tasks;
  }

  List<Task> _applySorting(List<Task> tasks, TaskFilter filter) {
    tasks.sort((a, b) {
      int comparison;

      switch (filter.sortField) {
        case TaskSortField.dueDate:
          final aDate = a.notificationTime.isNotEmpty
              ? a.notificationTime.reduce((x, y) => x.isBefore(y) ? x : y)
              : DateTime.now().add(const Duration(days: 365));
          final bDate = b.notificationTime.isNotEmpty
              ? b.notificationTime.reduce((x, y) => x.isBefore(y) ? x : y)
              : DateTime.now().add(const Duration(days: 365));
          comparison = aDate.compareTo(bDate);
          break;

        case TaskSortField.priority:
          comparison = a.priority.sortOrder.compareTo(b.priority.sortOrder);
          break;

        case TaskSortField.title:
          comparison = a.title.toLowerCase().compareTo(b.title.toLowerCase());
          break;

        case TaskSortField.createdAt:
          final aCreated = a.createdAt ?? DateTime(2000);
          final bCreated = b.createdAt ?? DateTime(2000);
          comparison = aCreated.compareTo(bCreated);
          break;

        case TaskSortField.category:
          final aCat = a.categoryId ?? '';
          final bCat = b.categoryId ?? '';
          comparison = aCat.compareTo(bCat);
          break;
      }

      return filter.sortAscending ? comparison : -comparison;
    });

    return tasks;
  }

  /// Get tasks due today
  List<Task> getTasksDueToday() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return getFilteredTasks(TaskFilter(
      isCompleted: false,
      dueDateFrom: startOfDay,
      dueDateTo: endOfDay,
    ));
  }

  /// Get tasks due this week
  List<Task> getTasksDueThisWeek() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfWeek = startOfDay.add(const Duration(days: 7));

    return getFilteredTasks(TaskFilter(
      isCompleted: false,
      dueDateFrom: startOfDay,
      dueDateTo: endOfWeek,
    ));
  }

  /// Get overdue tasks
  List<Task> getOverdueTasks() {
    final now = DateTime.now();
    final tasks = HiveService.instance.tasksBox.values
        .where((task) => !task.isCompleted)
        .where((task) {
      if (task.notificationTime.isEmpty) return false;
      return task.notificationTime.every((t) => t.isBefore(now));
    }).toList();

    return tasks..sort((a, b) {
      final aDate = a.notificationTime.reduce((x, y) => x.isBefore(y) ? x : y);
      final bDate = b.notificationTime.reduce((x, y) => x.isBefore(y) ? x : y);
      return aDate.compareTo(bDate);
    });
  }

  /// Get upcoming tasks (next N tasks by due date)
  List<Task> getUpcomingTasks({int limit = 5}) {
    final now = DateTime.now();
    final tasks = HiveService.instance.tasksBox.values
        .where((task) => !task.isCompleted)
        .where((task) {
      if (task.notificationTime.isEmpty) return false;
      return task.notificationTime.any((t) => t.isAfter(now));
    }).toList();

    tasks.sort((a, b) {
      final aDate = a.notificationTime
          .where((t) => t.isAfter(now))
          .reduce((x, y) => x.isBefore(y) ? x : y);
      final bDate = b.notificationTime
          .where((t) => t.isAfter(now))
          .reduce((x, y) => x.isBefore(y) ? x : y);
      return aDate.compareTo(bDate);
    });

    return tasks.take(limit).toList();
  }
}
