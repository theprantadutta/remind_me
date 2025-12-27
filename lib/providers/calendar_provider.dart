import 'package:flutter/foundation.dart';

import '../entities/task.dart';
import '../services/calendar_service.dart';

/// Provider for managing calendar-related state
class CalendarProvider extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  DateTime _focusedMonth = DateTime.now();
  DateTime get focusedMonth => _focusedMonth;

  List<Task> _tasksForSelectedDate = [];
  List<Task> get tasksForSelectedDate => _tasksForSelectedDate;

  Map<DateTime, List<Task>> _tasksGroupedByDate = {};
  Map<DateTime, List<Task>> get tasksGroupedByDate => _tasksGroupedByDate;

  Set<DateTime> _datesWithTasks = {};
  Set<DateTime> get datesWithTasks => _datesWithTasks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _showCompleted = false;
  bool get showCompleted => _showCompleted;

  /// Initialize calendar data
  void initialize() {
    _loadTasksForMonth();
    _loadTasksForSelectedDate();
  }

  /// Select a date
  void selectDate(DateTime date) {
    _selectedDate = DateTime(date.year, date.month, date.day);
    _loadTasksForSelectedDate();
    notifyListeners();
  }

  /// Change focused month
  void setFocusedMonth(DateTime month) {
    _focusedMonth = DateTime(month.year, month.month, 1);
    _loadTasksForMonth();
    notifyListeners();
  }

  /// Toggle showing completed tasks
  void toggleShowCompleted() {
    _showCompleted = !_showCompleted;
    _loadTasksForMonth();
    _loadTasksForSelectedDate();
    notifyListeners();
  }

  /// Load tasks for the selected date
  void _loadTasksForSelectedDate() {
    _tasksForSelectedDate = CalendarService.instance.getTasksForDate(
      _selectedDate,
      includeCompleted: _showCompleted,
    );
  }

  /// Load tasks for the focused month
  void _loadTasksForMonth() {
    final startOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final endOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);

    _tasksGroupedByDate = CalendarService.instance.getTasksGroupedByDate(
      startDate: startOfMonth,
      endDate: endOfMonth,
      includeCompleted: _showCompleted,
    );

    _datesWithTasks = CalendarService.instance.getDatesWithTasksInMonth(
      _focusedMonth.year,
      _focusedMonth.month,
      includeCompleted: _showCompleted,
    );
  }

  /// Refresh all calendar data
  void refresh() {
    _isLoading = true;
    notifyListeners();

    try {
      _loadTasksForMonth();
      _loadTasksForSelectedDate();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get tasks for a specific date
  List<Task> getTasksForDate(DateTime date) {
    return CalendarService.instance.getTasksForDate(
      date,
      includeCompleted: _showCompleted,
    );
  }

  /// Get task count for a specific date
  int getTaskCountForDate(DateTime date) {
    return CalendarService.instance.getTaskCountForDate(
      date,
      includeCompleted: _showCompleted,
    );
  }

  /// Check if a date has tasks
  bool hasTasksOnDate(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    return _datesWithTasks.contains(dateKey);
  }

  /// Check if a date is today
  bool isToday(DateTime date) {
    return CalendarService.instance.isToday(date);
  }

  /// Check if a date is the selected date
  bool isSelectedDate(DateTime date) {
    return date.year == _selectedDate.year &&
        date.month == _selectedDate.month &&
        date.day == _selectedDate.day;
  }

  /// Get calendar grid dates for the focused month
  List<DateTime> get calendarGridDates {
    return CalendarService.instance.getCalendarGridDates(
      _focusedMonth.year,
      _focusedMonth.month,
    );
  }

  /// Get week dates for the selected date
  List<DateTime> get weekDates {
    return CalendarService.instance.getWeekDates(_selectedDate);
  }

  /// Navigate to today
  void goToToday() {
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _focusedMonth = DateTime(now.year, now.month, 1);
    refresh();
  }

  /// Navigate to next month
  void nextMonth() {
    setFocusedMonth(DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1));
  }

  /// Navigate to previous month
  void previousMonth() {
    setFocusedMonth(DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1));
  }
}
