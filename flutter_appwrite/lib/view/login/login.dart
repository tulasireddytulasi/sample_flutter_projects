import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appwrite/controllers/appwrite_controller.dart';
import 'package:flutter_appwrite/view/login/otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneNoController = TextEditingController();
  String countryCode = "+91";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Login Screen", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: phoneNoController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 10,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          if (_formKey.currentState!.validate()) {
                            final String no = phoneNoController.text.trim();
                            final String num = countryCode + no;
                            print("Number: $num");

                            final String userId = await AppwriteController().createPhoneSession(phoneNo: num);
                            if(userId != "login_error"){

                              Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen(userId: userId)));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to send otp")));
                            }
                          } else {
                            print("Please enter number");
                          }
                        } catch (e) {
                          print("Login Error 52: $e");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
