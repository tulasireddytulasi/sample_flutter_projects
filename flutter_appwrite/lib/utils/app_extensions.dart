extension StringExtensions on String? {
  bool get isNullOrEmpty {
    return this == null || this!.isEmpty;
  }
}

extension StringExtension2 on String? {
  bool get isNotNullOrNotEmpty {
    return this != null && this!.isNotEmpty;
  }
}