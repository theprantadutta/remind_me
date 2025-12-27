import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part '../generated/entities/tag.g.dart';

/// Task tag for additional organization
@JsonSerializable()
class Tag extends HiveObject {
  Tag({
    required this.id,
    required this.name,
    required this.colorValue,
  });

  /// Unique identifier
  final String id;

  /// Tag name
  final String name;

  /// Color stored as int
  final int colorValue;

  /// Get the Color object
  Color get color => Color(colorValue);

  /// Create a copy with modified fields
  Tag copyWith({
    String? id,
    String? name,
    int? colorValue,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
    );
  }

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);

  @override
  String toString() => 'Tag(id: $id, name: $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tag && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
