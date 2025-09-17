import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../entities/task.dart';

class SingleTaskRow extends StatelessWidget {
  final Task task;

  const SingleTaskRow({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkTheme ? Colors.white : kTextPrimary;
    final accentColor = isDarkTheme ? kTextLight : kTextSecondary;

    // Calculate the next reminder time
    final DateTime? nextReminder = task.notificationTime.isNotEmpty
        ? task.notificationTime.reduce((a, b) => a.isBefore(b) ? a : b)
        : null;

    // Function to format the time difference
    String formatTime(Duration duration) {
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
            ? "${formatTime(timeUntilNextReminder.abs())} ago" // Past time
            : "In ${formatTime(timeUntilNextReminder)}") // Future time
        : "No Reminders";

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 8.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: isDarkTheme ? kDarkCardGradient : kCardGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: kShadowColor,
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
            BoxShadow(
              color: kShadowColorDark,
              blurRadius: 25,
              offset: Offset(0, 15),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 18.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon for Task Status
              Container(
                decoration: BoxDecoration(
                  gradient: task.isActive ? kPrimaryButtonGradient : kSecondaryButtonGradient,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: task.isActive ? kPrimaryColor.withValues(alpha: 0.3) : kShadowColor,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    task.isActive
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Task Title and Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Task Title
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
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
                Column(
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
                      nextReminderText,
                      style: TextStyle(
                        fontSize: 13,
                        color: textColor,
                        fontWeight: FontWeight.w500,
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
