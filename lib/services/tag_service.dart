import 'package:uuid/uuid.dart';

import '../entities/tag.dart';
import '../entities/task.dart';
import 'hive_service.dart';
import 'logger_service.dart';

/// Service for managing task tags
class TagService {
  static TagService? _instance;
  static TagService get instance => _instance ??= TagService._();
  TagService._();

  final _logger = LoggerService.instance;
  final _uuid = const Uuid();

  /// Get all tags
  List<Tag> getAllTags() {
    return HiveService.instance.tagsBox.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  /// Get tag by ID
  Tag? getTagById(String id) {
    return HiveService.instance.tagsBox.get(id);
  }

  /// Get multiple tags by IDs
  List<Tag> getTagsByIds(List<String> ids) {
    return ids.map((id) => getTagById(id)).whereType<Tag>().toList();
  }

  /// Create a new tag
  Future<Tag> createTag({
    required String name,
    required int colorValue,
  }) async {
    final tag = Tag(
      id: _uuid.v4(),
      name: name,
      colorValue: colorValue,
    );

    await HiveService.instance.tagsBox.put(tag.id, tag);
    _logger.info('Created tag: ${tag.name}', tag: 'TagService');

    return tag;
  }

  /// Update an existing tag
  Future<Tag?> updateTag({
    required String id,
    String? name,
    int? colorValue,
  }) async {
    final existing = getTagById(id);
    if (existing == null) {
      _logger.warning('Tag not found for update: $id', tag: 'TagService');
      return null;
    }

    final updated = existing.copyWith(
      name: name,
      colorValue: colorValue,
    );

    await HiveService.instance.tagsBox.put(id, updated);
    _logger.info('Updated tag: ${updated.name}', tag: 'TagService');

    return updated;
  }

  /// Delete a tag
  Future<bool> deleteTag(String id) async {
    final existing = getTagById(id);
    if (existing == null) {
      return false;
    }

    // Remove tag from all tasks that use it
    final tasksBox = HiveService.instance.tasksBox;
    for (final task in tasksBox.values) {
      if (task.tagIds?.contains(id) ?? false) {
        final updatedTagIds =
            task.tagIds!.where((tagId) => tagId != id).toList();
        final updated = task.copyWith(
          tagIds: updatedTagIds.isEmpty ? null : updatedTagIds,
        );
        await tasksBox.put(task.id, updated);
      }
    }

    await HiveService.instance.tagsBox.delete(id);
    _logger.info('Deleted tag: ${existing.name}', tag: 'TagService');

    return true;
  }

  /// Get task count for a tag
  int getTaskCountForTag(String tagId) {
    return HiveService.instance.tasksBox.values
        .where((t) => t.tagIds?.contains(tagId) ?? false)
        .length;
  }

  /// Get tasks with a specific tag
  List<Task> getTasksWithTag(String tagId) {
    return HiveService.instance.tasksBox.values
        .where((t) => t.tagIds?.contains(tagId) ?? false)
        .toList();
  }

  /// Check if a tag name already exists
  bool tagNameExists(String name) {
    return HiveService.instance.tagsBox.values
        .any((t) => t.name.toLowerCase() == name.toLowerCase());
  }
}
