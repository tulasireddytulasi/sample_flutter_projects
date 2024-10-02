import 'package:flutter/material.dart';
import 'package:flutter_appwrite/view/widget/file_card.dart';
import 'package:image_picker/image_picker.dart';

class UploadFile extends StatefulWidget {
  const UploadFile({super.key});

  @override
  State<UploadFile> createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  final List<String> filePathsList = [];

  onClick() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? imagesList = await picker.pickMultiImage(limit: 10);
    if (imagesList == null || imagesList.isEmpty) return;
    imagesList.forEach((element) => filePathsList.add(element.path));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload File Screen", style: Theme.of(context).textTheme.titleMedium),
        elevation: 4,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ...List.generate(
                  filePathsList.length,
                  (index) {
                    return FileCard(filePath: filePathsList[index]);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onClick,
        shape: const CircleBorder(),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, size: 50, color: Colors.white),
      ),
    );
  }
}
