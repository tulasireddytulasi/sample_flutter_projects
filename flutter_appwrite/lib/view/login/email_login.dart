import 'package:flutter/material.dart';
import 'package:flutter_appwrite/provider/auth_provider.dart';
import 'package:flutter_appwrite/utils/app_validator.dart';
import 'package:flutter_appwrite/view/Login/otp_screen.dart';
import 'package:flutter_appwrite/view/login/login.dart';
import 'package:flutter_appwrite/view/widget/primary_button.dart';
import 'package:provider/provider.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  late AuthProvider authProvider;
  late ValueNotifier<bool> _isLoading;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    _isLoading = ValueNotifier<bool>(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Email Login Screen", style: Theme.of(context).textTheme.titleLarge),
        elevation: 4,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                const Text(
                  "Email",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  maxLines: 1,
                  validator: AppValidators.validateEmail,
                  decoration: const InputDecoration(
                    hintText: "Enter your email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.blueAccent.shade100),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    ),
                  ),
                  child: Text(
                    "Login with mobile",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
                  ),
                ),
                const Spacer(),
                Center(
                  child: SizedBox(
                    width: 240,
                    height: 60,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _isLoading,
                      builder: (context, hasConsent, child) {
                        return PrimaryButton(
                          title: "Email Login",
                          isLoading: _isLoading.value,
                          onPressed: emailLogin,
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

  Future<void> emailLogin() async {
    try {
      if (_formKey.currentState!.validate()) {
        if (_isLoading.value) return;
        _isLoading.value = true;
        final String email = emailController.text.trim();
        final otpResponse = await authProvider.sendOTP(email: email);

        /// DON'T use BuildContext across asynchronous gaps.
        if (!context.mounted) return;
        if (otpResponse.isSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(userId: otpResponse.success!.userId),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to send otp"),
            ),
          );
        }
      }
    } catch (e) {
      print("Email Login Error: $e");
    } finally {
      _isLoading.value = false;
    }
  }
}
