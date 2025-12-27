// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../entities/completed_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompletedTask _$CompletedTaskFromJson(Map<String, dynamic> json) =>
    CompletedTask(
      id: json['id'] as String,
      originalTaskId: json['originalTaskId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      completedAt: DateTime.parse(json['completedAt'] as String),
      originalNotificationTime:
          (json['originalNotificationTime'] as List<dynamic>)
              .map((e) => DateTime.parse(e as String))
              .toList(),
      categoryId: json['categoryId'] as String?,
      priority: $enumDecodeNullable(_$PriorityEnumMap, json['priority']),
      tagIds:
          (json['tagIds'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CompletedTaskToJson(CompletedTask instance) =>
    <String, dynamic>{
      'id': instance.id,
      'originalTaskId': instance.originalTaskId,
      'title': instance.title,
      'description': instance.description,
      'completedAt': instance.completedAt.toIso8601String(),
      'originalNotificationTime': instance.originalNotificationTime
          .map((e) => e.toIso8601String())
          .toList(),
      'categoryId': instance.categoryId,
      'priority': _$PriorityEnumMap[instance.priority],
      'tagIds': instance.tagIds,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$PriorityEnumMap = {
  Priority.high: 'high',
  Priority.medium: 'medium',
  Priority.low: 'low',
};
