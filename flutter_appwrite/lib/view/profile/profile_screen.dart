import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite/controllers/appwrite_controller.dart';
import 'package:flutter_appwrite/controllers/local_data.dart';
import 'package:flutter_appwrite/model/user_model.dart';
import 'package:flutter_appwrite/view/login/login.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userId = "";
  String profilePic = "";
  String profilePicId = "";
  String name = "N/A";
  String email = "N/A";
  String mobileNo = "N/A";

  List<String> data = [];

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  String filePic = "";

  getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      filePic = image.path;
      await updateProfilePic(image: image);
    }
    setState(() {});
  }

  Future<void> updateProfilePic({required XFile image}) async {
    try {
      final fileByes = await File(filePic).readAsBytes();
      final inputFile = InputFile.fromBytes(bytes: fileByes, filename: image.name);
      String fileId = "";

      // if image already exist for the user profile or not
      if (profilePicId.isNotEmpty) {
        // then update the image
        fileId = await AppwriteController().updateImageOnBucket(image: inputFile, oldImageId: profilePicId) ?? "";
      } else {
        fileId = await AppwriteController().saveImageToBucket(image: inputFile) ?? "";
      }
      await AppwriteController().updateUserData(userId: userId, profilePic: fileId);
      await getUserData();
    } catch (e) {
      print("Update profile Pic error: $e");
    }
  }

  getUserData() async {
    String userData = await LocalSavedData.getUserData();
    final userModel = userModelFromJson(userData.toString());
    userId = userModel.userId.toString();
    profilePicId = userModel.profilePic.toString();
    profilePic = AppwriteController().getFileLink(fileId: profilePicId);
    data = [userModel.name.toString(), userModel.email.toString(), userModel.phoneNo.toString()];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Screen", style: Theme.of(context).textTheme.titleMedium),
        elevation: 4,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  profilePicId.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            profilePic,
                            width: 70.0,
                            height: 70.0,
                            fit: BoxFit.cover,
                          ),
                        )
                      : filePic.isNotEmpty
                          ? ClipOval(
                              child: Image.file(
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                File(filePic),
                                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                  return const Center(child: Text('This image type is not supported'));
                                },
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.blueAccent, width: 4),
                              ),
                              child: IconButton(
                                onPressed: getImage,
                                icon: const Icon(Icons.person_rounded, size: 50),
                              ),
                            ),
                  const SizedBox(height: 10),
                  Text(
                    name.isNotEmpty ? name : "Leonidas",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              ...List.generate(
                  data.length,
                  (index) => ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(data[index]),
                      )),
              const SizedBox(height: 30),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: () async {
                      final bool logoutSuccess = await AppwriteController().logout();
                      if (!context.mounted) return;
                      if (logoutSuccess) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Failed to login with otp"),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
