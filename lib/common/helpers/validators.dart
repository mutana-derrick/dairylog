class Validators {
  /// Checks if a value is not empty
  static String? validateRequired(String? value, {String fieldName = "This field"}) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }

  /// Validates phone numbers (basic Rwandan format)
  static String? validatePhoneNumber(String? value) {
    final pattern = RegExp(r'^(?:\+250|0)?7\d{8}$');
    if (value == null || value.trim().isEmpty) {
      return "Phone number is required";
    }
    if (!pattern.hasMatch(value.trim())) {
      return "Invalid phone number";
    }
    return null;
  }

  /// Validates email addresses
  static String? validateEmail(String? value) {
    final pattern = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }
    if (!pattern.hasMatch(value.trim())) {
      return "Invalid email address";
    }
    return null;
  }

  /// Validates numeric fields (e.g., quantity or price)
  static String? validateNumber(String? value, {String fieldName = "Value"}) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required";
    }
    final number = num.tryParse(value.trim());
    if (number == null) {
      return "$fieldName must be a number";
    }
    if (number < 0) {
      return "$fieldName cannot be negative";
    }
    return null;
  }
}
