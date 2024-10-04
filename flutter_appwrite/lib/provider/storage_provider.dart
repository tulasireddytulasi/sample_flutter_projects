import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite/services/appwrite_client.dart';
import 'package:flutter_appwrite/services/appwrite_config.dart';
import 'package:flutter_appwrite/services/auth_service.dart';
import 'package:flutter_appwrite/services/storage_service.dart';
import 'package:flutter_appwrite/services/user_service.dart';
import 'package:flutter_appwrite/utils/app_exceptions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appwrite/models.dart' as file_model;
import 'package:shared_preferences/shared_preferences.dart';

class StorageProvider extends ChangeNotifier {
  final client = AppwriteClient().client;
  late AuthService authService;
  late UserService userService;
  late StorageService storageService;
  late SharedPreferences sharedPreferences;
  String type = "select";

  Future<void> init() async {
    authService = AuthService(client);
    userService = UserService(client);
    storageService = StorageService(client);
    sharedPreferences = await SharedPreferences.getInstance();
  }

  set setType(String typeVal) => type = typeVal;

  Future<Result<bool, String>> createFile({required XFile file}) async {
    try {
      final fileByes = await File(file.path).readAsBytes();
      final inputFile = InputFile.fromBytes(bytes: fileByes, filename: file.name);
      final file_model.File resFile = await storageService.uploadFileToBucket(
        image: inputFile,
        bucketId: AppwriteConfig.galleryBucketId,
      );
      final String finalFileId = resFile.$id;
      // await Future.delayed(const Duration(seconds: 2));
      final String userId = sharedPreferences.getString("userId") ?? "";
      if (finalFileId.isNotEmpty) {
        final String docId = ID.unique();
        Map<String, dynamic> data = {
          "photo_id": docId,
          "file_path": finalFileId,
          "actor_type": type,
          "uploaded_by": userId,
          "upload_date": DateTime.now().toIso8601String(),
        };

        final Result<file_model.Document, String> resultDoc = await userService.createDocument(
          userId: docId,
          collectionId: AppwriteConfig.photoCollection,
          data: data,
        );

        if(!resultDoc.isSuccess) {
          return Result(error: resultDoc.error);
        }
      }
      return Result(success: true, successMessage: "File Upload Successfully");
    } catch (e) {
      return Result(error: "createFile(): File Upload failed. Error: $e");
    }
  }
}
