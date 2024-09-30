import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_appwrite/services/appwrite_config.dart';
import 'package:flutter_appwrite/utils/app_exceptions.dart';

class UserService {
  final Client client;

  UserService(this.client);

  /// Get Documents List
  Future<Result<DocumentList, String>> getDocumentsList({List<String>? queries}) async {
    try {
      Databases database = Databases(client);
      final DocumentList documentList = await database.listDocuments(
        databaseId: AppwriteConfig.db,
        collectionId: AppwriteConfig.userCollection,
        queries: queries,
      );
      return Result(success: documentList);
    } catch (e) {
      return Result(error: "Unable to fetch documents. Error: $e");
    }
  }

  /// Create a new document
  Future<Result<Document, String>> createDocument({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    try {
      Databases database = Databases(client);
      final response = await database.createDocument(
        databaseId: AppwriteConfig.db,
        collectionId: AppwriteConfig.userCollection,
        documentId: userId,
        data: data,
      );
      return Result(success: response);
    } catch (e) {
      return Result(error: "Unable to create a new document. Error: $e");
    }
  }

  /// Update a existing document
  Future<Result<Document, String>> updateDocument({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    try {
      Databases database = Databases(client);
      final response = await database.updateDocument(
        databaseId: AppwriteConfig.db,
        collectionId: AppwriteConfig.userCollection,
        documentId: userId,
        data: data,
      );
      return Result(success: response);
    } catch (e) {
      return Result(error: "Unable to update a existing document. Error: $e");
    }
  }
}
