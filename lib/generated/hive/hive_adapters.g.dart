// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../hive/hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[4] as String,
      isActive: fields[5] == null ? true : fields[5] as bool,
      deleteWhenExpired: fields[12] as bool,
      notificationTime: (fields[6] as List).cast<DateTime>(),
      enableRecurring: fields[13] as bool,
      recurrenceCount: (fields[14] as num?)?.toInt(),
      recurrenceIntervalInSeconds: (fields[11] as num?)?.toInt(),
      recurrenceEndDate: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.isActive)
      ..writeByte(6)
      ..write(obj.notificationTime)
      ..writeByte(10)
      ..write(obj.recurrenceEndDate)
      ..writeByte(11)
      ..write(obj.recurrenceIntervalInSeconds)
      ..writeByte(12)
      ..write(obj.deleteWhenExpired)
      ..writeByte(13)
      ..write(obj.enableRecurring)
      ..writeByte(14)
      ..write(obj.recurrenceCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
