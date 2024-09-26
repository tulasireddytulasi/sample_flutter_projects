import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class AppwriteController {
  static final AppwriteController _appwriteController = AppwriteController._internal();

  factory AppwriteController() {
    return _appwriteController;
  }

  AppwriteController._internal();

  static const String baseUrl = "https://cloud.appwrite.io/v1";
  static const String projectId = "66f551fd000e245c106b";
  static const String db = "66f57ca0001a649eaf8c";
  static const String userCollection = "66f57cdf003c6a01af11";
  static const String userNotExist = "user_not_exist";

  Client client = Client().setEndpoint(baseUrl).setProject(projectId).setSelfSigned(status: true);
  // For self signed certificates, only use for development

  late Account account;
  late Databases database;

  setConnection() {
    account = Account(client);
    database = Databases(client);
  }

  /// Save phone no to DB while creating new user account
  Future<bool> savePhoneToDB({required String phoneNo, required String userId}) async {
    try {
      final response = await database.createDocument(databaseId: db, collectionId: userCollection, documentId: userId, data: {"phone_no": phoneNo, "userId": userId});
      print("SavePhoneToDB Response: $response");
      return true;
    } on AppwriteException catch (e) {
      print("Cannot Save to DB Error: $e");
      return false;
    }
  }

  /// Check whether the phone no exists in DB ot not
  Future<String> checkPhoneNumber({required String phoneNumber}) async {
    try {
      final DocumentList matchUser = await database.listDocuments(databaseId: db, collectionId: userCollection, queries: [Query.equal("phone_no", phoneNumber)]);

      if (matchUser.total > 0) {
        final Document userDoc = matchUser.documents.first;

        if (userDoc.data["phone_no"] != null || userDoc.data["phone_no"] != "") {
          return userDoc.data["userId"];
        } else {
          print(userNotExist);
          return userNotExist;
        }
      } else {
        print(userNotExist);
        return userNotExist;
      }
    } on AppwriteException catch (e) {
      print("User not exist Error: $e");
      return userNotExist;
    }
  }

  /// Create a phone session, send OTP to the phone no
  Future<String> createPhoneSession({required String phoneNo}) async {
    try {
      final userId = await checkPhoneNumber(phoneNumber: phoneNo);

      if (userId == userNotExist) {
        /// Creates new User Account
        final Token tokenData = await account.createPhoneToken(userId: ID.unique(), phone: phoneNo);
        savePhoneToDB(phoneNo: phoneNo, userId: tokenData.userId);
        return tokenData.userId;
      } else {
        final Token tokenData = await account.createPhoneToken(userId: userId, phone: phoneNo);
        return tokenData.userId;
      }
    } on AppwriteException catch (e) {
      print("Error on create phone session: $e");
      return "login_error";
    }
  }

  /// Login with OTP
  Future<bool> loginWithOTP({required String otp, required String userId}) async {
    try {
      final Session session = await account.updatePhoneSession(userId: userId, secret: otp);
      print("Login Success : ${session.userId}");
      return true;
    } catch (e) {
      print("Login Fail : $e");
      return false;
    }
  }

  /// Check session exists ot not
  Future<bool> checkSession() async {
    try {
      final Session session = await account.getSession(sessionId: "current");
      print("Login Success : ${session.$id}");
      return true;
    } catch (e) {
      print("Login Fail : $e");
      return false;
    }
  }

  /// Logout the user and delete the session
  Future<bool> logout() async {
    try {
      final res = await account.deleteSession(sessionId: "current");
      print("Logout success: ${res.toString()}");
      return true;
    } catch (e) {
      print("Logout fail error: $e");
      return false;
    }
  }
}
