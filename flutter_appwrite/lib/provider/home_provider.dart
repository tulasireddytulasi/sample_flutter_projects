import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite/services/appwrite_client.dart';
import 'package:flutter_appwrite/services/appwrite_config.dart';
import 'package:flutter_appwrite/services/auth_service.dart';
import 'package:flutter_appwrite/services/user_service.dart';
import 'package:flutter_appwrite/utils/app_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider extends ChangeNotifier {
  final client = AppwriteClient().client;
  late AuthService authService;
  late UserService userService;
  late SharedPreferences sharedPreferences;
  late Realtime realtime;
  RealtimeSubscription? subscription;


  Future<void> init() async {
    authService = AuthService(client);
    userService = UserService(client);
    realtime = Realtime(client);
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> subscriptionDispose() async {
    subscription?.close();
  }

  Future<Result<DocumentList, String>> getGalleryPhotos({required List<String> queries}) async {
    try {
      // List<String> queries = [Query.limit(5)];

      final usersList = await userService.getDocumentsList(
        collectionId: AppwriteConfig.photoCollection,
        queries: queries,
      );

      print("usersList: ${usersList.success?.total}");
      print("getDocumentsList: ${usersList.success?.documents}");

      if (!usersList.isSuccess) {
        return Result(error: usersList.error, errorMessage: usersList.errorMessage);
      } else {
        return Result(success: usersList.success, successMessage: "Get Photos Success");
      }
    } catch (e, s) {
      print("Get Photos Error: $e");
      return Result(error: "Get Photos Error: $e", errorMessage: "Get Photos Error Stack: $s");
    }
  }

  // Subscribe to realtime changes
  Future<void> subscribeToRealtime() async {
    subscription = realtime.subscribe([
      "databases.${AppwriteConfig.db}.collections.${AppwriteConfig.userCollection}.documents",
    ]);

    print("Subscribed to realtime data: ${subscription?.channels}");

    subscription!.stream.listen((data) {
      print("Some event happened");
      print("Events happened ${data.events}");
      print("Data payload ${data.payload}");
      final firstItem = data.events.first.split(".");
      final eventType = firstItem.lastOrNull;
      print("Event type is $eventType");
    });
  }
}
