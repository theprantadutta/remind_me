// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../entities/task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      isActive: json['isActive'] as bool? ?? true,
      deleteWhenExpired: json['deleteWhenExpired'] as bool,
      notificationTime: (json['notificationTime'] as List<dynamic>)
          .map((e) => DateTime.parse(e as String))
          .toList(),
      enableRecurring: json['enableRecurring'] as bool,
      recurrenceCount: (json['recurrenceCount'] as num?)?.toInt(),
      recurrenceIntervalInSeconds:
          (json['recurrenceIntervalInSeconds'] as num?)?.toInt(),
      recurrenceEndDate: json['recurrenceEndDate'] == null
          ? null
          : DateTime.parse(json['recurrenceEndDate'] as String),
      enableAlarm: json['enableAlarm'] as bool? ?? false,
      categoryId: json['categoryId'] as String?,
      priority: $enumDecodeNullable(_$PriorityEnumMap, json['priority']) ??
          Priority.medium,
      tagIds:
          (json['tagIds'] as List<dynamic>?)?.map((e) => e as String).toList(),
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'isActive': instance.isActive,
      'notificationTime':
          instance.notificationTime.map((e) => e.toIso8601String()).toList(),
      'deleteWhenExpired': instance.deleteWhenExpired,
      'enableRecurring': instance.enableRecurring,
      'recurrenceIntervalInSeconds': instance.recurrenceIntervalInSeconds,
      'recurrenceCount': instance.recurrenceCount,
      'recurrenceEndDate': instance.recurrenceEndDate?.toIso8601String(),
      'enableAlarm': instance.enableAlarm,
      'categoryId': instance.categoryId,
      'priority': _$PriorityEnumMap[instance.priority]!,
      'tagIds': instance.tagIds,
      'isCompleted': instance.isCompleted,
      'completedAt': instance.completedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$PriorityEnumMap = {
  Priority.high: 'high',
  Priority.medium: 'medium',
  Priority.low: 'low',
};
