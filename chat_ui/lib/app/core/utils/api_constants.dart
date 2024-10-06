class APIConstant {
  APIConstant._();

  static const String appNameKey = "APP_NAME";
  static const String baseURLKey = "BASE_URL";
  static const String envKey = "ENV";

  static List<String> get unauthorizedRequests => [getMoviesAPI];

  static String get getMoviesAPI => "/movies/popular";
}
