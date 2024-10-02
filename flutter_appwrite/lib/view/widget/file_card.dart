import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_appwrite/provider/storage_provider.dart';
import 'package:flutter_appwrite/utils/app_enums.dart';
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
  final double fileSize = 50;
  String filePath = "";
  late StorageProvider storageProvider;
  final String errorMessage = "Opps unknown error occurred...";
  final String successMessage = "File Uploaded successfully";

  Future<double> generateNumbers2() async {
    await Future.delayed(const Duration(seconds: 2));
    return 0.5;
  }

  @override
  void initState() {
    super.initState();
    storageProvider = Provider.of<StorageProvider>(context, listen: false);
    print("filePath: ${widget.file.path}");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: widget.width,
        height: 70,
        constraints: const BoxConstraints(maxWidth: 600),
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.lightBlue.withOpacity(0.4),
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
                  // if (fileUploadStatus == FileUploadStatus.loading)
                    const SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              const Center(child: Icon(Icons.check_circle_outline, size: 34, color: Colors.green,)),
            ],
          ),
        ),
      ),
    );
  }
}