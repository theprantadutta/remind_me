import 'package:flutter/foundation.dart';

import '../entities/daily_stats.dart';
import '../services/statistics_service.dart';

/// Provider for managing statistics and statistics-related state
class StatisticsProvider extends ChangeNotifier {
  DailyStats? _todayStats;
  DailyStats? get todayStats => _todayStats;

  int _currentStreak = 0;
  int get currentStreak => _currentStreak;

  int _longestStreak = 0;
  int get longestStreak => _longestStreak;

  int _totalCompleted = 0;
  int get totalCompleted => _totalCompleted;

  int _totalCreated = 0;
  int get totalCreated => _totalCreated;

  Map<String, dynamic> _weeklySummary = {};
  Map<String, dynamic> get weeklySummary => _weeklySummary;

  Map<String, dynamic> _monthlySummary = {};
  Map<String, dynamic> get monthlySummary => _monthlySummary;

  List<DailyStats> _weeklyStats = [];
  List<DailyStats> get weeklyStats => _weeklyStats;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Load all statistics
  void loadStatistics() {
    _isLoading = true;
    notifyListeners();

    try {
      _todayStats = StatisticsService.instance.getTodayStats();
      _currentStreak = StatisticsService.instance.getCurrentStreak();
      _longestStreak = StatisticsService.instance.getLongestStreak();
      _totalCompleted = StatisticsService.instance.getTotalTasksCompleted();
      _totalCreated = StatisticsService.instance.getTotalTasksCreated();
      _weeklySummary = StatisticsService.instance.getWeeklySummary();
      _monthlySummary = StatisticsService.instance.getMonthlySummary();
      _weeklyStats = StatisticsService.instance.getStatsForLastDays(7);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh statistics
  void refresh() {
    loadStatistics();
  }

  /// Get stats for a specific date
  DailyStats? getStatsForDate(DateTime date) {
    return StatisticsService.instance.getStatsForDate(date);
  }

  /// Get stats for the last N days
  List<DailyStats> getStatsForLastDays(int days) {
    return StatisticsService.instance.getStatsForLastDays(days);
  }

  /// Get stats for a date range
  List<DailyStats> getStatsInRange(DateTime start, DateTime end) {
    return StatisticsService.instance.getStatsInRange(start, end);
  }

  /// Get completion rate as percentage string
  String get completionRate {
    if (_totalCreated == 0) return '0%';
    final rate = (_totalCompleted / _totalCreated * 100).toStringAsFixed(1);
    return '$rate%';
  }

  /// Get average tasks completed per day (for days with activity)
  double get averagePerDay {
    final daysWithActivity = _weeklyStats.where((s) => s.tasksCompleted > 0).length;
    if (daysWithActivity == 0) return 0.0;
    final total = _weeklyStats.fold(0, (sum, s) => sum + s.tasksCompleted);
    return total / daysWithActivity;
  }

  /// Get today's completed count
  int get todayCompletedCount => _todayStats?.tasksCompleted ?? 0;

  /// Get today's created count
  int get todayCreatedCount => _todayStats?.tasksCreated ?? 0;

  /// Get productivity score (0-100)
  int get productivityScore {
    // Simple scoring based on streak and completion rate
    final streakScore = (_currentStreak * 10).clamp(0, 40);
    final completionScore = _totalCreated > 0
        ? ((_totalCompleted / _totalCreated) * 60).toInt()
        : 0;
    return (streakScore + completionScore).clamp(0, 100);
  }
}
