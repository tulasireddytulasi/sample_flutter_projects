import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appwrite/controllers/appwrite_controller.dart';
import 'package:flutter_appwrite/view/home/home.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.userId});
  final String userId;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();

  void otpLogin() async {
    try {
      if (_formKey.currentState!.validate()) {
        final String otp = otpController.text.trim();
        print("otp Number: $otp, id: ${widget.userId}");

        final bool loginSuccess = await AppwriteController().loginWithOTP(otp: otp, userId: widget.userId);
        if(loginSuccess){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen(),));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to login with otp")));
        }
      } else {
        print("Please enter OTP");
      }
    } catch (e) {
      print("OTP Error 52: $e");
    }
  }

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
                  const Text("OTP Screen", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: otpController,
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
                      onPressed: otpLogin,
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
