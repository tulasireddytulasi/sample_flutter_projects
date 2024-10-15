import 'package:flutter/material.dart';
import 'package:flutter_appwrite/provider/auth_provider.dart';
import 'package:flutter_appwrite/provider/home_provider.dart';
import 'package:flutter_appwrite/provider/profile_provider.dart';
import 'package:flutter_appwrite/view/login/login.dart';
import 'package:flutter_appwrite/view/profile/widget/profile_pic_widget.dart';
import 'package:flutter_appwrite/view/update_profile/update_profile.dart';
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
  late HomeProvider homeProvider;
  late SharedPreferences sharedPreferences;
  late ValueNotifier<bool> _isLoading;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    _isLoading = ValueNotifier<bool>(false);
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
        title: Text("Profile Screen", style: Theme.of(context).textTheme.titleLarge),
        elevation: 4,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UpdateProfile(),
              ),
            ),
            icon: const Icon(Icons.mode_edit_rounded),
          ),
        ],
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
                    (index) => Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.4),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(
                              profileProvider.data[index],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                    )),
                const SizedBox(height: 30),
                const Spacer(),
                Center(
                  child: SizedBox(
                    width: 240,
                    height: 60,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _isLoading,
                      builder: (context, isLoading, child) {
                        return PrimaryButton(
                          title: "Logout",
                          isLoading: isLoading,
                          onPressed: logout,
                        );
                      },
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

  Future<void> logout() async {
    try {
      if (_isLoading.value) return;
      _isLoading.value = true;
      await homeProvider.subscriptionDispose();
      final logoutResponse = await authProvider.logout();
      if (!mounted) return;
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
    } catch (e) {
      print("Error: $e");
    } finally {
      _isLoading.value = false;
    }
  }
}
