import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appwrite/provider/auth_provider.dart';
import 'package:flutter_appwrite/utils/app_validator.dart';
import 'package:flutter_appwrite/view/home/home.dart';
import 'package:flutter_appwrite/view/widget/primary_button.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.userId});

  final String userId;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();
  late AuthProvider authProvider;
  late ValueNotifier<bool> _isLoading;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    _isLoading = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  Future<void> otpLogin() async {
    try {
      if (_formKey.currentState!.validate()) {
        if (_isLoading.value) return;
        _isLoading.value = true;
        final String otp = otpController.text.trim();
        final loginSuccess = await authProvider.loginWithOTP(otp: otp, userId: widget.userId);

        if (loginSuccess.isSuccess) {
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to login with otp"),
            ),
          );
        }
      } else {
        print("Please enter OTP");
      }
    } catch (e) {
      print("OTP Error: $e");
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Screen", style: Theme.of(context).textTheme.titleMedium),
        elevation: 4,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("OTP Screen", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                TextFormField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: AppValidators.validateOTP,
                  maxLength: 10,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    counterText: "",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                ),
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
                          title: "Login with OTP",
                          isLoading: isLoading,
                          onPressed: otpLogin,
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
}
