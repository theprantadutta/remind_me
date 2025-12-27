// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../entities/daily_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyStats _$DailyStatsFromJson(Map<String, dynamic> json) => DailyStats(
      date: DateTime.parse(json['date'] as String),
      tasksCompleted: (json['tasksCompleted'] as num?)?.toInt() ?? 0,
      tasksCreated: (json['tasksCreated'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$DailyStatsToJson(DailyStats instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'tasksCompleted': instance.tasksCompleted,
      'tasksCreated': instance.tasksCreated,
    };
