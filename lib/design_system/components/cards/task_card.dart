import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../entities/category.dart';
import '../../../entities/task.dart';
import '../../../services/category_service.dart';
import '../../tokens/borders.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

// Convenience alias
typedef AppBorders = AppBorderRadius;

/// Modern task card component
class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onComplete,
    this.onDelete,
    this.showCategory = true,
    this.showPriority = true,
    this.compact = false,
  });

  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;
  final VoidCallback? onDelete;
  final bool showCategory;
  final bool showPriority;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Get next upcoming notification time
    final now = DateTime.now();
    final upcomingTimes = task.notificationTime.where((t) => t.isAfter(now));
    final nextTime = upcomingTimes.isNotEmpty
        ? upcomingTimes.reduce((a, b) => a.isBefore(b) ? a : b)
        : task.notificationTime.isNotEmpty
            ? task.notificationTime.reduce((a, b) => a.isBefore(b) ? a : b)
            : null;
    final isOverdue = nextTime != null && nextTime.isBefore(now) && !task.isCompleted;

    // Get category if available
    Category? category;
    if (task.categoryId != null) {
      category = CategoryService.instance.getCategoryById(task.categoryId!);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: AppBorders.radiusMd,
        color: task.isCompleted
            ? colorScheme.surfaceContainerLow.withValues(alpha: 0.5)
            : colorScheme.surfaceContainer,
        border: isOverdue
            ? Border.all(color: colorScheme.error.withValues(alpha: 0.5), width: 1)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppBorders.radiusMd,
          child: Padding(
            padding: compact ? AppEdgeInsets.sm : AppEdgeInsets.md,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox
                _buildCheckbox(context, colorScheme),
                AppGaps.md,
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title row with priority indicator
                      Row(
                        children: [
                          if (showPriority) ...[
                            _buildPriorityIndicator(context),
                            AppGaps.xs,
                          ],
                          Expanded(
                            child: Text(
                              task.title,
                              style: (compact
                                      ? AppTypography.bodyMedium
                                      : AppTypography.titleSmall)
                                  .copyWith(
                                color: task.isCompleted
                                    ? colorScheme.onSurfaceVariant
                                    : colorScheme.onSurface,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                              maxLines: compact ? 1 : 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      // Description
                      if (!compact && task.description.isNotEmpty) ...[
                        AppGaps.xs,
                        Text(
                          task.description,
                          style: AppTypography.bodySmall.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      // Metadata row
                      AppGaps.sm,
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.xs,
                        children: [
                          // Time
                          if (nextTime != null)
                            _buildChip(
                              context,
                              icon: Icons.access_time,
                              label: _formatTime(nextTime),
                              color: isOverdue ? colorScheme.error : null,
                            ),
                          // Category
                          if (showCategory && category != null)
                            _buildChip(
                              context,
                              icon: category.icon,
                              label: category.name,
                              color: category.color,
                            ),
                          // Alarm indicator
                          if (task.enableAlarm)
                            _buildChip(
                              context,
                              icon: Icons.alarm,
                              label: 'Alarm',
                            ),
                          // Recurring indicator
                          if (task.enableRecurring)
                            _buildChip(
                              context,
                              icon: Icons.repeat,
                              label: 'Recurring',
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(BuildContext context, ColorScheme colorScheme) {
    return GestureDetector(
      onTap: onComplete,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: task.isCompleted
              ? task.priority.color
              : Colors.transparent,
          border: Border.all(
            color: task.isCompleted
                ? task.priority.color
                : colorScheme.outline,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: task.isCompleted
            ? Icon(
                Icons.check,
                size: 16,
                color: colorScheme.surface,
              )
            : null,
      ),
    );
  }

  Widget _buildPriorityIndicator(BuildContext context) {
    return Container(
      width: 4,
      height: 16,
      decoration: BoxDecoration(
        color: task.priority.color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    Color? color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final chipColor = color ?? colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: chipColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: chipColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final timeDate = DateTime(time.year, time.month, time.day);

    final timeFormat = DateFormat.jm();

    if (timeDate == today) {
      return 'Today ${timeFormat.format(time)}';
    } else if (timeDate == tomorrow) {
      return 'Tomorrow ${timeFormat.format(time)}';
    } else if (time.year == now.year) {
      return DateFormat.MMMd().add_jm().format(time);
    } else {
      return DateFormat.yMMMd().add_jm().format(time);
    }
  }
}
