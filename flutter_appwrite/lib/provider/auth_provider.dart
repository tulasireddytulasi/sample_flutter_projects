import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite/services/appwrite_client.dart';
import 'package:flutter_appwrite/services/auth_service.dart';
import 'package:flutter_appwrite/services/user_service.dart';
import 'package:flutter_appwrite/utils/app_exceptions.dart';
import 'package:flutter_appwrite/utils/app_extensions.dart';

class AuthProvider extends ChangeNotifier {
  final client = AppwriteClient().client;
  late AuthService authService;
  late UserService userService;

  /// Initialize
  Future<void> init() async {
    authService = AuthService(client);
    userService = UserService(client);
  }

  Future<Result<bool, bool>> checkSession() async {
    final res = await authService.checkSession();
    if (res.isSuccess) {
      return Result(success: res.isSuccess);
    } else {
      return Result(error: false);
    }
  }

  Future<Result<bool, bool>> loginWithOTP({required String otp, required String userId}) async {
    final res = await authService.loginWithOTP(otp: otp, userId: userId);
    if (res.isSuccess) {
      return Result(success: res.isSuccess);
    } else {
      return Result(error: false);
    }
  }

  Future<Result<Token, bool>> sendOTP({String? phoneNo, String? email}) async {
    try {
      if (phoneNo.isNullOrEmpty && email.isNullOrEmpty) {
        return Result(error: false, errorMessage: "No Phone Number or Email provided");
      }

      List<String> queries = [];

      if (phoneNo.isNotNullOrNotEmpty && email.isNullOrEmpty) {
        queries = [Query.equal("phone_no", phoneNo)];
      } else {
        queries = [Query.equal("email", email)];
      }

      final usersList = await userService.getDocumentsList(queries: queries);

      if (!usersList.isSuccess) {
        return Result(error: false, errorMessage: usersList.error);
      }

      Result<Token, String> tokenResponse;
      Document userDocument;
      if (usersList.success!.total > 0) {
        userDocument = usersList.success!.documents.first;
        final String userId = userDocument.data["userId"];
        tokenResponse = await authService.createPhoneOrEmailToken(
          email: email ?? "",
          phoneNo: phoneNo ?? "",
          userId: userId.isNullOrEmpty ? ID.unique() : userId,
        );
      } else {
        tokenResponse = await authService.createPhoneOrEmailToken(userId: ID.unique(), email: email ?? "", phoneNo: phoneNo ?? "");
        Map<String, dynamic> data = {"phone_no": phoneNo, "email": email, "userId": tokenResponse.success!.userId};
        final resultDoc = await userService.createDocument(userId: tokenResponse.success!.userId, data: data);
        if (resultDoc.isSuccess) userDocument = resultDoc.success!;
      }

      // Todo: Save data in Local DB

      if (tokenResponse.isSuccess) {
        return Result(success: tokenResponse.success, successMessage: "OTP send successfully");
      } else {
        return Result(error: false, errorMessage: tokenResponse.error);
      }
    } catch (g, e) {
      return Result(error: false, errorMessage: "Unknown error of send otp: $e");
    }
  }

  Future<Result<bool, bool>> logout() async {
    final res = await authService.logout();
    return Result(success: res.isSuccess);
  }
}
