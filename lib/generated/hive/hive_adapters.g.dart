// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../hive/hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final typeId = 0;

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
      enableAlarm: fields[15] == null ? false : fields[15] as bool,
      categoryId: fields[16] as String?,
      priority: fields[17] == null ? Priority.medium : fields[17] as Priority,
      tagIds: (fields[18] as List?)?.cast<String>(),
      isCompleted: fields[19] == null ? false : fields[19] as bool,
      completedAt: fields[20] as DateTime?,
      createdAt: fields[21] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(17)
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
      ..write(obj.recurrenceCount)
      ..writeByte(15)
      ..write(obj.enableAlarm)
      ..writeByte(16)
      ..write(obj.categoryId)
      ..writeByte(17)
      ..write(obj.priority)
      ..writeByte(18)
      ..write(obj.tagIds)
      ..writeByte(19)
      ..write(obj.isCompleted)
      ..writeByte(20)
      ..write(obj.completedAt)
      ..writeByte(21)
      ..write(obj.createdAt);
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

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final typeId = 1;

  @override
  Category read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Category(
      id: fields[0] as String,
      name: fields[1] as String,
      colorValue: (fields[2] as num).toInt(),
      iconCodePoint: (fields[3] as num).toInt(),
      isCustom: fields[4] == null ? true : fields[4] as bool,
      taskCount: fields[5] == null ? 0 : (fields[5] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.colorValue)
      ..writeByte(3)
      ..write(obj.iconCodePoint)
      ..writeByte(4)
      ..write(obj.isCustom)
      ..writeByte(5)
      ..write(obj.taskCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TagAdapter extends TypeAdapter<Tag> {
  @override
  final typeId = 2;

  @override
  Tag read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tag(
      id: fields[0] as String,
      name: fields[1] as String,
      colorValue: (fields[2] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, Tag obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.colorValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CompletedTaskAdapter extends TypeAdapter<CompletedTask> {
  @override
  final typeId = 3;

  @override
  CompletedTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompletedTask(
      id: fields[0] as String,
      originalTaskId: fields[1] as String,
      title: fields[2] as String,
      description: fields[3] as String,
      completedAt: fields[4] as DateTime,
      originalNotificationTime: (fields[5] as List).cast<DateTime>(),
      categoryId: fields[6] as String?,
      priority: fields[7] as Priority?,
      tagIds: (fields[8] as List?)?.cast<String>(),
      createdAt: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CompletedTask obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.originalTaskId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.completedAt)
      ..writeByte(5)
      ..write(obj.originalNotificationTime)
      ..writeByte(6)
      ..write(obj.categoryId)
      ..writeByte(7)
      ..write(obj.priority)
      ..writeByte(8)
      ..write(obj.tagIds)
      ..writeByte(9)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompletedTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DailyStatsAdapter extends TypeAdapter<DailyStats> {
  @override
  final typeId = 4;

  @override
  DailyStats read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyStats(
      date: fields[0] as DateTime,
      tasksCompleted: fields[1] == null ? 0 : (fields[1] as num).toInt(),
      tasksCreated: fields[2] == null ? 0 : (fields[2] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, DailyStats obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.tasksCompleted)
      ..writeByte(2)
      ..write(obj.tasksCreated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyStatsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PriorityAdapter extends TypeAdapter<Priority> {
  @override
  final typeId = 5;

  @override
  Priority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Priority.high;
      case 1:
        return Priority.medium;
      case 2:
        return Priority.low;
      default:
        return Priority.high;
    }
  }

  @override
  void write(BinaryWriter writer, Priority obj) {
    switch (obj) {
      case Priority.high:
        writer.writeByte(0);
      case Priority.medium:
        writer.writeByte(1);
      case Priority.low:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
