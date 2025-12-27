import 'package:flutter/material.dart';

import '../design_system/tokens/colors.dart';

/// Task priority levels
enum Priority {
  high,
  medium,
  low;

  /// Human-readable display name
  String get displayName {
    switch (this) {
      case Priority.high:
        return 'High';
      case Priority.medium:
        return 'Medium';
      case Priority.low:
        return 'Low';
    }
  }

  /// Sort order (lower = higher priority)
  int get sortOrder {
    switch (this) {
      case Priority.high:
        return 0;
      case Priority.medium:
        return 1;
      case Priority.low:
        return 2;
    }
  }

  /// Icon for the priority
  IconData get icon {
    switch (this) {
      case Priority.high:
        return Icons.keyboard_double_arrow_up;
      case Priority.medium:
        return Icons.drag_handle;
      case Priority.low:
        return Icons.keyboard_double_arrow_down;
    }
  }

  /// Color for the priority
  Color get color {
    switch (this) {
      case Priority.high:
        return PriorityColors.high;
      case Priority.medium:
        return PriorityColors.medium;
      case Priority.low:
        return PriorityColors.low;
    }
  }

  /// Container color for the priority
  Color get containerColor {
    switch (this) {
      case Priority.high:
        return PriorityColors.highContainer;
      case Priority.medium:
        return PriorityColors.mediumContainer;
      case Priority.low:
        return PriorityColors.lowContainer;
    }
  }
}
