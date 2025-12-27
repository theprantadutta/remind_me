import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part '../generated/entities/category.g.dart';

/// Task category for organization
@JsonSerializable()
class Category extends HiveObject {
  Category({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.iconCodePoint,
    this.isCustom = true,
    this.taskCount = 0,
  });

  /// Unique identifier
  final String id;

  /// Category name
  final String name;

  /// Color stored as int (use Color(colorValue) to convert)
  final int colorValue;

  /// Icon code point (use IconData(iconCodePoint, fontFamily: 'MaterialIcons'))
  final int iconCodePoint;

  /// Whether this is a custom user-created category
  final bool isCustom;

  /// Number of tasks in this category (computed, not stored)
  @JsonKey(includeFromJson: false, includeToJson: false)
  int taskCount;

  /// Get the Color object
  Color get color => Color(colorValue);

  /// Get the IconData object
  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');

  /// Create a copy with modified fields
  Category copyWith({
    String? id,
    String? name,
    int? colorValue,
    int? iconCodePoint,
    bool? isCustom,
    int? taskCount,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      isCustom: isCustom ?? this.isCustom,
      taskCount: taskCount ?? this.taskCount,
    );
  }

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  @override
  String toString() => 'Category(id: $id, name: $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Predefined categories
class PredefinedCategories {
  static List<Category> get all => [
        Category(
          id: 'work',
          name: 'Work',
          colorValue: 0xFF6366F1,
          iconCodePoint: Icons.work.codePoint,
          isCustom: false,
        ),
        Category(
          id: 'personal',
          name: 'Personal',
          colorValue: 0xFF8B5CF6,
          iconCodePoint: Icons.person.codePoint,
          isCustom: false,
        ),
        Category(
          id: 'health',
          name: 'Health',
          colorValue: 0xFF10B981,
          iconCodePoint: Icons.favorite.codePoint,
          isCustom: false,
        ),
        Category(
          id: 'finance',
          name: 'Finance',
          colorValue: 0xFFF59E0B,
          iconCodePoint: Icons.attach_money.codePoint,
          isCustom: false,
        ),
        Category(
          id: 'shopping',
          name: 'Shopping',
          colorValue: 0xFFEF4444,
          iconCodePoint: Icons.shopping_cart.codePoint,
          isCustom: false,
        ),
        Category(
          id: 'education',
          name: 'Education',
          colorValue: 0xFF3B82F6,
          iconCodePoint: Icons.school.codePoint,
          isCustom: false,
        ),
        Category(
          id: 'travel',
          name: 'Travel',
          colorValue: 0xFF06B6D4,
          iconCodePoint: Icons.flight.codePoint,
          isCustom: false,
        ),
        Category(
          id: 'home',
          name: 'Home',
          colorValue: 0xFFEC4899,
          iconCodePoint: Icons.home.codePoint,
          isCustom: false,
        ),
      ];

  static Category? getById(String id) {
    try {
      return all.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
