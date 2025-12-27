import '../entities/task.dart';
import 'hive_service.dart';

/// Service for calendar-related task operations
class CalendarService {
  static CalendarService? _instance;
  static CalendarService get instance => _instance ??= CalendarService._();
  CalendarService._();

  /// Get tasks grouped by date
  Map<DateTime, List<Task>> getTasksGroupedByDate({
    DateTime? startDate,
    DateTime? endDate,
    bool includeCompleted = false,
  }) {
    final tasks = HiveService.instance.tasksBox.values
        .where((task) => includeCompleted || !task.isCompleted)
        .toList();

    final grouped = <DateTime, List<Task>>{};

    for (final task in tasks) {
      for (final time in task.notificationTime) {
        // Normalize to date only
        final dateKey = DateTime(time.year, time.month, time.day);

        // Apply date range filter if provided
        if (startDate != null && dateKey.isBefore(startDate)) continue;
        if (endDate != null && dateKey.isAfter(endDate)) continue;

        grouped.putIfAbsent(dateKey, () => []);
        if (!grouped[dateKey]!.contains(task)) {
          grouped[dateKey]!.add(task);
        }
      }
    }

    // Sort tasks within each date by time
    for (final dateKey in grouped.keys) {
      grouped[dateKey]!.sort((a, b) {
        final aTime = a.notificationTime
            .where(
                (t) => DateTime(t.year, t.month, t.day) == dateKey)
            .first;
        final bTime = b.notificationTime
            .where(
                (t) => DateTime(t.year, t.month, t.day) == dateKey)
            .first;
        return aTime.compareTo(bTime);
      });
    }

    return grouped;
  }

  /// Get tasks for a specific date
  List<Task> getTasksForDate(DateTime date, {bool includeCompleted = false}) {
    final dateKey = DateTime(date.year, date.month, date.day);
    final tasks = HiveService.instance.tasksBox.values
        .where((task) => includeCompleted || !task.isCompleted)
        .where((task) => task.notificationTime.any((time) =>
            DateTime(time.year, time.month, time.day) == dateKey))
        .toList();

    // Sort by time
    tasks.sort((a, b) {
      final aTime = a.notificationTime
          .where((t) => DateTime(t.year, t.month, t.day) == dateKey)
          .first;
      final bTime = b.notificationTime
          .where((t) => DateTime(t.year, t.month, t.day) == dateKey)
          .first;
      return aTime.compareTo(bTime);
    });

    return tasks;
  }

  /// Get dates that have tasks in a month
  Set<DateTime> getDatesWithTasksInMonth(int year, int month,
      {bool includeCompleted = false}) {
    final startOfMonth = DateTime(year, month, 1);
    final endOfMonth = DateTime(year, month + 1, 0); // Last day of month

    final tasks = HiveService.instance.tasksBox.values
        .where((task) => includeCompleted || !task.isCompleted)
        .toList();

    final dates = <DateTime>{};

    for (final task in tasks) {
      for (final time in task.notificationTime) {
        final dateKey = DateTime(time.year, time.month, time.day);
        if (dateKey.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
            dateKey.isBefore(endOfMonth.add(const Duration(days: 1)))) {
          dates.add(dateKey);
        }
      }
    }

    return dates;
  }

  /// Get task count for a specific date
  int getTaskCountForDate(DateTime date, {bool includeCompleted = false}) {
    return getTasksForDate(date, includeCompleted: includeCompleted).length;
  }

  /// Get the week containing a date (Sunday to Saturday)
  List<DateTime> getWeekDates(DateTime date) {
    final startOfWeek =
        date.subtract(Duration(days: date.weekday % 7)); // Sunday
    return List.generate(
      7,
      (i) => DateTime(
        startOfWeek.year,
        startOfWeek.month,
        startOfWeek.day + i,
      ),
    );
  }

  /// Get all dates in a month
  List<DateTime> getMonthDates(int year, int month) {
    final lastDay = DateTime(year, month + 1, 0);
    final daysInMonth = lastDay.day;

    return List.generate(
      daysInMonth,
      (i) => DateTime(year, month, i + 1),
    );
  }

  /// Get calendar grid dates (includes padding from previous/next months)
  List<DateTime> getCalendarGridDates(int year, int month) {
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);

    // Days to show from previous month (to complete the first week)
    final daysFromPrevMonth = firstDay.weekday % 7;

    // Days to show from next month (to complete the last week)
    final totalDays = daysFromPrevMonth + lastDay.day;
    final daysFromNextMonth = (7 - (totalDays % 7)) % 7;

    final dates = <DateTime>[];

    // Add days from previous month
    for (int i = daysFromPrevMonth - 1; i >= 0; i--) {
      dates.add(firstDay.subtract(Duration(days: i + 1)));
    }

    // Add days from current month
    for (int i = 0; i < lastDay.day; i++) {
      dates.add(DateTime(year, month, i + 1));
    }

    // Add days from next month
    for (int i = 0; i < daysFromNextMonth; i++) {
      dates.add(DateTime(year, month + 1, i + 1));
    }

    return dates;
  }

  /// Check if a date is today
  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if a date is in the past
  bool isPastDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return date.isBefore(today);
  }

  /// Get summary for a date range
  Map<String, dynamic> getDateRangeSummary(DateTime start, DateTime end,
      {bool includeCompleted = false}) {
    final tasks = getTasksGroupedByDate(
      startDate: start,
      endDate: end,
      includeCompleted: includeCompleted,
    );

    final totalTasks = tasks.values.fold<int>(0, (sum, list) => sum + list.length);
    final daysWithTasks = tasks.keys.length;
    final totalDays = end.difference(start).inDays + 1;

    return {
      'totalTasks': totalTasks,
      'daysWithTasks': daysWithTasks,
      'totalDays': totalDays,
      'tasksPerDay': totalDays > 0 ? totalTasks / totalDays : 0.0,
      'tasksByDate': tasks,
    };
  }
}
