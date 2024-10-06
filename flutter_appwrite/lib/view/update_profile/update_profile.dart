import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appwrite/provider/profile_provider.dart';
import 'package:flutter_appwrite/utils/app_validator.dart';
import 'package:flutter_appwrite/view/widget/primary_button.dart';
import 'package:flutter_appwrite/view/widget/textfield_widget.dart';
import 'package:provider/provider.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  late ProfileProvider profileProvider;
  late TextEditingController nameController;
  late TextEditingController emailNoController;
  late TextEditingController phoneNoController;
  late ValueNotifier<bool> _isLoading;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _isLoading = ValueNotifier<bool>(false);
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    setProfileData();
  }

  setProfileData() {
    nameController = TextEditingController(text: profileProvider.data.first);
    emailNoController = TextEditingController(text: profileProvider.data[1]);
    phoneNoController = TextEditingController(text: profileProvider.data[2]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile Screen", style: Theme.of(context).textTheme.titleLarge),
        elevation: 4,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFieldWidget(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  maxLines: 1,
                  hintText: "Update Name",
                  validator: AppValidators.requiredField,
                ),
                const SizedBox(height: 20),
                TextFieldWidget(
                  controller: emailNoController,
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 1,
                  hintText: "Update Email",
                  validator: AppValidators.validateEmail,
                ),
                const SizedBox(height: 20),
                TextFieldWidget(
                  controller: phoneNoController,
                  keyboardType: TextInputType.phone,
                  maxLines: 1,
                  maxLength: 10,
                  hintText: "Update Mobile No",
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: AppValidators.validateMobileNo,
                ),
                const SizedBox(height: 20),
                const Spacer(),
                Center(
                  child: SizedBox(
                    width: 240,
                    height: 60,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _isLoading,
                      builder: (context, isLoading, child) {
                        return PrimaryButton(
                          title: "Update",
                          isLoading: isLoading,
                          onPressed: updateProfile,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateProfile() async {
    try {
      if (_formKey.currentState!.validate()) {
        if (_isLoading.value) return;
        _isLoading.value = true;
        final Map<String, dynamic> data = {
          "name": nameController.text.trim(),
          "phone_no": phoneNoController.text.trim(),
          "email": emailNoController.text.trim(),
        };
        final result = await profileProvider.updateProfileData(
          userId: profileProvider.userId,
          profileData: data,
        );
        if (!mounted) return;
        if (result.isSuccess) {
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to Update profile data"),
            ),
          );
        }
      }
    } catch (e) {
      _isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unknown error occurred"),
        ),
      );
    } finally {
      _isLoading.value = false;
    }
  }
}
