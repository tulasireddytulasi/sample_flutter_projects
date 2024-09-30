import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite/provider/auth_provider.dart';
import 'package:flutter_appwrite/provider/profile_provider.dart';
import 'package:flutter_appwrite/view/login/login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late AuthProvider authProvider;
  late ProfileProvider profileProvider;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    getUserData();
  }

  Future<void> getUserData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String userId = sharedPreferences.getString("userId") ?? "";
    if(profileProvider.profilePicId.isEmpty && userId.isNotEmpty) {
      profileProvider.getUserDetails(documentId: userId);
    }
  }

  updateProfilePic() async {
    await profileProvider.updateProfilePic(userId: profileProvider.userId, fileId: profileProvider.profilePicId);
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
          child: Consumer<ProfileProvider>(builder: (context, profileProvider, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    profileProvider.profilePicId.isNotEmpty
                        ? InkWell(
                            onTap: updateProfilePic,
                            child: ClipOval(
                              child: Image.network(
                                profileProvider.profilePic,
                                width: 70.0,
                                height: 70.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : profileProvider.filePic.isNotEmpty
                            ? InkWell(
                                onTap: updateProfilePic,
                                child: ClipOval(
                                  child: Image.file(
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    File(profileProvider.filePic),
                                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                      return const Center(child: Text('This image type is not supported'));
                                    },
                                  ),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.blueAccent, width: 4),
                                ),
                                child: IconButton(
                                  onPressed: updateProfilePic,
                                  icon: const Icon(Icons.person_rounded, size: 50),
                                ),
                              ),
                    const SizedBox(height: 10),
                    Text(
                      profileProvider.name.isNotEmpty ? profileProvider.name : "Leonidas",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ...List.generate(
                    profileProvider.data.length,
                    (index) => ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(profileProvider.data[index]),
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
                        final logoutResponse = await authProvider.logout();
                        if (!context.mounted) return;
                        if (logoutResponse.isSuccess) {
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
            );
          }),
        ),
      ),
    );
  }
}
