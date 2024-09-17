import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text("Details Screen"),),
      body: const Center(
        child: Text("Details Screen", style: TextStyle(fontSize: 24, color: Colors.black),),
      ),
    );
  }
}
