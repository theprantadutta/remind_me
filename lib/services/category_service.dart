import 'package:uuid/uuid.dart';

import '../entities/category.dart';
import '../entities/task.dart';
import 'hive_service.dart';
import 'logger_service.dart';

/// Service for managing task categories
class CategoryService {
  static CategoryService? _instance;
  static CategoryService get instance => _instance ??= CategoryService._();
  CategoryService._();

  final _logger = LoggerService.instance;
  final _uuid = const Uuid();

  /// Initialize predefined categories if not already present
  Future<void> initializePredefinedCategories() async {
    final box = HiveService.instance.categoriesBox;

    for (final category in PredefinedCategories.all) {
      if (!box.containsKey(category.id)) {
        await box.put(category.id, category);
        _logger.debug('Initialized predefined category: ${category.name}',
            tag: 'CategoryService');
      }
    }
  }

  /// Get all categories (predefined + custom)
  List<Category> getAllCategories() {
    return HiveService.instance.categoriesBox.values.toList()
      ..sort((a, b) {
        // Predefined categories first, then custom sorted by name
        if (a.isCustom != b.isCustom) {
          return a.isCustom ? 1 : -1;
        }
        return a.name.compareTo(b.name);
      });
  }

  /// Get only custom categories
  List<Category> getCustomCategories() {
    return HiveService.instance.categoriesBox.values
        .where((c) => c.isCustom)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  /// Get only predefined categories
  List<Category> getPredefinedCategories() {
    return HiveService.instance.categoriesBox.values
        .where((c) => !c.isCustom)
        .toList();
  }

  /// Get category by ID
  Category? getCategoryById(String id) {
    return HiveService.instance.categoriesBox.get(id);
  }

  /// Create a new custom category
  Future<Category> createCategory({
    required String name,
    required int colorValue,
    required int iconCodePoint,
  }) async {
    final category = Category(
      id: _uuid.v4(),
      name: name,
      colorValue: colorValue,
      iconCodePoint: iconCodePoint,
      isCustom: true,
    );

    await HiveService.instance.categoriesBox.put(category.id, category);
    _logger.info('Created custom category: ${category.name}',
        tag: 'CategoryService');

    return category;
  }

  /// Update an existing category
  Future<Category?> updateCategory({
    required String id,
    String? name,
    int? colorValue,
    int? iconCodePoint,
  }) async {
    final existing = getCategoryById(id);
    if (existing == null) {
      _logger.warning('Category not found for update: $id',
          tag: 'CategoryService');
      return null;
    }

    // Only allow updating custom categories
    if (!existing.isCustom) {
      _logger.warning('Cannot update predefined category: $id',
          tag: 'CategoryService');
      return null;
    }

    final updated = existing.copyWith(
      name: name,
      colorValue: colorValue,
      iconCodePoint: iconCodePoint,
    );

    await HiveService.instance.categoriesBox.put(id, updated);
    _logger.info('Updated category: ${updated.name}', tag: 'CategoryService');

    return updated;
  }

  /// Delete a custom category
  Future<bool> deleteCategory(String id) async {
    final existing = getCategoryById(id);
    if (existing == null) {
      return false;
    }

    // Only allow deleting custom categories
    if (!existing.isCustom) {
      _logger.warning('Cannot delete predefined category: $id',
          tag: 'CategoryService');
      return false;
    }

    // Remove category from all tasks that use it
    final tasksBox = HiveService.instance.tasksBox;
    for (final task in tasksBox.values) {
      if (task.categoryId == id) {
        final updated = task.copyWith(clearCategoryId: true);
        await tasksBox.put(task.id, updated);
      }
    }

    await HiveService.instance.categoriesBox.delete(id);
    _logger.info('Deleted category: ${existing.name}', tag: 'CategoryService');

    return true;
  }

  /// Get task count for a category
  int getTaskCountForCategory(String categoryId) {
    return HiveService.instance.tasksBox.values
        .where((t) => t.categoryId == categoryId && !t.isCompleted)
        .length;
  }

  /// Get all categories with their task counts populated
  List<Category> getAllCategoriesWithCounts() {
    final categories = getAllCategories();
    for (final category in categories) {
      category.taskCount = getTaskCountForCategory(category.id);
    }
    return categories;
  }

  /// Get tasks in a category
  List<Task> getTasksInCategory(String categoryId) {
    return HiveService.instance.tasksBox.values
        .where((t) => t.categoryId == categoryId)
        .toList();
  }
}
