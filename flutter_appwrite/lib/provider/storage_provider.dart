import 'package:flutter/material.dart';
import 'package:flutter_appwrite/utils/app_exceptions.dart';

class StorageProvider extends ChangeNotifier {
  Future<Result<bool, String>> createFile() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      return Result(success: true);
    } catch (e) {
      return Result(error: "File Upload failed. Error: $e");
    }
  }
}
