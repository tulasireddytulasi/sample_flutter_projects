class AppValidators {
  static String? requiredField(value) {
    const String kEmptyValidator = "This field is required";

    if (value == null || value.isEmpty) {
      return kEmptyValidator;
    }

    return null;
  }

  static String? validateMobileNo(String? value) {
    const String kEmptyValidator = "This field is required";
    const String inValid = "Invalid mobile number";

    if (value == null || value.isEmpty) {
      return kEmptyValidator;
    } else if (value.length != 10) {
      return inValid;
    }

    String pattern = r"^[6-9]\d{9}$";
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return inValid;
    }

    return null;
  }

  static String? validateOTP(String? value) {
    const String kEmptyValidator = "This field is required";
    const String inValid = "Invalid OTP";

    if (value == null || value.isEmpty) {
      return kEmptyValidator;
    } else if (value.length != 6) {
      return inValid;
    }

    String pattern = r"^[6-9]\d{9}$";
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return inValid;
    }

    return null;
  }

  // Email validation function
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    // Email pattern using RegExp
    final emailRegex = RegExp(
        r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

}