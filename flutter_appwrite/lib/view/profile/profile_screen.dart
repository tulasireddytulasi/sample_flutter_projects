import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite/provider/auth_provider.dart';
import 'package:flutter_appwrite/provider/profile_provider.dart';
import 'package:flutter_appwrite/view/login/login.dart';
import 'package:flutter_appwrite/view/profile/widget/profile_pic_widget.dart';
import 'package:flutter_appwrite/view/widget/primary_button.dart';
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
    final width = MediaQuery.of(context).size.width;
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
                    const ProfilePicWidget(),
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
                Selector<ProfileProvider, bool>(
                    selector: (_, provider) => provider.isLoading,
                    builder: (context, isLoading, child) {
                    return SizedBox(
                      width: 240,
                      height: 60,
                      child: PrimaryButton(
                        title: "Logout",
                        isLoading: isLoading,
                        onPressed: () async {
                          profileProvider.setIsLoading = true;
                          final logoutResponse = await authProvider.logout();
                          profileProvider.setIsLoading = false;
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
                      ),
                    );
                  }
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
