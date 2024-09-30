import 'package:appwrite/appwrite.dart';
import 'package:flutter_appwrite/services/appwrite_config.dart';

class AppwriteClient {
  static final AppwriteClient _instance = AppwriteClient._internal();
  late Client client;

  factory AppwriteClient() {
    return _instance;
  }

  AppwriteClient._internal() {
    client = Client()
        .setEndpoint(AppwriteConfig.baseUrl)
        .setProject(AppwriteConfig.projectId)
        .setSelfSigned(status: true);
  }
}
