import '../entities/daily_stats.dart';
import 'hive_service.dart';
import 'logger_service.dart';

/// Service for tracking and querying productivity statistics
class StatisticsService {
  static StatisticsService? _instance;
  static StatisticsService get instance => _instance ??= StatisticsService._();
  StatisticsService._();

  final _logger = LoggerService.instance;

  /// Get or create stats for today
  DailyStats _getOrCreateTodayStats() {
    final today = DailyStats.today();
    final existing = HiveService.instance.dailyStatsBox.get(today.dateKey);

    if (existing != null) {
      return existing;
    }

    HiveService.instance.dailyStatsBox.put(today.dateKey, today);
    return today;
  }

  /// Record a task completion
  Future<void> recordTaskCompleted() async {
    final stats = _getOrCreateTodayStats();
    stats.incrementCompleted();
    await stats.save();
    _logger.debug('Recorded task completion for ${stats.dateKey}',
        tag: 'StatisticsService');
  }

  /// Record a task creation
  Future<void> recordTaskCreated() async {
    final stats = _getOrCreateTodayStats();
    stats.incrementCreated();
    await stats.save();
    _logger.debug('Recorded task creation for ${stats.dateKey}',
        tag: 'StatisticsService');
  }

  /// Get stats for a specific date
  DailyStats? getStatsForDate(DateTime date) {
    final stats = DailyStats.forDate(date);
    return HiveService.instance.dailyStatsBox.get(stats.dateKey);
  }

  /// Get stats for today
  DailyStats getTodayStats() {
    return _getOrCreateTodayStats();
  }

  /// Get stats for the last N days
  List<DailyStats> getStatsForLastDays(int days) {
    final results = <DailyStats>[];
    final now = DateTime.now();

    for (int i = 0; i < days; i++) {
      final date = now.subtract(Duration(days: i));
      final stats = getStatsForDate(date) ?? DailyStats.forDate(date);
      results.add(stats);
    }

    return results.reversed.toList(); // Oldest first
  }

  /// Get stats for a date range
  List<DailyStats> getStatsInRange(DateTime start, DateTime end) {
    final results = <DailyStats>[];
    var current = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);

    while (!current.isAfter(endDate)) {
      final stats = getStatsForDate(current) ?? DailyStats.forDate(current);
      results.add(stats);
      current = current.add(const Duration(days: 1));
    }

    return results;
  }

  /// Get total tasks completed
  int getTotalTasksCompleted() {
    return HiveService.instance.dailyStatsBox.values
        .fold(0, (sum, stats) => sum + stats.tasksCompleted);
  }

  /// Get total tasks created
  int getTotalTasksCreated() {
    return HiveService.instance.dailyStatsBox.values
        .fold(0, (sum, stats) => sum + stats.tasksCreated);
  }

  /// Get current streak (consecutive days with completed tasks)
  int getCurrentStreak() {
    final now = DateTime.now();
    var streak = 0;
    var current = DateTime(now.year, now.month, now.day);

    while (true) {
      final stats = getStatsForDate(current);
      if (stats == null || stats.tasksCompleted == 0) {
        // Check if it's today and we haven't completed anything yet
        if (streak == 0 && current == DateTime(now.year, now.month, now.day)) {
          // Check yesterday
          current = current.subtract(const Duration(days: 1));
          continue;
        }
        break;
      }
      streak++;
      current = current.subtract(const Duration(days: 1));
    }

    return streak;
  }

  /// Get longest streak
  int getLongestStreak() {
    final allStats = HiveService.instance.dailyStatsBox.values.toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    if (allStats.isEmpty) return 0;

    int longestStreak = 0;
    int currentStreak = 0;
    DateTime? previousDate;

    for (final stats in allStats) {
      if (stats.tasksCompleted > 0) {
        if (previousDate == null ||
            stats.date.difference(previousDate).inDays == 1) {
          currentStreak++;
        } else {
          currentStreak = 1;
        }
        longestStreak =
            currentStreak > longestStreak ? currentStreak : longestStreak;
        previousDate = stats.date;
      } else {
        currentStreak = 0;
        previousDate = null;
      }
    }

    return longestStreak;
  }

  /// Get weekly summary (last 7 days)
  Map<String, dynamic> getWeeklySummary() {
    final stats = getStatsForLastDays(7);
    final totalCompleted =
        stats.fold(0, (sum, s) => sum + s.tasksCompleted);
    final totalCreated = stats.fold(0, (sum, s) => sum + s.tasksCreated);
    final daysWithActivity =
        stats.where((s) => s.tasksCompleted > 0).length;

    return {
      'totalCompleted': totalCompleted,
      'totalCreated': totalCreated,
      'daysWithActivity': daysWithActivity,
      'averagePerDay':
          daysWithActivity > 0 ? totalCompleted / daysWithActivity : 0.0,
      'dailyStats': stats,
    };
  }

  /// Get monthly summary
  Map<String, dynamic> getMonthlySummary() {
    final stats = getStatsForLastDays(30);
    final totalCompleted =
        stats.fold(0, (sum, s) => sum + s.tasksCompleted);
    final totalCreated = stats.fold(0, (sum, s) => sum + s.tasksCreated);
    final daysWithActivity =
        stats.where((s) => s.tasksCompleted > 0).length;

    return {
      'totalCompleted': totalCompleted,
      'totalCreated': totalCreated,
      'daysWithActivity': daysWithActivity,
      'averagePerDay':
          daysWithActivity > 0 ? totalCompleted / daysWithActivity : 0.0,
      'completionRate': totalCreated > 0
          ? (totalCompleted / totalCreated * 100).toStringAsFixed(1)
          : '0',
    };
  }

  /// Get productivity insights
  Map<String, dynamic> getProductivityInsights() {
    return {
      'currentStreak': getCurrentStreak(),
      'longestStreak': getLongestStreak(),
      'totalCompleted': getTotalTasksCompleted(),
      'totalCreated': getTotalTasksCreated(),
      'weekly': getWeeklySummary(),
      'monthly': getMonthlySummary(),
    };
  }
}
