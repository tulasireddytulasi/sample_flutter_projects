import 'dart:convert';
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite/model/user_model.dart';
import 'package:flutter_appwrite/services/appwrite_client.dart';
import 'package:flutter_appwrite/services/appwrite_config.dart';
import 'package:flutter_appwrite/services/auth_service.dart';
import 'package:flutter_appwrite/services/storage_service.dart';
import 'package:flutter_appwrite/services/user_service.dart';
import 'package:flutter_appwrite/utils/app_exceptions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appwrite/models.dart' as fileModel;

class ProfileProvider extends ChangeNotifier {
  final client = AppwriteClient().client;
  late AuthService authService;
  late UserService userService;
  late StorageService storageService;
  UserModel userModel = UserModel();

  /// Initialize
  Future<void> init() async {
    authService = AuthService(client);
    userService = UserService(client);
    storageService = StorageService(client);
  }

  String userId = "";
  String profilePic = "";
  String profilePicId = "";
  String name = "N/A";
  String email = "N/A";
  String mobileNo = "N/A";
  bool isLoading = false;

  List<String> data = [];
  String filePic = "";

  Future<Result<bool, String>> getUserDetails({required String documentId}) async {
    try {
      isLoading = true;
      notifyListeners();
      final userDocument = await userService.getDocument(documentId: documentId);

      if (userDocument.isSuccess) {
        userModel = userModelFromJson(json.encode(userDocument.success?.data));
        isLoading = false;
        setUserData();
        return Result(success: true, successMessage: "Successfully fetched document");
      } else {
        return Result(error: userDocument.error, errorMessage: userDocument.errorMessage);
      }
    } catch (e, s) {
      print("getUserDetails Error: $e");
      print("getUserDetails Error Stack: $s");
      return Result(error: "getUserDetails(): Error: $e", errorMessage: "Error stack: $s");
    }
  }

  Future<Result<String, String>> updateProfilePic({required String userId, required String fileId}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return Result(error: "Unable to get pic from gallery");

      filePic = image.path;

      final fileByes = await File(filePic).readAsBytes();
      final inputFile = InputFile.fromBytes(bytes: fileByes, filename: image.name);
      fileModel.File file;
      String finalFileId = "";

      isLoading = true;
      notifyListeners();

      // if image already exist for the user profile or not
      if (fileId.isNotEmpty) {
        // then update the image
        file = await storageService.uploadFileToBucket(image: inputFile);
        await storageService.deleteImageFromBucket(imageId: fileId);
        finalFileId = file.$id;
      } else {
        file = await storageService.uploadFileToBucket(image: inputFile);
        finalFileId = file.$id;
      }

      final document = await userService.updateDocument(
        userId: userId,
        data: {"profile_pic": finalFileId},
      );

      userModel = userModelFromJson(json.encode(document.success?.data));
      setUserData();
      isLoading = false;
      notifyListeners();
      return Result(success: profilePic);
    } catch (e, s) {
      isLoading = false;
      return Result(error: "Unable to update profile Pic. Error: $e", errorMessage: "Error Stack: $s");
    }
  }

  void setUserData() async {
    userId = userModel.userId.toString();
    profilePicId = userModel.profilePic.toString();
    profilePic = profilePicId.isNotEmpty ? getFileLink(fileId: profilePicId) : "";
    data = [userModel.name.toString(), userModel.email.toString(), userModel.phoneNo.toString()];
    notifyListeners();
  }

  String getFileLink({required String fileId}) {
    final String fileLink = "${AppwriteConfig.baseUrl}/storage/buckets/${AppwriteConfig.storageBucket}/files/$fileId/view?project=${AppwriteConfig.projectId}";
    return fileLink;
  }
}
