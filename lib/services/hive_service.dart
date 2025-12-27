import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:remind_me/hive/hive_registrar.g.dart';

import '../entities/category.dart';
import '../entities/completed_task.dart';
import '../entities/daily_stats.dart';
import '../entities/tag.dart';
import '../entities/task.dart';
import '../hive/hive_boxes.dart';

class HiveService {
  static HiveService? _instance;
  static HiveService get instance => _instance ??= HiveService._();
  HiveService._();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    await Hive.initFlutter();
    Hive.registerAdapters();

    // Open all boxes
    await Future.wait([
      Hive.openBox<Task>(taskBoxKey),
      Hive.openBox<Category>(categoryBoxKey),
      Hive.openBox<Tag>(tagBoxKey),
      Hive.openBox<CompletedTask>(completedTaskBoxKey),
      Hive.openBox<DailyStats>(dailyStatsBoxKey),
    ]);

    _isInitialized = true;
  }

  /// Get the tasks box
  Box<Task> get tasksBox => Hive.box<Task>(taskBoxKey);

  /// Get the categories box
  Box<Category> get categoriesBox => Hive.box<Category>(categoryBoxKey);

  /// Get the tags box
  Box<Tag> get tagsBox => Hive.box<Tag>(tagBoxKey);

  /// Get the completed tasks box
  Box<CompletedTask> get completedTasksBox =>
      Hive.box<CompletedTask>(completedTaskBoxKey);

  /// Get the daily stats box
  Box<DailyStats> get dailyStatsBox => Hive.box<DailyStats>(dailyStatsBoxKey);
}
