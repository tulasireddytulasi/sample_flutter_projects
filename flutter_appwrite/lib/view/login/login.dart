import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appwrite/provider/auth_provider.dart';
import 'package:flutter_appwrite/utils/app_validator.dart';
import 'package:flutter_appwrite/view/login/email_login.dart';
import 'package:flutter_appwrite/view/login/otp_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneNoController = TextEditingController();
  String countryCode = "+91";
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Screen", style: Theme.of(context).textTheme.titleLarge),
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
                  "Mobile No",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: phoneNoController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 10,
                  maxLines: 1,
                  validator: AppValidators.validateMobileNo,
                  decoration: const InputDecoration(
                    hintText: "Enter Mobile No",
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
                    MaterialPageRoute(builder: (context) => const EmailLoginScreen()),
                    (route) => false,
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.blueAccent.shade100),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    ),
                  ),
                  child: Text(
                    "Login with email",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        if (_formKey.currentState!.validate()) {
                          final String no = phoneNoController.text.trim();
                          final String num = countryCode + no;

                          final otpResponse = await authProvider.sendOTP(phoneNo: num);
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Failed to send otp: $e"),
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
                      "Login",
                      style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
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
