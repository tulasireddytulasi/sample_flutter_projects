import 'package:flutter/material.dart';
import 'package:flutter_appwrite/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class ProfilePicWidget extends StatefulWidget {
  const ProfilePicWidget({super.key});

  @override
  State<ProfilePicWidget> createState() => _ProfilePicWidgetState();
}

class _ProfilePicWidgetState extends State<ProfilePicWidget> {
  late ProfileProvider profileProvider;

  @override
  void initState() {
    super.initState();
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
  }

  Future<void> updateProfilePic() async {
    await profileProvider.updateProfilePic(userId: profileProvider.userId, fileId: profileProvider.profilePicId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const SizedBox(
            width: 70.0,
            height: 70.0,
            child: CircularProgressIndicator(),
          );
        } else if (provider.profilePicId.isEmpty) {
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blueAccent, width: 4),
            ),
            child: IconButton(
              onPressed: updateProfilePic,
              icon: const Icon(Icons.person_rounded, size: 50),
            ),
          );
        } else {
          return InkWell(
            onTap: updateProfilePic,
            child: ClipOval(
              child: Image.network(
                profileProvider.profilePic,
                width: 70.0,
                height: 70.0,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Text(
                  "Error: $error",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
