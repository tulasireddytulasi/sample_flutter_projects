import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite/services/appwrite_client.dart';
import 'package:flutter_appwrite/services/auth_service.dart';
import 'package:flutter_appwrite/services/storage_service.dart';
import 'package:flutter_appwrite/services/user_service.dart';
import 'package:flutter_appwrite/utils/app_exceptions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appwrite/models.dart' as file_model;

class StorageProvider extends ChangeNotifier {
  final client = AppwriteClient().client;
  late AuthService authService;
  late UserService userService;
  late StorageService storageService;

  Future<void> init() async {
    authService = AuthService(client);
    userService = UserService(client);
    storageService = StorageService(client);
  }

  Future<Result<bool, String>> createFile({required XFile file}) async {
    try {
      final fileByes = await File(file.path).readAsBytes();
      final inputFile = InputFile.fromBytes(bytes: fileByes, filename: file.name);
      final file_model.File resFile = await storageService.uploadFileToBucket(image: inputFile);
      final String finalFileId = resFile.$id;
      // await Future.delayed(const Duration(seconds: 2));
      return Result(success: true, successMessage: "File Upload Successfully");
    } catch (e) {
      return Result(error: "createFile(): File Upload failed. Error: $e");
    }
  }
}
