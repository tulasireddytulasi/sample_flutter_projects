import 'package:flutter/material.dart';
import 'package:flutter_appwrite/utils/assets_path.dart';
import 'package:lottie/lottie.dart';


class PrimaryButton extends StatefulWidget {
  const PrimaryButton({super.key, this.onPressed, required this.title, required this.isLoading});

  final void Function()? onPressed;
  final String title;
  final bool isLoading;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  final TextStyle textStyle = const TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  final TextStyle logoutTextStyle = const TextStyle(
    fontSize: 20,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  final double lottieSize = 40;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        textStyle: textStyle,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        // const CircleBorder(side: BorderSide(width: 1,)),
      ),
      child: widget.isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(
                  Assets.kBlueLoader,
                  reverse: false,
                  repeat: true,
                  animate: true,
                  width: lottieSize,
                  height: lottieSize,
                  fit: BoxFit.fill,
                ),

                Text("Loading", style: textStyle),
                const SizedBox(width: 10),
              ],
            )
          : Text(widget.title, style: logoutTextStyle),
    );
  }
}
