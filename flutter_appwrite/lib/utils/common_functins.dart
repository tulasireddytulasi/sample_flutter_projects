import 'package:flutter_appwrite/services/appwrite_config.dart';

String getFileLink({required String bucketId, required String fileId}) {
  final String fileLink = '{baseUrl}/storage/buckets/{bucketId}/files/{fileId}/view?project={projectId}'
      .replaceAll('{baseUrl}', AppwriteConfig.baseUrl)
      .replaceAll('{bucketId}', bucketId)
      .replaceAll('{fileId}', fileId)
      .replaceAll('{projectId}', AppwriteConfig.projectId);

  return fileLink;
}