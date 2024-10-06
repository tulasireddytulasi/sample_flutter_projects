class AppValidators {
  static String? requiredField(value) {
    const String kEmptyValidator = "This field is required.";

    if (value == null || value.isEmpty) {
      return kEmptyValidator;
    }

    return null;
  }

  static String? requiredAadhaar(value) {
    const String kEmptyValidator = "This field is required.";
    const String inValid = "Invalid aadhaar no.";

    if (value == null || value.isEmpty) {
      return kEmptyValidator;
    } else  if (value.length != 12) {
      return inValid;
    }
    return null;
  }
}