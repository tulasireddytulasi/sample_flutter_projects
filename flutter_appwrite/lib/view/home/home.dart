import 'package:flutter/material.dart';
import 'package:flutter_appwrite/controllers/appwrite_controller.dart';
import 'package:flutter_appwrite/view/login/login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 30),
              const Text("Home Screen", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: () async {
                      final bool logoutSuccess = await AppwriteController().logout();
                      if(logoutSuccess){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to login with otp")));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      "Logout",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
