class AppwriteConfig {
  static final AppwriteConfig _instance = AppwriteConfig._internal();

  static const String baseUrl = "https://cloud.appwrite.io/v1";
  static const String projectId = "66f551fd000e245c106b";
  static const String db = "66f57ca0001a649eaf8c";
  static const String userCollection = "66f57cdf003c6a01af11";
  static const String userNotExist = "user_not_exist";
  static const String storageBucket = "66f80fa10004fb30e2aa";

  factory AppwriteConfig() {
    return _instance;
  }

  AppwriteConfig._internal();
}
