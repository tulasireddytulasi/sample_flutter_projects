import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_appwrite/services/appwrite_config.dart';

class StorageService {
  final Client client;

  StorageService(this.client);

  // upload and save image to storage bucket (create new image)
  Future<File> uploadFileToBucket({required InputFile image}) async {
    Storage storage = Storage(client);
    try {
      final response = await storage.createFile(
        bucketId: AppwriteConfig.storageBucket,
        fileId: ID.unique(),
        file: image,
        onProgress: (progress){
          print("chunksTotal: ${progress.chunksTotal}");
          print("chunksUploaded: ${progress.chunksUploaded}");
          print("progress: ${progress.progress}");
          print("sizeUploaded: ${progress.sizeUploaded}");
        }
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteImageFromBucket({required String imageId}) async {
    Storage storage = Storage(client);
    try {
      await storage.deleteFile(bucketId: AppwriteConfig.storageBucket, fileId: imageId);
      return true;
    } catch (e) {
     rethrow;
    }
  }
}
