import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../design_system/components/cards/task_card.dart';
import '../design_system/components/feedback/empty_state.dart';
import '../design_system/components/feedback/skeleton_loader.dart';
import '../design_system/tokens/spacing.dart';
import '../design_system/tokens/typography.dart';
import '../providers/task_provider.dart';

/// Screen showing completed/archived tasks
class CompletedTasksScreen extends StatelessWidget {
  const CompletedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Completed Tasks',
          style: AppTypography.titleLarge.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        actions: [
          Consumer<TaskProvider>(
            builder: (context, taskProvider, _) {
              final completedCount = taskProvider.completedTasks.length;
              if (completedCount == 0) return const SizedBox.shrink();

              return IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                tooltip: 'Clear all completed',
                onPressed: () => _showClearAllDialog(context, taskProvider),
              );
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, _) {
          if (taskProvider.isLoading) {
            return ListView.builder(
              padding: AppEdgeInsets.md,
              itemCount: 5,
              itemBuilder: (context, index) => Padding(
                padding: AppEdgeInsets.verticalSm,
                child: const SkeletonTaskCard(),
              ),
            );
          }

          final completedTasks = taskProvider.completedTasks;

          if (completedTasks.isEmpty) {
            return EmptyStates.noCompletedTasks;
          }

          // Group tasks by completion date
          final groupedTasks = _groupTasksByDate(completedTasks);
          final sortedDates = groupedTasks.keys.toList()
            ..sort((a, b) => b.compareTo(a)); // Most recent first

          return ListView.builder(
            padding: AppEdgeInsets.md,
            itemCount: sortedDates.length,
            itemBuilder: (context, index) {
              final date = sortedDates[index];
              final tasks = groupedTasks[date]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index > 0) AppGaps.lg,
                  _DateHeader(date: date),
                  AppGaps.sm,
                  ...tasks.map((task) => Padding(
                        padding: AppEdgeInsets.verticalSm,
                        child: _CompletedTaskCard(
                          task: task,
                          onRestore: () => taskProvider.restoreTask(task.id),
                          onDelete: () => _confirmDelete(
                            context,
                            taskProvider,
                            task.id,
                          ),
                        ),
                      )),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Map<DateTime, List<dynamic>> _groupTasksByDate(List<dynamic> tasks) {
    final grouped = <DateTime, List<dynamic>>{};

    for (final task in tasks) {
      final completedAt = task.completedAt ?? task.createdAt ?? DateTime.now();
      final dateOnly = DateTime(
        completedAt.year,
        completedAt.month,
        completedAt.day,
      );

      grouped.putIfAbsent(dateOnly, () => []).add(task);
    }

    return grouped;
  }

  void _showClearAllDialog(BuildContext context, TaskProvider taskProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Completed Tasks'),
        content: const Text(
          'This will permanently delete all completed tasks. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              taskProvider.deleteAllCompletedTasks();
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    TaskProvider taskProvider,
    dynamic taskId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text(
          'Are you sure you want to permanently delete this task?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              taskProvider.deleteTask(taskId);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _DateHeader extends StatelessWidget {
  const _DateHeader({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    String dateText;
    if (date == today) {
      dateText = 'Today';
    } else if (date == yesterday) {
      dateText = 'Yesterday';
    } else if (date.isAfter(today.subtract(const Duration(days: 7)))) {
      final weekdays = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ];
      dateText = weekdays[date.weekday - 1];
    } else {
      dateText = '${date.day}/${date.month}/${date.year}';
    }

    return Text(
      dateText,
      style: AppTypography.titleSmall.copyWith(
        color: colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _CompletedTaskCard extends StatelessWidget {
  const _CompletedTaskCard({
    required this.task,
    required this.onRestore,
    required this.onDelete,
  });

  final dynamic task;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: Key(task.id.toString()),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: AppEdgeInsets.horizontalMd,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.restore,
          color: colorScheme.onPrimary,
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: AppEdgeInsets.horizontalMd,
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.delete_outline,
          color: colorScheme.onError,
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onRestore();
          return false; // Don't dismiss, just restore
        } else {
          onDelete();
          return false; // Don't dismiss, show confirmation
        }
      },
      child: Opacity(
        opacity: 0.7,
        child: TaskCard(
          task: task,
          onTap: () {
            // Show task details or options
            _showTaskOptions(context);
          },
        ),
      ),
    );
  }

  void _showTaskOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.restore),
              title: const Text('Restore Task'),
              onTap: () {
                Navigator.pop(context);
                onRestore();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                'Delete Permanently',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                onDelete();
              },
            ),
          ],
        ),
      ),
    );
  }
}
