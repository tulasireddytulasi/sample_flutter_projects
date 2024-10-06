import 'package:flutter/material.dart';
import 'package:chat_ui/app/core/utils/assets_path.dart';
import 'package:chat_ui/app/core/utils/color_palette.dart';
import 'package:chat_ui/app/core/utils/dummy_data/users_list_data.dart';

class ImageTextWidget extends StatelessWidget {
  const ImageTextWidget({super.key, required this.text, required this.image, required this.isUser});

  final String text;
  final String image;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: SizedBox(
        width: 250,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              alignment: isUser ? Alignment.topRight : Alignment.topLeft,
              decoration:  BoxDecoration(
                color: ColorPalette.purple,
                borderRadius: isUser ?  const BorderRadius.only(
                  topLeft: Radius.circular(6.0),
                ): const BorderRadius.only(
                  topRight: Radius.circular(6.0),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Text(
                text,
                softWrap: true,
                style: const TextStyle(
                  fontSize: 14,
                  color: ColorPalette.whitePrimaryColor,
                ),
              ),
            ),
            Visibility(
              visible: image.isNotEmpty,
              child: Container(
                height: 140,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: isUser ? const BorderRadius.only(
                    bottomLeft: Radius.circular(6.0), // Bottom-left corner radius
                  ) : const BorderRadius.only(
                    bottomRight: Radius.circular(6.0), // Bottom-left corner radius
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
