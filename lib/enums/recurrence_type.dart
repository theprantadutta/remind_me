/// Enum to represent different recurrence types
enum RecurrenceType {
  none, // No recurrence
  minute, // Repeats every minute
  hour, // Repeats every hour
  daily, // Repeats every day
  weekly, // Repeats every week
  monthly, // Repeats every month
  yearly // Repeats every year
}

/// Extension to map RecurrenceType to human-readable strings
extension RecurrenceTypeExtension on RecurrenceType {
  String toReadableString() {
    switch (this) {
      case RecurrenceType.none:
        return "None";
      case RecurrenceType.minute:
        return "Minute";
      case RecurrenceType.hour:
        return "Hour";
      case RecurrenceType.daily:
        return "Daily";
      case RecurrenceType.weekly:
        return "Weekly";
      case RecurrenceType.monthly:
        return "Monthly";
      case RecurrenceType.yearly:
        return "Yearly";
    }
  }
}
