import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part '../generated/entities/daily_stats.g.dart';

/// Daily statistics for tracking productivity
@JsonSerializable()
class DailyStats extends HiveObject {
  DailyStats({
    required this.date,
    this.tasksCompleted = 0,
    this.tasksCreated = 0,
  });

  /// Date (time component should be zeroed out)
  final DateTime date;

  /// Number of tasks completed on this date
  int tasksCompleted;

  /// Number of tasks created on this date
  int tasksCreated;

  /// Get a normalized date key (YYYY-MM-DD format)
  String get dateKey =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  /// Increment completed tasks count
  void incrementCompleted() {
    tasksCompleted++;
  }

  /// Increment created tasks count
  void incrementCreated() {
    tasksCreated++;
  }

  /// Create a copy with modified fields
  DailyStats copyWith({
    DateTime? date,
    int? tasksCompleted,
    int? tasksCreated,
  }) {
    return DailyStats(
      date: date ?? this.date,
      tasksCompleted: tasksCompleted ?? this.tasksCompleted,
      tasksCreated: tasksCreated ?? this.tasksCreated,
    );
  }

  factory DailyStats.fromJson(Map<String, dynamic> json) =>
      _$DailyStatsFromJson(json);

  Map<String, dynamic> toJson() => _$DailyStatsToJson(this);

  /// Create stats for today
  factory DailyStats.today() {
    final now = DateTime.now();
    return DailyStats(
      date: DateTime(now.year, now.month, now.day),
    );
  }

  /// Create stats for a specific date
  factory DailyStats.forDate(DateTime dateTime) {
    return DailyStats(
      date: DateTime(dateTime.year, dateTime.month, dateTime.day),
    );
  }

  @override
  String toString() =>
      'DailyStats(date: $dateKey, completed: $tasksCompleted, created: $tasksCreated)';
}
