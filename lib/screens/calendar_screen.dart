import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../design_system/components/cards/task_card.dart';
import '../design_system/components/feedback/empty_state.dart';
import '../design_system/components/lists/swipe_action_tile.dart';
import '../design_system/tokens/spacing.dart';
import '../design_system/tokens/typography.dart';
import '../providers/calendar_provider.dart';
import '../providers/task_provider.dart';
import 'create_task_screen.dart';

/// Calendar screen with monthly view
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<CalendarProvider>(
          builder: (context, calendarProvider, _) {
            return Column(
              children: [
                // Month Header
                _MonthHeader(),
                // Calendar Grid
                _CalendarGrid(),
                // Selected Date Tasks
                Expanded(
                  child: _SelectedDateTasks(),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateTaskScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _MonthHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final calendarProvider = context.watch<CalendarProvider>();
    final monthFormat = DateFormat.yMMMM();

    return Padding(
      padding: AppEdgeInsets.md,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => calendarProvider.previousMonth(),
          ),
          GestureDetector(
            onTap: () => calendarProvider.goToToday(),
            child: Text(
              monthFormat.format(calendarProvider.focusedMonth),
              style: AppTypography.titleLarge.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => calendarProvider.nextMonth(),
          ),
        ],
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final calendarProvider = context.watch<CalendarProvider>();
    final dates = calendarProvider.calendarGridDates;

    return Padding(
      padding: AppEdgeInsets.horizontalMd,
      child: Column(
        children: [
          // Weekday headers
          Row(
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                .map((day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: AppTypography.labelSmall.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          AppGaps.sm,
          // Calendar grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              return _CalendarDay(date: date);
            },
          ),
        ],
      ),
    );
  }
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final calendarProvider = context.watch<CalendarProvider>();

    final isToday = calendarProvider.isToday(date);
    final isSelected = calendarProvider.isSelectedDate(date);
    final hasTasks = calendarProvider.hasTasksOnDate(date);
    final isCurrentMonth = date.month == calendarProvider.focusedMonth.month;

    return GestureDetector(
      onTap: () => calendarProvider.selectDate(date),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary
              : isToday
                  ? colorScheme.primaryContainer
                  : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '${date.day}',
              style: AppTypography.bodyMedium.copyWith(
                color: isSelected
                    ? colorScheme.onPrimary
                    : isToday
                        ? colorScheme.onPrimaryContainer
                        : isCurrentMonth
                            ? colorScheme.onSurface
                            : colorScheme.onSurface.withValues(alpha: 0.3),
                fontWeight: isToday || isSelected ? FontWeight.bold : null,
              ),
            ),
            if (hasTasks)
              Positioned(
                bottom: 4,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SelectedDateTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final calendarProvider = context.watch<CalendarProvider>();
    final taskProvider = context.read<TaskProvider>();
    final dateFormat = DateFormat.MMMMEEEEd();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppEdgeInsets.md,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateFormat.format(calendarProvider.selectedDate),
                style: AppTypography.titleMedium.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              TextButton.icon(
                onPressed: () => calendarProvider.toggleShowCompleted(),
                icon: Icon(
                  calendarProvider.showCompleted
                      ? Icons.visibility_off
                      : Icons.visibility,
                  size: 16,
                ),
                label: Text(
                  calendarProvider.showCompleted ? 'Hide Done' : 'Show Done',
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: calendarProvider.tasksForSelectedDate.isEmpty
              ? EmptyStates.noTasksForDate
              : ListView.separated(
                  padding: AppEdgeInsets.md,
                  itemCount: calendarProvider.tasksForSelectedDate.length,
                  separatorBuilder: (context, index) => AppGaps.sm,
                  itemBuilder: (context, index) {
                    final task = calendarProvider.tasksForSelectedDate[index];
                    return TaskSwipeActionTile(
                      isCompleted: task.isCompleted,
                      onComplete: () {
                        taskProvider.completeTask(task.id);
                        calendarProvider.refresh();
                      },
                      onDelete: () {
                        taskProvider.deleteTask(task.id);
                        calendarProvider.refresh();
                      },
                      child: TaskCard(
                        task: task,
                        compact: true,
                        onComplete: () {
                          taskProvider.completeTask(task.id);
                          calendarProvider.refresh();
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
