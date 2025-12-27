import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../design_system/components/cards/task_card.dart';
import '../design_system/components/feedback/empty_state.dart';
import '../design_system/components/feedback/skeleton_loader.dart';
import '../design_system/components/lists/swipe_action_tile.dart';
import '../design_system/tokens/spacing.dart';
import '../design_system/tokens/typography.dart';
import '../providers/statistics_provider.dart';
import '../providers/task_provider.dart';
import 'create_task_screen.dart';

/// Dashboard screen showing quick stats and task overview
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<TaskProvider>().loadTasks();
            context.read<StatisticsProvider>().refresh();
          },
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                floating: true,
                title: Text(
                  'Dashboard',
                  style: AppTypography.headlineMedium,
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      // TODO: Navigate to search
                    },
                  ),
                ],
              ),
              // Quick Stats
              SliverToBoxAdapter(
                child: _QuickStats(),
              ),
              // Date Selector
              SliverToBoxAdapter(
                child: _DateSelector(),
              ),
              // Task List
              SliverPadding(
                padding: AppEdgeInsets.horizontalMd,
                sliver: _TaskList(),
              ),
              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateTaskScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
    );
  }
}

class _QuickStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer<StatisticsProvider>(
      builder: (context, stats, _) {
        return Padding(
          padding: AppEdgeInsets.md,
          child: Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.check_circle_outline,
                  label: 'Today',
                  value: '${stats.todayCompletedCount}',
                  color: colorScheme.primary,
                ),
              ),
              AppGaps.sm,
              Expanded(
                child: _StatCard(
                  icon: Icons.local_fire_department,
                  label: 'Streak',
                  value: '${stats.currentStreak}',
                  color: Colors.orange,
                ),
              ),
              AppGaps.sm,
              Expanded(
                child: _StatCard(
                  icon: Icons.pending_outlined,
                  label: 'Pending',
                  value: '${context.watch<TaskProvider>().incompleteTaskCount}',
                  color: colorScheme.tertiary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: AppEdgeInsets.md,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          AppGaps.xs,
          Text(
            value,
            style: AppTypography.headlineSmall.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

enum _DateFilter { today, tomorrow, thisWeek, all }

class _DateSelector extends StatefulWidget {
  @override
  State<_DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<_DateSelector> {
  _DateFilter _selected = _DateFilter.today;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppEdgeInsets.horizontalMd,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _DateChip(
              label: 'Today',
              isSelected: _selected == _DateFilter.today,
              onTap: () => _selectFilter(_DateFilter.today),
            ),
            AppGaps.sm,
            _DateChip(
              label: 'Tomorrow',
              isSelected: _selected == _DateFilter.tomorrow,
              onTap: () => _selectFilter(_DateFilter.tomorrow),
            ),
            AppGaps.sm,
            _DateChip(
              label: 'This Week',
              isSelected: _selected == _DateFilter.thisWeek,
              onTap: () => _selectFilter(_DateFilter.thisWeek),
            ),
            AppGaps.sm,
            _DateChip(
              label: 'All',
              isSelected: _selected == _DateFilter.all,
              onTap: () => _selectFilter(_DateFilter.all),
            ),
          ],
        ),
      ),
    );
  }

  void _selectFilter(_DateFilter filter) {
    setState(() {
      _selected = filter;
    });

    final taskProvider = context.read<TaskProvider>();

    switch (filter) {
      case _DateFilter.today:
        final now = DateTime.now();
        final startOfDay = DateTime(now.year, now.month, now.day);
        final endOfDay = startOfDay.add(const Duration(days: 1));
        taskProvider.applyFilter(taskProvider.currentFilter.copyWith(
          dueDateFrom: startOfDay,
          dueDateTo: endOfDay,
          isCompleted: false,
        ));
        break;
      case _DateFilter.tomorrow:
        final now = DateTime.now();
        final tomorrow = DateTime(now.year, now.month, now.day + 1);
        final endOfTomorrow = tomorrow.add(const Duration(days: 1));
        taskProvider.applyFilter(taskProvider.currentFilter.copyWith(
          dueDateFrom: tomorrow,
          dueDateTo: endOfTomorrow,
          isCompleted: false,
        ));
        break;
      case _DateFilter.thisWeek:
        final now = DateTime.now();
        final startOfDay = DateTime(now.year, now.month, now.day);
        final endOfWeek = startOfDay.add(const Duration(days: 7));
        taskProvider.applyFilter(taskProvider.currentFilter.copyWith(
          dueDateFrom: startOfDay,
          dueDateTo: endOfWeek,
          isCompleted: false,
        ));
        break;
      case _DateFilter.all:
        taskProvider.applyFilter(taskProvider.currentFilter.copyWith(
          clearDueDateFrom: true,
          clearDueDateTo: true,
          isCompleted: false,
        ));
        break;
    }
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: colorScheme.primaryContainer,
      checkmarkColor: colorScheme.onPrimaryContainer,
    );
  }
}

class _TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, _) {
        if (taskProvider.isLoading) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: AppEdgeInsets.verticalSm,
                child: const SkeletonTaskCard(),
              ),
              childCount: 5,
            ),
          );
        }

        final tasks = taskProvider.filteredTasks;

        if (tasks.isEmpty) {
          return SliverFillRemaining(
            child: EmptyStates.noTasks(
              onCreateTask: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateTaskScreen(),
                  ),
                );
              },
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final task = tasks[index];
              return Padding(
                padding: AppEdgeInsets.verticalSm,
                child: TaskSwipeActionTile(
                  isCompleted: task.isCompleted,
                  onComplete: () => taskProvider.completeTask(task.id),
                  onDelete: () => taskProvider.deleteTask(task.id),
                  child: TaskCard(
                    task: task,
                    onTap: () {
                      // TODO: Navigate to task detail
                    },
                    onComplete: () => taskProvider.completeTask(task.id),
                  ),
                ),
              );
            },
            childCount: tasks.length,
          ),
        );
      },
    );
  }
}
