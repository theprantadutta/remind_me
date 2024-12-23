import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part '../generated/entities/task.g.dart';

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
  });

  final String id;
  final String title;
  final String description;
  bool isActive;
  final List<DateTime> notificationTime;

  final bool deleteWhenExpired;

  // Recurrence settings
  final bool enableRecurring;
  final int? recurrenceIntervalInSeconds; // Interval for recurrence in seconds
  final int? recurrenceCount; // how many interval count should be here
  final DateTime? recurrenceEndDate; // Optional end date for recurrence

  /// Connect the generated [_$TaskFromJson] function to the `fromJson`
  /// factory.
  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  /// Connect the generated [_$TaskToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
