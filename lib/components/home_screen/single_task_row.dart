import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';

import '../../entities/task.dart';

class SingleTaskRow extends StatelessWidget {
  final Task task;

  const SingleTaskRow({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final containerColor = Colors.grey.shade100;
    final textColor = Colors.grey.shade800; // Darker for better contrast
    final accentColor = Colors.grey.shade600;

    // Calculate the next reminder time
    final DateTime? nextReminder = task.notificationTime.isNotEmpty
        ? task.notificationTime.reduce((a, b) => a.isBefore(b) ? a : b)
        : null;

// Function to format the time difference
    String _formatTime(Duration duration) {
      if (duration.inDays > 0) {
        return "${duration.inDays} day${duration.inDays > 1 ? 's' : ''}";
      } else if (duration.inHours > 0) {
        return "${duration.inHours} hr${duration.inHours > 1 ? 's' : ''}";
      } else if (duration.inMinutes > 0) {
        return "${duration.inMinutes} min${duration.inMinutes > 1 ? 's' : ''}";
      } else if (duration.inSeconds > 0) {
        return "${duration.inSeconds} sec${duration.inSeconds > 1 ? 's' : ''}";
      } else {
        return "Just now"; // Handle the case where the duration is very small (less than 1 second)
      }
    }

    final Duration? timeUntilNextReminder =
        nextReminder?.difference(DateTime.now());
    final String nextReminderText = timeUntilNextReminder != null
        ? (timeUntilNextReminder.isNegative
            ? _formatTime(timeUntilNextReminder.abs()) + " ago" // Past time
            : "In " + _formatTime(timeUntilNextReminder)) // Future time
        : "No Reminders";

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 8.0,
      ),
      child: ClayContainer(
        color: containerColor,
        borderRadius: 15,
        depth: 10,
        spread: 5,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon for Task Status
              ClayContainer(
                borderRadius: 40,
                depth: task.isActive ? 10 : -10,
                color: containerColor,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    task.isActive
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: task.isActive ? Colors.grey : accentColor,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Task Title and Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Task Title
                    ClayText(
                      task.title,
                      textColor: textColor,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Task Description (optional)
                    if (task.description.isNotEmpty)
                      Text(
                        task.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: accentColor,
                          fontStyle: FontStyle.italic,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                  ],
                ),
              ),
              // Notification Time Indicator
              if (task.notificationTime.isNotEmpty)
                Row(
                  children: [
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.notifications,
                                size: 16,
                                color: accentColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${task.notificationTime.length} Reminder${task.notificationTime.length > 1 ? 's' : ''}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: accentColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$nextReminderText",
                            style: TextStyle(
                              fontSize: 13,
                              color: textColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
