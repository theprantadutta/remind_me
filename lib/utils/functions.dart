import '../enums/recurrence_type.dart';

/// Converts all RecurrenceType values to a list of strings
List<String> getRecurrenceTypeStrings() {
  return RecurrenceType.values.map((type) => type.toReadableString()).toList();
}

/// Converts a single RecurrenceType to its string representation
String getRecurrenceTypeString(RecurrenceType type) {
  return type.toReadableString();
}

/// Converts a string to the corresponding RecurrenceType
RecurrenceType getRecurrenceTypeFromString(String value) {
  switch (value.toLowerCase()) {
    case "none":
      return RecurrenceType.none;
    case "daily":
      return RecurrenceType.daily;
    case "minute":
      return RecurrenceType.minute;
    case "weekly":
      return RecurrenceType.weekly;
    case "monthly":
      return RecurrenceType.monthly;
    case "yearly":
      return RecurrenceType.yearly;
    default:
      throw ArgumentError("Invalid recurrence type string: $value");
  }
}
