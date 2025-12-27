/// Validation function type
typedef Validator = String? Function(String? value);

/// Common validators for form fields
class Validators {
  /// Required field validator
  static Validator required([String? message]) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return message ?? 'This field is required';
      }
      return null;
    };
  }

  /// Minimum length validator
  static Validator minLength(int length, [String? message]) {
    return (value) {
      if (value != null && value.length < length) {
        return message ?? 'Must be at least $length characters';
      }
      return null;
    };
  }

  /// Maximum length validator
  static Validator maxLength(int length, [String? message]) {
    return (value) {
      if (value != null && value.length > length) {
        return message ?? 'Must be no more than $length characters';
      }
      return null;
    };
  }

  /// Email validator
  static Validator email([String? message]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      if (!emailRegex.hasMatch(value)) {
        return message ?? 'Please enter a valid email';
      }
      return null;
    };
  }

  /// Numeric validator
  static Validator numeric([String? message]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (double.tryParse(value) == null) {
        return message ?? 'Please enter a valid number';
      }
      return null;
    };
  }

  /// Pattern validator
  static Validator pattern(RegExp regex, [String? message]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (!regex.hasMatch(value)) {
        return message ?? 'Invalid format';
      }
      return null;
    };
  }

  /// Compose multiple validators
  static Validator compose(List<Validator> validators) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }

  /// Validate only if value is not empty
  static Validator optional(Validator validator) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      return validator(value);
    };
  }

  /// Custom validator with predicate
  static Validator custom(
    bool Function(String? value) predicate, [
    String? message,
  ]) {
    return (value) {
      if (!predicate(value)) {
        return message ?? 'Invalid value';
      }
      return null;
    };
  }

  /// Validate date is in the future
  static Validator futureDate([String? message]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      final date = DateTime.tryParse(value);
      if (date == null) {
        return message ?? 'Please enter a valid date';
      }
      if (date.isBefore(DateTime.now())) {
        return message ?? 'Date must be in the future';
      }
      return null;
    };
  }

  /// Validate date is not in the past
  static Validator notPastDate([String? message]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      final date = DateTime.tryParse(value);
      if (date == null) {
        return message ?? 'Please enter a valid date';
      }
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      if (date.isBefore(today)) {
        return message ?? 'Date cannot be in the past';
      }
      return null;
    };
  }
}

/// Common task-specific validators
class TaskValidators {
  static Validator title = Validators.compose([
    Validators.required('Please enter a task title'),
    Validators.minLength(3, 'Title must be at least 3 characters'),
    Validators.maxLength(100, 'Title must be no more than 100 characters'),
  ]);

  static Validator description = Validators.compose([
    Validators.maxLength(500, 'Description must be no more than 500 characters'),
  ]);

  static Validator categoryName = Validators.compose([
    Validators.required('Please enter a category name'),
    Validators.minLength(2, 'Name must be at least 2 characters'),
    Validators.maxLength(30, 'Name must be no more than 30 characters'),
  ]);

  static Validator tagName = Validators.compose([
    Validators.required('Please enter a tag name'),
    Validators.minLength(1, 'Name must be at least 1 character'),
    Validators.maxLength(20, 'Name must be no more than 20 characters'),
  ]);
}
