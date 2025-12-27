import 'package:shared_preferences/shared_preferences.dart';

import 'category_service.dart';
import 'hive_service.dart';
import 'logger_service.dart';

/// Service for handling data migrations between app versions
class MigrationService {
  static MigrationService? _instance;
  static MigrationService get instance => _instance ??= MigrationService._();
  MigrationService._();

  static const String _schemaVersionKey = 'schema_version';
  static const int _currentSchemaVersion = 2;

  final _logger = LoggerService.instance;

  /// Run all necessary migrations
  Future<void> runMigrations() async {
    final prefs = await SharedPreferences.getInstance();
    final currentVersion = prefs.getInt(_schemaVersionKey) ?? 1;

    _logger.info(
        'Current schema version: $currentVersion, target: $_currentSchemaVersion',
        tag: 'MigrationService');

    if (currentVersion < _currentSchemaVersion) {
      // Run migrations sequentially
      if (currentVersion < 2) {
        await _migrateToV2();
      }

      // Save new version
      await prefs.setInt(_schemaVersionKey, _currentSchemaVersion);
      _logger.info('Migration completed to version $_currentSchemaVersion',
          tag: 'MigrationService');
    } else {
      _logger.debug('No migrations needed', tag: 'MigrationService');
    }

    // Always ensure predefined categories exist
    await CategoryService.instance.initializePredefinedCategories();
  }

  /// Migration to schema version 2
  /// - Adds default values for new fields in Task entity
  /// - priority defaults to Priority.medium
  /// - isCompleted defaults to false
  /// - createdAt defaults to current time for existing tasks
  Future<void> _migrateToV2() async {
    _logger.info('Running migration to v2', tag: 'MigrationService');

    final tasksBox = HiveService.instance.tasksBox;
    final tasks = tasksBox.values.toList();

    for (final task in tasks) {
      bool needsUpdate = false;

      // Check if task needs migration (created before v2 schema)
      // We can detect this by checking if createdAt is null
      if (task.createdAt == null) {
        needsUpdate = true;
      }

      if (needsUpdate) {
        // Update task with createdAt using copyWith
        final updatedTask = task.copyWith(
          createdAt: DateTime.now(),
        );

        await tasksBox.put(task.id, updatedTask);
        _logger.debug('Migrated task: ${task.id}', tag: 'MigrationService');
      }
    }

    _logger.info('Migration to v2 completed. Migrated ${tasks.length} tasks.',
        tag: 'MigrationService');
  }

  /// Check if migration is needed
  Future<bool> isMigrationNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final currentVersion = prefs.getInt(_schemaVersionKey) ?? 1;
    return currentVersion < _currentSchemaVersion;
  }

  /// Get current schema version
  Future<int> getCurrentSchemaVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_schemaVersionKey) ?? 1;
  }

  /// Reset schema version (for testing purposes)
  Future<void> resetSchemaVersion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_schemaVersionKey);
    _logger.warning('Schema version reset', tag: 'MigrationService');
  }
}
