import 'package:flutter/material.dart';
import 'package:flutter_appwrite/controllers/appwrite_controller.dart';
import 'package:flutter_appwrite/view/login/login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String profilePic = "";
  String name = "";
  String email = "";
  String mobileNo = "";

  List<String> data = [];

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() {
    Map<String, dynamic> userData = AppwriteController().userData;
    print("yyyyyy: $userData");
    profilePic = userData["profile_pic"] ?? "";
    name = userData["name"] ?? "";
    mobileNo = userData["phone_no"] ?? "";
    email = userData["email"] ?? "";
    data = [name, email, mobileNo];
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
                  profilePic.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            profilePic,
                            width: 70.0,
                            height: 70.0,
                            fit: BoxFit.cover, // Ensures the image fits within the circle
                          ),
                        )
                      : Container(
                         decoration: BoxDecoration(
                           shape: BoxShape.circle,
                           border: Border.all(color: Colors.blueAccent, width: 4),
                         ),
                          child: IconButton(
                            onPressed: () {},
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
