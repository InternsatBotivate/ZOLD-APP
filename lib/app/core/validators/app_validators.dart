class AppValidators {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    if (value.length != 10) {
      return 'Phone number must be exactly 10 digits';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? otp(String? value) {
    if (value == null || value.isEmpty) return 'OTP is required';
    if (value.length != 6) {
      return 'OTP must be 6 digits';
    }
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.isEmpty) return 'Name is required';
    if (value.length < 3) {
      return 'Name must be at least 3 characters long';
    }
    return null;
  }

  static String? amount(String? value) {
    if (value == null || value.isEmpty) return 'Amount is required';
    final n = double.tryParse(value);
    if (n == null || n <= 0) {
      return 'Please enter a valid amount';
    }
    return null;
  }

  static String? confirmPassword(String? value, String? originalPassword) {
    if (value != originalPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? pan(String? value) {
    if (value == null || value.isEmpty) return 'PAN is required';
    final panRegExp = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    if (!panRegExp.hasMatch(value.toUpperCase())) {
      return 'Please enter a valid PAN number';
    }
    return null;
  }

  static String? aadhaar(String? value) {
    if (value == null || value.isEmpty) return 'Aadhaar is required';
    if (value.length != 12 || double.tryParse(value) == null) {
      return 'Aadhaar must be 12 digits';
    }
    return null;
  }

  static String? ifsc(String? value) {
    if (value == null || value.isEmpty) return 'IFSC is required';
    final ifscRegExp = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
    if (!ifscRegExp.hasMatch(value.toUpperCase())) {
      return 'Please enter a valid IFSC code';
    }
    return null;
  }

  static String? pincode(String? value) {
    if (value == null || value.isEmpty) return 'Pincode is required';
    if (value.length != 6 || double.tryParse(value) == null) {
      return 'Pincode must be 6 digits';
    }
    return null;
  }
}
