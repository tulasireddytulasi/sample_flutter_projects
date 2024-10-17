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
import 'package:flutter_appwrite/utils/common_functins.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appwrite/models.dart' as file_model;

class ProfileProvider extends ChangeNotifier {
  final client = AppwriteClient().client;
  late AuthService authService;
  late UserService userService;
  late StorageService storageService;
  UserModel userModel = UserModel();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

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

  List<String> _data = [];
  List<String> get data => _data;
  String filePic = "";

  set setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void clearUserData() async {
    userId = "";
    name = "";
    email = "";
    mobileNo = "";
    profilePicId = "";
    profilePic = "";
    _data.clear();
  }

  void setUserData() async {
    userId = userModel.userId.toString();
    name = userModel.name.toString();
    profilePicId = userModel.profilePic.toString();
    profilePic = profilePicId.isNotEmpty
        ? getFileLink(
      fileId: profilePicId,
      bucketId: AppwriteConfig.profileBucketId,
    )
        : "";
    _data = [userModel.name.toString(), userModel.email.toString(), userModel.phoneNo.toString()];
  }

  Future<Result<bool, String>> getUserDetails({required String documentId}) async {
    try {
      setIsLoading = true;
      final userDocument = await userService.getDocument(documentId: documentId);

      if (userDocument.isSuccess) {
        userModel = userModelFromJson(json.encode(userDocument.success?.data));
        //isLoading = false;
        setUserData();
        notifyListeners();
        return Result(success: true, successMessage: "Successfully fetched document");
      } else {
        return Result(error: userDocument.error, errorMessage: userDocument.errorMessage);
      }
    } catch (e, s) {
      print("getUserDetails Error: $e");
      print("getUserDetails Error Stack: $s");
      return Result(error: "getUserDetails(): Error: $e", errorMessage: "Error stack: $s");
    } finally {
      setIsLoading = false;
    }
  }

  Future<Result<String, String>> updateProfilePic({required String userId, required String fileId}) async {
    try {
      setIsLoading = true;
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return Result(error: "Unable to get pic from gallery");

      filePic = image.path;

      final fileByes = await File(filePic).readAsBytes();
      final inputFile = InputFile.fromBytes(bytes: fileByes, filename: image.name);
      file_model.File file;
      String finalFileId = "";

      // if image already exist for the user profile or not
      if (fileId.isNotEmpty) {
        // then update the image
        file = await storageService.uploadFileToBucket(image: inputFile, bucketId: AppwriteConfig.profileBucketId);
        await storageService.deleteImageFromBucket(bucketId: AppwriteConfig.profileBucketId, imageId: fileId);
        finalFileId = file.$id;
      } else {
        file = await storageService.uploadFileToBucket(image: inputFile, bucketId: AppwriteConfig.profileBucketId);
        finalFileId = file.$id;
      }

      final document = await userService.updateDocument(
        userId: userId,
        data: {"profile_pic": finalFileId},
      );

      userModel = userModelFromJson(json.encode(document.success?.data));
      setUserData();
      return Result(success: profilePic);
    } catch (e, s) {
      // isLoading = false;
      return Result(error: "Unable to update profile Pic. Error: $e", errorMessage: "Error Stack: $s");
    } finally {
      setIsLoading = false;
    }
  }

  Future<Result<bool, String>> updateProfileData({
    required String userId,
    required Map<String, dynamic> profileData,
  }) async {
    try {
      final document = await userService.updateDocument(
        userId: userId,
        data: profileData,
      );

      userModel = userModelFromJson(json.encode(document.success?.data));
      setUserData();
      notifyListeners();
      return Result(success: true);
    } catch (e, s) {
      // isLoading = false;
      return Result(error: "Unable to update profile Info. Error: $e", errorMessage: "Error Stack: $s");
    } finally {
      setIsLoading = false;
    }
  }
}
