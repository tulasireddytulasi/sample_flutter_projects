import 'package:flutter/material.dart';
import 'package:chat_ui/app/core/utils/color_palette.dart';
import 'package:chat_ui/app/core/utils/constants.dart';

class ChatTextWidget extends StatelessWidget {
  const ChatTextWidget({super.key, required this.text, required this.isUser});

  final String text;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Align(
      key: Key(UniqueKey().toString()),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            //width: 250,
            child: Container(
              //alignment: Alignment.topRight,
              constraints: const BoxConstraints(maxWidth: 350),
              decoration:  BoxDecoration(
                color: ColorPalette.purple,
                borderRadius: isUser ? const BorderRadius.only(topLeft: Radius.circular(6.0)) :
                const BorderRadius.only(topRight: Radius.circular(6.0)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Text(
                text,
                softWrap: true,
                style: const TextStyle(
                  fontSize: 14,
                  color: ColorPalette.whitePrimaryColor,
                  fontFamily: Constants.montserratRegular,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
