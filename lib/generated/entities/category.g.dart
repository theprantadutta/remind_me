// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../entities/category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: json['id'] as String,
      name: json['name'] as String,
      colorValue: (json['colorValue'] as num).toInt(),
      iconCodePoint: (json['iconCodePoint'] as num).toInt(),
      isCustom: json['isCustom'] as bool? ?? true,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'colorValue': instance.colorValue,
      'iconCodePoint': instance.iconCodePoint,
      'isCustom': instance.isCustom,
    };
