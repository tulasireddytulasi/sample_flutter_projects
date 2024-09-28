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
  Future<bool> savePhoneToDB({String phoneNo = "", String email = "", required String userId}) async {
    try {
      final response = await database.createDocument(
        databaseId: db,
        collectionId: userCollection,
        documentId: userId,
        data: {"phone_no": phoneNo, "email": email, "userId": userId},
      );
      print("SavePhoneToDB Response: $response");
      return true;
    } on AppwriteException catch (e) {
      print("Cannot Save to DB Error: $e");
      return false;
    }
  }

  /// Check whether the phone no or email exists in DB ot not
  Future<String> checkPhoneNoOrEmail({String phoneNumber = "", String email = ""}) async {
    try {
      if (phoneNumber.isEmpty && email.isEmpty) return userNotExist;
      List<String> queries = [];

      if (phoneNumber.isNotEmpty && email.isEmpty) {
        queries = [Query.equal("phone_no", phoneNumber)];
      } else {
        queries = [Query.equal("email", email)];
      }

      final DocumentList matchUser = await database.listDocuments(
        databaseId: db,
        collectionId: userCollection,
        queries: queries,
      );

      if (matchUser.total > 0) {
        final Document userDoc = matchUser.documents.first;
        print("U Data: ${userDoc.toMap()}");

        if ((userDoc.data["phone_no"] != null) || (userDoc.data["email"] != null)) {
          return userDoc.data["userId"];
        } else {
          return userNotExist;
        }
      } else {
        return userNotExist;
      }
    } on AppwriteException catch (e) {
      print("User not exist Error: $e");
      throw MissingCredentialsException("User not exist Error: $e");
    }
  }

  // Create a phone or email session, send OTP to the phone number or email
  Future<String> createPhoneOrEmailSession({String phoneNo = "", String email = ""}) async {
    try {
      _validateCredentials(phoneNo, email);

      String userId = await checkPhoneNoOrEmail(phoneNumber: phoneNo, email: email);

      // If user doesn't exist, create a new account
      if (userId == userNotExist) {
        return await _createNewUserAccount(phoneNo, email);
      } else {
        // Existing user, generate token
        return await _generateToken(userId, phoneNo, email);
      }
    } on AppwriteException catch (e) {
      throw Exception("Error while creating session: ${e.message}");
    }
  }

  /// Validate if either phone number or email is provided
  void _validateCredentials(String phoneNo, String email) {
    if (phoneNo.isEmpty && email.isEmpty) {
      throw MissingCredentialsException("No Phone Number or Email provided");
    }
  }

  /// Create a new user account based on phone or email
  Future<String> _createNewUserAccount(String phoneNo, String email) async {
    if (phoneNo.isNotEmpty) {
      final Token tokenData = await account.createPhoneToken(userId: ID.unique(), phone: phoneNo);
      savePhoneToDB(phoneNo: phoneNo, userId: tokenData.userId);
      return tokenData.userId;
    } else if (email.isNotEmpty) {
      final Token tokenData = await account.createEmailToken(userId: ID.unique(), email: email);
      savePhoneToDB(email: email, userId: tokenData.userId);
      return tokenData.userId;
    }
    throw MissingCredentialsException("Account creation requires either a phone number or email.");
  }

  /// Generate token for an existing user based on phone or email
  Future<String> _generateToken(String userId, String phoneNo, String email) async {
    if (phoneNo.isNotEmpty) {
      final Token tokenData = await account.createPhoneToken(userId: userId, phone: phoneNo);
      return tokenData.userId;
    } else if (email.isNotEmpty) {
      final Token tokenData = await account.createEmailToken(userId: userId, email: email);
      return tokenData.userId;
    }
    throw MissingCredentialsException("Token generation requires either a phone number or email.");
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

class MissingCredentialsException implements Exception {
  final String message;

  MissingCredentialsException(this.message);

  @override
  String toString() => message;
}
