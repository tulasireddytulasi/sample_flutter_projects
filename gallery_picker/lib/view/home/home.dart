import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  String filePic = "";

  getImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      filePic = image.path;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Gallery Picker",
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                getImage();
                // requestPhotoPermission();
                // requestCameraPermission();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text(
                "Pick Image",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            filePic.isNotEmpty
                ? Center(
                    child: Container(
                      width: 300,
                      height: 600,
                      margin: const EdgeInsets.all(8.0),
                      child: Image.file(
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        File(filePic),
                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                          return const Center(child: Text('This image type is not supported'));
                        },
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Future<void> requestPhotoPermission() async {
    // Check the current status of the photo permission
    var status = await Permission.photos.status;

    // If the permission is not granted, request it
    if (!status.isGranted) {
      await Permission.photos.request();
    }

    // You can also handle different states like denied, permanently denied, etc.
    if (await Permission.photos.isGranted) {
      // Permission granted, proceed with accessing photos
      print("Photos permission granted.");
    } else if (await Permission.photos.isDenied) {
      // Permission denied by the user
      print("Photos permission denied.");
    } else if (await Permission.photos.isPermanentlyDenied) {
      // Permission permanently denied, open app settings
      openAppSettings();
    }
  }

  Future<void> requestCameraPermission() async {
    // Check the current status of the camera permission
    var status = await Permission.camera.status;

    // If the permission is not granted, request it
    if (!status.isGranted) {
      await Permission.camera.request();
    }

    // Handle different states like granted, denied, permanently denied, etc.
    if (await Permission.camera.isGranted) {
      // Permission granted, proceed with camera access
      print("Camera permission granted.");
    } else if (await Permission.camera.isDenied) {
      // Permission denied by the user
      print("Camera permission denied.");
    } else if (await Permission.camera.isPermanentlyDenied) {
      // Permission permanently denied, open app settings
      openAppSettings();
    }
  }
}
