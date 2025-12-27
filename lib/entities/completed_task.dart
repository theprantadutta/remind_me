import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../enums/priority.dart';

part '../generated/entities/completed_task.g.dart';

/// Archived completed task for history tracking
@JsonSerializable()
class CompletedTask extends HiveObject {
  CompletedTask({
    required this.id,
    required this.originalTaskId,
    required this.title,
    required this.description,
    required this.completedAt,
    required this.originalNotificationTime,
    this.categoryId,
    this.priority,
    this.tagIds,
    this.createdAt,
  });

  /// Unique identifier for this completed task record
  final String id;

  /// ID of the original task
  final String originalTaskId;

  /// Task title
  final String title;

  /// Task description
  final String description;

  /// When the task was completed
  final DateTime completedAt;

  /// Original notification times
  final List<DateTime> originalNotificationTime;

  /// Category ID if assigned
  final String? categoryId;

  /// Priority level
  final Priority? priority;

  /// Tag IDs if assigned
  final List<String>? tagIds;

  /// When the original task was created
  final DateTime? createdAt;

  factory CompletedTask.fromJson(Map<String, dynamic> json) =>
      _$CompletedTaskFromJson(json);

  Map<String, dynamic> toJson() => _$CompletedTaskToJson(this);

  @override
  String toString() =>
      'CompletedTask(id: $id, title: $title, completedAt: $completedAt)';
}
