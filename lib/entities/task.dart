import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../enums/priority.dart';

part '../generated/entities/task.g.dart';

/// Task entity representing a reminder/task
@JsonSerializable()
class Task extends HiveObject {
  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isActive = true,
    required this.deleteWhenExpired,
    required this.notificationTime,
    required this.enableRecurring,
    required this.recurrenceCount,
    this.recurrenceIntervalInSeconds,
    this.recurrenceEndDate,
    this.enableAlarm = false,
    // New fields
    this.categoryId,
    this.priority = Priority.medium,
    this.tagIds,
    this.isCompleted = false,
    this.completedAt,
    this.createdAt,
  });

  /// Unique identifier
  final String id;

  /// Task title
  final String title;

  /// Task description
  final String description;

  /// Whether the task is active
  bool isActive;

  /// Notification times for this task
  final List<DateTime> notificationTime;

  /// Whether to delete when expired
  final bool deleteWhenExpired;

  /// Whether recurring is enabled
  final bool enableRecurring;

  /// Interval for recurrence in seconds
  final int? recurrenceIntervalInSeconds;

  /// How many times to recur
  final int? recurrenceCount;

  /// Optional end date for recurrence
  final DateTime? recurrenceEndDate;

  /// Whether to show full-screen alarm
  final bool enableAlarm;

  // ============ New Fields ============

  /// Category ID for organization
  final String? categoryId;

  /// Task priority level
  final Priority priority;

  /// Tag IDs for additional organization
  final List<String>? tagIds;

  /// Whether the task is completed
  bool isCompleted;

  /// When the task was completed
  DateTime? completedAt;

  /// When the task was created
  final DateTime? createdAt;

  /// Mark task as completed
  void markCompleted() {
    isCompleted = true;
    completedAt = DateTime.now();
    isActive = false;
  }

  /// Mark task as incomplete
  void markIncomplete() {
    isCompleted = false;
    completedAt = null;
  }

  /// Create a copy with modified fields
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isActive,
    List<DateTime>? notificationTime,
    bool? deleteWhenExpired,
    bool? enableRecurring,
    int? recurrenceIntervalInSeconds,
    int? recurrenceCount,
    DateTime? recurrenceEndDate,
    bool? enableAlarm,
    String? categoryId,
    Priority? priority,
    List<String>? tagIds,
    bool? isCompleted,
    DateTime? completedAt,
    DateTime? createdAt,
    // Flags to clear nullable fields
    bool clearCategoryId = false,
    bool clearCompletedAt = false,
    bool clearTagIds = false,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      notificationTime: notificationTime ?? this.notificationTime,
      deleteWhenExpired: deleteWhenExpired ?? this.deleteWhenExpired,
      enableRecurring: enableRecurring ?? this.enableRecurring,
      recurrenceIntervalInSeconds:
          recurrenceIntervalInSeconds ?? this.recurrenceIntervalInSeconds,
      recurrenceCount: recurrenceCount ?? this.recurrenceCount,
      recurrenceEndDate: recurrenceEndDate ?? this.recurrenceEndDate,
      enableAlarm: enableAlarm ?? this.enableAlarm,
      categoryId: clearCategoryId ? null : (categoryId ?? this.categoryId),
      priority: priority ?? this.priority,
      tagIds: clearTagIds ? null : (tagIds ?? this.tagIds),
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);

  @override
  String toString() => 'Task(id: $id, title: $title, isActive: $isActive)';
}
