import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:remind_me/entities/task.dart';

void main() {
  group('Background Task Logic Tests', () {
    late Box<Task> taskBox;

    setUp(() async {
      // Create in-memory box for testing
      taskBox = await Hive.openBox<Task>('test_task_box', path: null);
    });

    tearDown(() async {
      await taskBox.close();
    });

    test('should deactivate expired non-recurring tasks', () async {
      // Arrange
      final expiredTime = DateTime.now().subtract(const Duration(hours: 2));
      final task = Task(
        id: 'test_task',
        title: 'Test Task',
        description: 'Test Description',
        isActive: true,
        deleteWhenExpired: false,
        notificationTime: [expiredTime],
        enableRecurring: false,
        recurrenceCount: 1,
      );

      await taskBox.put(task.id, task);

      // Act - Simulate background task logic
      final currentTime = DateTime.now();
      final tasksToUpdate = taskBox.keys.where((key) {
        final task = taskBox.get(key);
        if (task != null && task.notificationTime.isNotEmpty && task.isActive) {
          final hasExpiredTime = task.notificationTime
              .any((dateTime) => dateTime.isBefore(currentTime));

          bool shouldExpire = false;
          if (task.enableRecurring) {
            if (task.recurrenceEndDate != null) {
              shouldExpire = task.recurrenceEndDate!.isBefore(currentTime) && hasExpiredTime;
            }
          } else {
            shouldExpire = hasExpiredTime;
          }
          return shouldExpire;
        }
        return false;
      }).toList();

      // Deactivate tasks
      for (var key in tasksToUpdate) {
        final task = taskBox.get(key);
        if (task != null) {
          task.isActive = false;
          await taskBox.put(key, task);
        }
      }

      // Assert
      final updatedTask = taskBox.get('test_task');
      expect(updatedTask?.isActive, false);
    });

    test('should preserve active future tasks', () async {
      // Arrange
      final futureTime = DateTime.now().add(const Duration(hours: 2));
      final task = Task(
        id: 'future_task',
        title: 'Future Task',
        description: 'Future Description',
        isActive: true,
        deleteWhenExpired: false,
        notificationTime: [futureTime],
        enableRecurring: false,
        recurrenceCount: 1,
      );

      await taskBox.put(task.id, task);

      // Act - Simulate background task logic
      final currentTime = DateTime.now();
      final tasksToUpdate = taskBox.keys.where((key) {
        final task = taskBox.get(key);
        if (task != null && task.notificationTime.isNotEmpty && task.isActive) {
          final hasExpiredTime = task.notificationTime
              .any((dateTime) => dateTime.isBefore(currentTime));

          bool shouldExpire = false;
          if (task.enableRecurring) {
            if (task.recurrenceEndDate != null) {
              shouldExpire = task.recurrenceEndDate!.isBefore(currentTime) && hasExpiredTime;
            }
          } else {
            shouldExpire = hasExpiredTime;
          }
          return shouldExpire;
        }
        return false;
      }).toList();

      // Assert - No tasks should be marked for deactivation
      expect(tasksToUpdate.isEmpty, true);

      // Task should remain active
      final updatedTask = taskBox.get('future_task');
      expect(updatedTask?.isActive, true);
    });

    test('should handle recurring tasks correctly', () async {
      // Arrange - Recurring task with end date in past
      final pastTime = DateTime.now().subtract(const Duration(hours: 2));
      final endDate = DateTime.now().subtract(const Duration(hours: 1));
      final task = Task(
        id: 'expired_recurring',
        title: 'Expired Recurring',
        description: 'Expired Recurring Description',
        isActive: true,
        deleteWhenExpired: false,
        notificationTime: [pastTime],
        enableRecurring: true,
        recurrenceCount: 5,
        recurrenceEndDate: endDate,
      );

      await taskBox.put(task.id, task);

      // Act - Simulate background task logic
      final currentTime = DateTime.now();
      final tasksToUpdate = taskBox.keys.where((key) {
        final task = taskBox.get(key);
        if (task != null && task.notificationTime.isNotEmpty && task.isActive) {
          final hasExpiredTime = task.notificationTime
              .any((dateTime) => dateTime.isBefore(currentTime));

          bool shouldExpire = false;
          if (task.enableRecurring) {
            if (task.recurrenceEndDate != null) {
              shouldExpire = task.recurrenceEndDate!.isBefore(currentTime) && hasExpiredTime;
            }
          } else {
            shouldExpire = hasExpiredTime;
          }
          return shouldExpire;
        }
        return false;
      }).toList();

      // Deactivate tasks
      for (var key in tasksToUpdate) {
        final task = taskBox.get(key);
        if (task != null) {
          task.isActive = false;
          await taskBox.put(key, task);
        }
      }

      // Assert - Recurring task with past end date should be deactivated
      final updatedTask = taskBox.get('expired_recurring');
      expect(updatedTask?.isActive, false);
    });

    test('should preserve infinite recurring tasks', () async {
      // Arrange - Infinite recurring task (no end date)
      final pastTime = DateTime.now().subtract(const Duration(hours: 2));
      final task = Task(
        id: 'infinite_recurring',
        title: 'Infinite Recurring',
        description: 'Infinite Recurring Description',
        isActive: true,
        deleteWhenExpired: false,
        notificationTime: [pastTime],
        enableRecurring: true,
        recurrenceCount: 5,
        recurrenceEndDate: null, // No end date = infinite
      );

      await taskBox.put(task.id, task);

      // Act - Simulate background task logic
      final currentTime = DateTime.now();
      final tasksToUpdate = taskBox.keys.where((key) {
        final task = taskBox.get(key);
        if (task != null && task.notificationTime.isNotEmpty && task.isActive) {
          final hasExpiredTime = task.notificationTime
              .any((dateTime) => dateTime.isBefore(currentTime));

          bool shouldExpire = false;
          if (task.enableRecurring) {
            if (task.recurrenceEndDate != null) {
              shouldExpire = task.recurrenceEndDate!.isBefore(currentTime) && hasExpiredTime;
            }
          } else {
            shouldExpire = hasExpiredTime;
          }
          return shouldExpire;
        }
        return false;
      }).toList();

      // Assert - Infinite recurring task should NOT be marked for deactivation
      expect(tasksToUpdate.isEmpty, true);

      // Task should remain active
      final updatedTask = taskBox.get('infinite_recurring');
      expect(updatedTask?.isActive, true);
    });

    test('should delete inactive tasks marked for deletion', () async {
      // Arrange
      final task = Task(
        id: 'delete_task',
        title: 'Delete Task',
        description: 'Should be deleted',
        isActive: false, // Already inactive
        deleteWhenExpired: true, // Marked for deletion
        notificationTime: [DateTime.now()],
        enableRecurring: false,
        recurrenceCount: 1,
      );

      await taskBox.put(task.id, task);

      // Act - Simulate deletion logic
      final keysToDelete = taskBox.keys.where((key) {
        final task = taskBox.get(key);
        return task != null && !task.isActive && task.deleteWhenExpired;
      }).toList();

      for (var key in keysToDelete) {
        await taskBox.delete(key);
      }

      // Assert
      expect(taskBox.containsKey('delete_task'), false);
    });
  });
}