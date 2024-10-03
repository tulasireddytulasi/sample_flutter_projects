import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_appwrite/provider/storage_provider.dart';
import 'package:flutter_appwrite/utils/app_enums.dart';
import 'package:flutter_appwrite/utils/app_exceptions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FileCard extends StatefulWidget {
  const FileCard({super.key, required this.file, required this.width});

  final XFile file;
  final double width;

  @override
  State<FileCard> createState() => _FileCardState();
}

class _FileCardState extends State<FileCard> {
  late ValueNotifier<FileUploadStatus> _status;
  final double fileSize = 50;
  String filePath = "";
  late StorageProvider storageProvider;
  final String errorMessage = "Opps unknown error occurred...";
  final String successMessage = "File Uploaded successfully";
  late IconData icon;
  late Color iconColor;
  late Color cardColor;
  late Color progressColor;

  Future<void> uploadFileToBucket() async {
    try {
      Result<bool, String> res = await storageProvider.createFile(file: widget.file);
      if (!res.isSuccess) {
        return fileUploadError();
      }
      // await Future.delayed(const Duration(seconds: 2));
      fileUploadSuccess();
    } catch (e) {
      print("filePath error: $e");
      fileUploadError();
    }
  }

  void fileUploadSuccess() {
    iconColor = Colors.green;
    icon = Icons.check_circle_outline;
    progressColor = Colors.blue;
    cardColor = Colors.lightBlue.withOpacity(0.4);
    _status.value = FileUploadStatus.success;
  }

  void fileUploadLoading() {
    icon = Icons.cloud_upload_outlined;
    iconColor = Colors.grey;
    cardColor = Colors.yellow.withOpacity(0.4);
    progressColor = Colors.yellow;
    _status = ValueNotifier<FileUploadStatus>(FileUploadStatus.loading);
  }

  void fileUploadError() {
    iconColor = Colors.red;
    icon = Icons.clear_rounded;
    cardColor = Colors.red.withOpacity(0.4);
    _status.value = FileUploadStatus.error;
  }

  @override
  void initState() {
    super.initState();
    storageProvider = Provider.of<StorageProvider>(context, listen: false);
    fileUploadLoading();
    print("filePath: ${widget.file.path}");
    uploadFileToBucket();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ValueListenableBuilder<FileUploadStatus>(
        valueListenable: _status,
        builder: (context, isLoading, child) {
          return Container(
            width: widget.width,
            height: 70,
            constraints: const BoxConstraints(maxWidth: 600),
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  widget.file.path.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            width: fileSize,
                            height: fileSize,
                            fit: BoxFit.cover,
                            File(widget.file.path),
                            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                              return const Center(child: Text('This image type is not supported'));
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(widget.file.name, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 0),
                      Text(
                        "456 kb / kb",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.black.withOpacity(0.4),
                              fontSize: 14,
                            ),
                      ),
                      if (_status.value == FileUploadStatus.loading)
                        const SizedBox(
                          width: 200,
                          child: LinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                          ),
                        ),
                    ],
                  ),
                  const Spacer(),
                  Center(
                    child: Icon(icon, size: 34, color: iconColor),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
