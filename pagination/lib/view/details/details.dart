import 'package:flutter/material.dart';
import 'package:users_app/core/utils/custom_colors.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key, required this.imgURL, required this.imgTag});

  final String imgURL;
  final String imgTag;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.tealishBlue,
      appBar: AppBar(
        backgroundColor: CustomColors.tealishBlue,
        //centerTitle: false,
        title: const Text(
          "Actors Details Screen",
          style: TextStyle(
            fontSize: 24,
            color: CustomColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: CustomColors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: widget.imgURL.isEmpty
              ? const Text(
                  "No Image",
                  style: TextStyle(fontSize: 20, color: CustomColors.white),
                )
              : Hero(
                  tag: widget.imgTag,
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.network(widget.imgURL, fit: BoxFit.cover),
                  ),
                ),
        ),
      ),
    );
  }
}
