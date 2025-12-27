import 'package:uuid/uuid.dart';

import '../entities/completed_task.dart';
import '../entities/task.dart';
import 'hive_service.dart';
import 'logger_service.dart';
import 'notification_service.dart';
import 'statistics_service.dart';

/// Service for managing task completion and archiving
class TaskCompletionService {
  static TaskCompletionService? _instance;
  static TaskCompletionService get instance =>
      _instance ??= TaskCompletionService._();
  TaskCompletionService._();

  final _logger = LoggerService.instance;
  final _uuid = const Uuid();

  /// Mark a task as completed and archive it
  Future<CompletedTask?> completeTask(String taskId) async {
    final tasksBox = HiveService.instance.tasksBox;
    final task = tasksBox.get(taskId);

    if (task == null) {
      _logger.warning('Task not found for completion: $taskId',
          tag: 'TaskCompletionService');
      return null;
    }

    if (task.isCompleted) {
      _logger.warning('Task already completed: $taskId',
          tag: 'TaskCompletionService');
      return null;
    }

    final completedAt = DateTime.now();

    // Create archived record
    final completedTask = CompletedTask(
      id: _uuid.v4(),
      originalTaskId: task.id,
      title: task.title,
      description: task.description,
      completedAt: completedAt,
      originalNotificationTime: task.notificationTime,
      categoryId: task.categoryId,
      priority: task.priority,
      tagIds: task.tagIds,
      createdAt: task.createdAt,
    );

    // Save to completed tasks archive
    await HiveService.instance.completedTasksBox.put(
      completedTask.id,
      completedTask,
    );

    // Update the original task
    final updatedTask = task.copyWith(
      isCompleted: true,
      completedAt: completedAt,
    );
    await tasksBox.put(taskId, updatedTask);

    // Cancel any pending notifications
    await NotificationService().cancelNotificationsForTask(taskId);

    // Update statistics
    await StatisticsService.instance.recordTaskCompleted();

    _logger.info('Task completed: ${task.title}', tag: 'TaskCompletionService');

    return completedTask;
  }

  /// Uncomplete a task (restore from completed state)
  Future<Task?> uncompleteTask(String taskId) async {
    final tasksBox = HiveService.instance.tasksBox;
    final task = tasksBox.get(taskId);

    if (task == null) {
      _logger.warning('Task not found for uncompletion: $taskId',
          tag: 'TaskCompletionService');
      return null;
    }

    if (!task.isCompleted) {
      _logger.warning('Task is not completed: $taskId',
          tag: 'TaskCompletionService');
      return null;
    }

    // Update the task
    final updatedTask = task.copyWith(
      isCompleted: false,
      clearCompletedAt: true,
    );
    await tasksBox.put(taskId, updatedTask);

    // Reschedule notifications if notification times are in the future
    for (final time in task.notificationTime) {
      if (time.isAfter(DateTime.now())) {
        await NotificationService().scheduleNotification(
          id: time.millisecondsSinceEpoch ~/ 1000,
          title: task.title,
          body: task.description,
          scheduledDateTime: time,
          payload: taskId,
        );
      }
    }

    _logger.info('Task uncompleted: ${task.title}',
        tag: 'TaskCompletionService');

    return updatedTask;
  }

  /// Delete a task completely
  Future<bool> deleteTask(String taskId) async {
    final tasksBox = HiveService.instance.tasksBox;
    final task = tasksBox.get(taskId);

    if (task == null) {
      return false;
    }

    // Cancel any pending notifications
    await NotificationService().cancelNotificationsForTask(taskId);

    // Delete the task
    await tasksBox.delete(taskId);

    _logger.info('Task deleted: ${task.title}', tag: 'TaskCompletionService');

    return true;
  }

  /// Get all completed/archived tasks
  List<CompletedTask> getCompletedTasks() {
    return HiveService.instance.completedTasksBox.values.toList()
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
  }

  /// Get completed tasks within a date range
  List<CompletedTask> getCompletedTasksInRange(
      DateTime start, DateTime end) {
    return HiveService.instance.completedTasksBox.values
        .where((t) =>
            t.completedAt.isAfter(start) && t.completedAt.isBefore(end))
        .toList()
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
  }

  /// Delete a completed task from archive
  Future<bool> deleteCompletedTask(String completedTaskId) async {
    final exists =
        HiveService.instance.completedTasksBox.containsKey(completedTaskId);
    if (!exists) {
      return false;
    }

    await HiveService.instance.completedTasksBox.delete(completedTaskId);
    _logger.info('Deleted completed task: $completedTaskId',
        tag: 'TaskCompletionService');

    return true;
  }

  /// Clear all completed tasks from archive
  Future<void> clearCompletedTasksArchive() async {
    await HiveService.instance.completedTasksBox.clear();
    _logger.info('Cleared completed tasks archive',
        tag: 'TaskCompletionService');
  }

  /// Get count of completed tasks
  int getCompletedTaskCount() {
    return HiveService.instance.completedTasksBox.length;
  }
}
