import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class StorageService {
  final Client client;

  StorageService(this.client);

  // upload and save image to storage bucket (create new image)
  Future<File> uploadFileToBucket({required InputFile image, required String bucketId}) async {
    Storage storage = Storage(client);
    try {
      final response = await storage.createFile(
        bucketId: bucketId,
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

  Future<bool> deleteImageFromBucket({required String bucketId,required String imageId}) async {
    Storage storage = Storage(client);
    try {
      await storage.deleteFile(bucketId: bucketId, fileId: imageId);
      return true;
    } catch (e) {
     rethrow;
    }
  }
}
