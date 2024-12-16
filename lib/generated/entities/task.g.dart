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
      recurrenceType: json['recurrenceType'] as String,
      recurrenceIntervalInSeconds:
          (json['recurrenceIntervalInSeconds'] as num?)?.toInt(),
      recurrenceEndDate: json['recurrenceEndDate'] == null
          ? null
          : DateTime.parse(json['recurrenceEndDate'] as String),
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'isActive': instance.isActive,
      'notificationTime':
          instance.notificationTime.map((e) => e.toIso8601String()).toList(),
      'deleteWhenExpired': instance.deleteWhenExpired,
      'recurrenceType': instance.recurrenceType,
      'recurrenceIntervalInSeconds': instance.recurrenceIntervalInSeconds,
      'recurrenceEndDate': instance.recurrenceEndDate?.toIso8601String(),
    };
