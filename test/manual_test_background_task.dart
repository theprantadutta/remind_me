import 'dart:async';
import 'dart:io';
import 'package:hive_ce/hive.dart';
import 'package:intl/intl.dart';
import 'package:remind_me/entities/task.dart';
import 'package:remind_me/hive/hive_boxes.dart';
import 'package:remind_me/hive/hive_registrar.g.dart';

/// Manual test script to verify background task functionality
/// Run this to test the background task logic without the full app
void main() async {
  // Create temporary directory for testing
  final tempDir = Directory.systemTemp.createTempSync('hive_test');
  Hive.init(tempDir.path);

  // Register adapters
  Hive.registerAdapters();

  // Open task box
  final taskBox = await Hive.openBox<Task>(taskBoxKey);

  print('🧪 Starting Background Task Manual Test');
  print('=' * 50);

  // Clear existing tasks
  await taskBox.clear();

  // Create test data
  await createTestTasks(taskBox);

  // Run the background task logic
  await runBackgroundTaskSimulation(taskBox);

  // Verify results
  await verifyResults(taskBox);

  await taskBox.close();
  await Hive.close();

  // Clean up temporary directory
  if (tempDir.existsSync()) {
    tempDir.deleteSync(recursive: true);
  }

  print('\n✅ Manual test completed!');
}

Future<void> createTestTasks(Box<Task> taskBox) async {
  final now = DateTime.now();
  print('\n📝 Creating test tasks...');

  // 1. Expired non-recurring task (should be deactivated)
  final expiredTask = Task(
    id: 'expired_non_recurring',
    title: 'Expired Non-Recurring Task',
    description: 'Should be deactivated',
    isActive: true,
    deleteWhenExpired: false,
    notificationTime: [now.subtract(const Duration(hours: 2))],
    enableRecurring: false,
    recurrenceCount: 1,
  );
  await taskBox.put(expiredTask.id, expiredTask);
  print('✅ Created expired non-recurring task');

  // 2. Expired task marked for deletion (should be deleted)
  final expiredDeleteTask = Task(
    id: 'expired_delete',
    title: 'Expired Delete Task',
    description: 'Should be deleted',
    isActive: false, // Already inactive
    deleteWhenExpired: true,
    notificationTime: [now.subtract(const Duration(hours: 2))],
    enableRecurring: false,
    recurrenceCount: 1,
  );
  await taskBox.put(expiredDeleteTask.id, expiredDeleteTask);
  print('✅ Created expired task marked for deletion');

  // 3. Active future task (should remain active)
  final activeTask = Task(
    id: 'active_future',
    title: 'Active Future Task',
    description: 'Should remain active',
    isActive: true,
    deleteWhenExpired: false,
    notificationTime: [now.add(const Duration(hours: 2))],
    enableRecurring: false,
    recurrenceCount: 1,
  );
  await taskBox.put(activeTask.id, activeTask);
  print('✅ Created active future task');

  // 4. Expired recurring task with end date (should be deactivated)
  final expiredRecurring = Task(
    id: 'expired_recurring',
    title: 'Expired Recurring Task',
    description: 'Should be deactivated',
    isActive: true,
    deleteWhenExpired: false,
    notificationTime: [now.subtract(const Duration(hours: 2))],
    enableRecurring: true,
    recurrenceCount: 5,
    recurrenceEndDate: now.subtract(const Duration(hours: 1)),
  );
  await taskBox.put(expiredRecurring.id, expiredRecurring);
  print('✅ Created expired recurring task with end date');

  // 5. Infinite recurring task (should remain active)
  final infiniteRecurring = Task(
    id: 'infinite_recurring',
    title: 'Infinite Recurring Task',
    description: 'Should remain active',
    isActive: true,
    deleteWhenExpired: false,
    notificationTime: [now.subtract(const Duration(hours: 2))],
    enableRecurring: true,
    recurrenceCount: 5,
    recurrenceEndDate: null, // Infinite
  );
  await taskBox.put(infiniteRecurring.id, infiniteRecurring);
  print('✅ Created infinite recurring task');

  print('\n📊 Initial state:');
  for (var key in taskBox.keys) {
    final task = taskBox.get(key);
    if (task != null) {
      print(
          '  ${task.id}: Active=${task.isActive}, DeleteWhenExpired=${task.deleteWhenExpired}');
    }
  }
}

Future<void> runBackgroundTaskSimulation(Box<Task> taskBox) async {
  print('\n🔄 Running background task simulation...');

  final currentTime = DateTime.now();
  final formattedTime = DateFormat.yMEd().add_jms().format(currentTime);

  print('[$formattedTime] Starting background task simulation');

  // IMPROVED LOGIC: Check if ANY notification time is expired, not ALL
  final tasksToUpdate = taskBox.keys.where((key) {
    final task = taskBox.get(key);
    if (task != null && task.notificationTime.isNotEmpty && task.isActive) {
      // Check if task has expired notification times
      final hasExpiredTime = task.notificationTime
          .any((dateTime) => dateTime.isBefore(currentTime));

      // For recurring tasks, only expire if they have an end date and it's passed
      bool shouldExpire = false;
      if (task.enableRecurring) {
        if (task.recurrenceEndDate != null) {
          shouldExpire =
              task.recurrenceEndDate!.isBefore(currentTime) && hasExpiredTime;
        } else {
          // Infinite recurring tasks don't expire automatically
          shouldExpire = false;
        }
      } else {
        // Non-recurring tasks expire when their notification time passes
        shouldExpire = hasExpiredTime;
      }

      print('[$formattedTime] Task "${task.title}" - Expired: $shouldExpire');
      return shouldExpire;
    }
    return false;
  }).toList();

  print('[$formattedTime] Found ${tasksToUpdate.length} tasks to deactivate');

  // Deactivate expired tasks
  for (var key in tasksToUpdate) {
    final task = taskBox.get(key);
    if (task != null) {
      print('[$formattedTime] Deactivating: "${task.title}"');
      task.isActive = false;
      await taskBox.put(key, task);
    }
  }

  // Delete inactive tasks marked for auto-deletion
  final keysToDelete = taskBox.keys.where((key) {
    final task = taskBox.get(key);
    final shouldDelete =
        task != null && !task.isActive && task.deleteWhenExpired;
    if (shouldDelete) {
      print('[$formattedTime] Marked for deletion: "${task.title}"');
    }
    return shouldDelete;
  }).toList();

  print('[$formattedTime] Found ${keysToDelete.length} tasks to delete');

  for (var key in keysToDelete) {
    final task = taskBox.get(key);
    print('[$formattedTime] Deleting: "${task?.title}"');
    await taskBox.delete(key);
  }

  print('[$formattedTime] Background task simulation completed');
}

Future<void> verifyResults(Box<Task> taskBox) async {
  print('\n🔍 Verifying results...');

  print('\n📊 Final state:');
  int totalTasks = 0;
  int activeTasks = 0;
  int inactiveTasks = 0;

  for (var key in taskBox.keys) {
    final task = taskBox.get(key);
    if (task != null) {
      totalTasks++;
      if (task.isActive) {
        activeTasks++;
        print('  ✅ ${task.id}: ACTIVE');
      } else {
        inactiveTasks++;
        print('  ❌ ${task.id}: INACTIVE');
      }
    }
  }

  print('\n📈 Summary:');
  print('  Total tasks: $totalTasks');
  print('  Active tasks: $activeTasks');
  print('  Inactive tasks: $inactiveTasks');

  // Expected results verification
  print('\n🎯 Expected Results:');
  print('  ✅ expired_non_recurring: Should be INACTIVE (was deactivated)');
  print('  ✅ expired_delete: Should be DELETED (was removed)');
  print('  ✅ active_future: Should be ACTIVE (future task)');
  print('  ✅ expired_recurring: Should be INACTIVE (end date passed)');
  print('  ✅ infinite_recurring: Should be ACTIVE (infinite recurring)');

  // Check specific results
  final expiredNonRecurring = taskBox.get('expired_non_recurring');
  final expiredDelete = taskBox.get('expired_delete');
  final activeFuture = taskBox.get('active_future');
  final expiredRecurring = taskBox.get('expired_recurring');
  final infiniteRecurring = taskBox.get('infinite_recurring');

  print('\n🧪 Test Results:');
  print(
      '  expired_non_recurring: ${expiredNonRecurring?.isActive == false ? '✅ PASS' : '❌ FAIL'}');
  print('  expired_delete: ${expiredDelete == null ? '✅ PASS' : '❌ FAIL'}');
  print(
      '  active_future: ${activeFuture?.isActive == true ? '✅ PASS' : '❌ FAIL'}');
  print(
      '  expired_recurring: ${expiredRecurring?.isActive == false ? '✅ PASS' : '❌ FAIL'}');
  print(
      '  infinite_recurring: ${infiniteRecurring?.isActive == true ? '✅ PASS' : '❌ FAIL'}');
}
