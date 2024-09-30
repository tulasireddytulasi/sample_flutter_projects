import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_appwrite/utils/app_exceptions.dart';


class AuthService {
  final Client client;

  AuthService(this.client);

  /// Check session exists or not
  Future<Result<Session, bool>> checkSession() async {
    Account account = Account(client);
    try {
      final Session session = await account.getSession(sessionId: "current");
      print("session: ${session}");
      return Result(success: session);
    } catch (e) {
      return Result(error: false);
    }
  }

  /// Logout the user and delete the session
  Future<Result<dynamic, String>> logout() async {
    Account account = Account(client);
    try {
      final res = await account.deleteSession(sessionId: "current");
      return Result(success: res);
    } catch (e) {
      return Result(error: "Unable to logout, error: $e");
    }
  }

  /// Login with OTP
  Future<Result<Session, bool>> loginWithOTP({required String otp, required String userId}) async {
    Account account = Account(client);
    try {
      final Session session = await account.updatePhoneSession(userId: userId, secret: otp);
      return Result(success: session);
    } catch (e) {
      return Result(error: false);
    }
  }

  /// Create or update a user token based on phone or email
  /// Sends OTP to phone no or email
  Future<Result<Token, String>> createPhoneOrEmailToken({
    required String userId,
    required String phoneNo,
    required String email,
  }) async {
    Account account = Account(client);
    try {
      late Token tokenData;
      if (phoneNo.isNotEmpty) {
        tokenData = await account.createPhoneToken(userId: userId, phone: phoneNo);
      } else if (email.isNotEmpty) {
        tokenData = await account.createEmailToken(userId: userId, email: email);
      }
      return Result(success: tokenData);
    } catch (e) {
      return Result(error: "Failed to create user token: $e");
    }
  }
}
