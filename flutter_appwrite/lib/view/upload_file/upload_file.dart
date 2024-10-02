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
    final List<XFile> imagesList = await picker.pickMultiImage(limit: 10);
    if (imagesList.isEmpty) return;
    for (var element in imagesList) {
      filePathsList.add(element.path);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload File", style: Theme.of(context).textTheme.titleLarge),
        elevation: 4,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
        actions: [
          IconButton(
              onPressed: () {
               filePathsList.clear();
               setState(() {});
              },
              icon: const Icon(Icons.clear, size: 32)),
        ],
      ),
      body: SafeArea(
        child: filePathsList.isEmpty
            ? Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      radius: 40,
                      child: IconButton(
                        onPressed: onClick,
                        icon: const Icon(
                          Icons.add,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Upload Files",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
            )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ...List.generate(
                      filePathsList.length,
                      (index) {
                        return FileCard(width: width/1.1, filePath: filePathsList[index]);
                      },
                    ),
                  ],
                ),
              ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: onClick,
      //   shape: const CircleBorder(),
      //   backgroundColor: Colors.green,
      //   child: const Icon(Icons.add, size: 50, color: Colors.white),
      // ),
    );
  }
}
