import 'package:flutter/foundation.dart' hide Category;

import '../entities/category.dart';
import '../entities/task.dart';
import '../services/category_service.dart';

/// Provider for managing categories and category-related state
class CategoryProvider extends ChangeNotifier {
  List<Category> _categories = [];
  List<Category> get categories => _categories;

  Category? _selectedCategory;
  Category? get selectedCategory => _selectedCategory;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Load all categories
  void loadCategories() {
    _categories = CategoryService.instance.getAllCategoriesWithCounts();
    notifyListeners();
  }

  /// Get predefined categories
  List<Category> get predefinedCategories =>
      CategoryService.instance.getPredefinedCategories();

  /// Get custom categories
  List<Category> get customCategories =>
      CategoryService.instance.getCustomCategories();

  /// Select a category
  void selectCategory(Category? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// Get category by ID
  Category? getCategoryById(String id) {
    return CategoryService.instance.getCategoryById(id);
  }

  /// Create a new category
  Future<Category?> createCategory({
    required String name,
    required int colorValue,
    required int iconCodePoint,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final category = await CategoryService.instance.createCategory(
        name: name,
        colorValue: colorValue,
        iconCodePoint: iconCodePoint,
      );
      loadCategories();
      return category;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update a category
  Future<Category?> updateCategory({
    required String id,
    String? name,
    int? colorValue,
    int? iconCodePoint,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final category = await CategoryService.instance.updateCategory(
        id: id,
        name: name,
        colorValue: colorValue,
        iconCodePoint: iconCodePoint,
      );
      loadCategories();
      return category;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete a category
  Future<bool> deleteCategory(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await CategoryService.instance.deleteCategory(id);
      if (result) {
        if (_selectedCategory?.id == id) {
          _selectedCategory = null;
        }
        loadCategories();
      }
      return result;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get task count for a category
  int getTaskCount(String categoryId) {
    return CategoryService.instance.getTaskCountForCategory(categoryId);
  }

  /// Get tasks in a category
  List<Task> getTasksInCategory(String categoryId) {
    return CategoryService.instance.getTasksInCategory(categoryId);
  }
}
