import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FileCard extends StatefulWidget {
  const FileCard({super.key, required this.filePath});

  final String filePath;

  @override
  State<FileCard> createState() => _FileCardState();
}

class _FileCardState extends State<FileCard> {
  String filePath = "";

  // "/data/user/0/com.example.flutter_appwrite/cache/ff881a10-af5c-498e-b64b-9cb6d1744ada/1000081406.jpg";

  onClick() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    filePath = image.path;
    print("filePath: $filePath");
    setState(() {});
  }

  double normalizeToProgressBar(double receivedValue, double minValue, double maxValue) {
    return (receivedValue - minValue) / (maxValue - minValue);
  }

  // Async* function to generate numbers from 0 to 100
  Stream<double> generateNumbers() async* {
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 10)); // Simulate delay
      final double val = normalizeToProgressBar(i.toDouble(), 0, 100);
      // if(i > 40) throw Exception("Upload Error 123");
      // print("val: $val");
      yield val; // Yield each number
    }
  }

  @override
  void initState() {
    super.initState();
    print("filePath: ${widget.filePath}");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: 300,
        height: 80,
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
              widget.filePath.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        File(widget.filePath),
                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                          return const Center(child: Text('This image type is not supported'));
                        },
                      ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(width: 10),
              StreamBuilder<double>(
                stream: generateNumbers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Waiting to Uploading...", style: Theme.of(context).textTheme.titleMedium);
                  } else if (snapshot.hasError) {
                    return SizedBox(
                      width: 200,
                      child: Text(
                        "Opps unknown error occurred...",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.red,
                            ),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final double val = snapshot.data as double;
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("File Uploading...", style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text("100%", style: Theme.of(context).textTheme.titleMedium),
                        SizedBox(
                          width: 200,
                          child: LinearProgressIndicator(
                            value: val,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        )
                      ],
                    );
                  } else {
                    return const Text('No data');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
