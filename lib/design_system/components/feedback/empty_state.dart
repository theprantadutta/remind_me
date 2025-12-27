import 'package:flutter/material.dart';

import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Empty state widget for when lists have no items
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.action,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? description;
  final Widget? action;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: AppEdgeInsets.xl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: colorScheme.primary,
              ),
            ),
            AppGaps.lg,
            Text(
              title,
              style: AppTypography.titleMedium.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              AppGaps.sm,
              Text(
                description!,
                style: AppTypography.bodyMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              AppGaps.xl,
              action!,
            ] else if (actionLabel != null && onAction != null) ...[
              AppGaps.xl,
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Predefined empty states
class EmptyStates {
  /// No tasks empty state
  static EmptyState noTasks({VoidCallback? onCreateTask}) => EmptyState(
        icon: Icons.task_alt_outlined,
        title: 'No Tasks Yet',
        description: 'Create your first task to get started!',
        actionLabel: 'Create Task',
        onAction: onCreateTask,
      );

  /// No search results empty state
  static const EmptyState noSearchResults = EmptyState(
    icon: Icons.search_off_outlined,
    title: 'No Results Found',
    description: 'Try adjusting your search or filters.',
  );

  /// No tasks for date empty state
  static const EmptyState noTasksForDate = EmptyState(
    icon: Icons.event_available_outlined,
    title: 'No Tasks for This Day',
    description: 'Your schedule is clear!',
  );

  /// No completed tasks empty state
  static const EmptyState noCompletedTasks = EmptyState(
    icon: Icons.check_circle_outline,
    title: 'No Completed Tasks',
    description: 'Complete some tasks to see them here.',
  );

  /// No categories empty state
  static EmptyState noCategories({VoidCallback? onCreateCategory}) =>
      EmptyState(
        icon: Icons.folder_outlined,
        title: 'No Categories',
        description: 'Create categories to organize your tasks.',
        actionLabel: 'Create Category',
        onAction: onCreateCategory,
      );
}
