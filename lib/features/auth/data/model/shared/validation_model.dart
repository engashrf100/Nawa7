class ValidationErrors {
  /// Holds all validation errors dynamically, e.g.:
  /// { "phone": ["The phone field is required"], "password": ["Too short"] }
  final Map<String, List<String>> fieldErrors;

  ValidationErrors({required this.fieldErrors});

  factory ValidationErrors.fromJson(Map<String, dynamic> json) {
    final Map<String, List<String>> parsedErrors = {};

    json.forEach((key, value) {
      if (value is List) {
        parsedErrors[key] = List<String>.from(value);
      }
    });

    return ValidationErrors(fieldErrors: parsedErrors);
  }

  Map<String, dynamic> toJson() {
    return fieldErrors;
  }

  /// Helper to get the first error for a specific field (e.g., phone)
  String? firstError(String field) {
    final errors = fieldErrors[field];
    return (errors != null && errors.isNotEmpty) ? errors.first : null;
  }

  /// Check if a field has any errors
  bool hasError(String field) => fieldErrors.containsKey(field);
}


