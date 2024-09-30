class MissingCredentialsException implements Exception {
  final String message;

  MissingCredentialsException(this.message);

  @override
  String toString() => message;
}

class Result<T, E> {
  final String? successMessage;
  final String? errorMessage;
  final T? success;
  final E? error;

  bool get isSuccess => success != null && error == null;

  Result({this.success, this.error, this.successMessage, this.errorMessage});
}
