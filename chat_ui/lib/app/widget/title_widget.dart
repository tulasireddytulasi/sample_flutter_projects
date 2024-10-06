import 'package:chat_ui/app/core/utils/assets_path.dart';
import 'package:chat_ui/app/core/utils/color_palette.dart';
import 'package:chat_ui/app/core/utils/constants.dart';
import 'package:chat_ui/app/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    super.key,
    required this.isDesktopScreen,
    required this.title,
    required this.subTitle,
  });

  final bool isDesktopScreen;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 40,
            height: 40,
            child: CircleAvatar(
              backgroundImage: ExactAssetImage(Assets.girl),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: themeProvider.titleBig?.copyWith(
                  fontSize: isDesktopScreen ? 14 : 12,
                  color: ColorPalette.whitePrimaryColor,
                  fontFamily: Constants.montserratRegular,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorPalette.green,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    subTitle,
                    style: themeProvider.titleMedium?.copyWith(
                      fontSize: isDesktopScreen ? 12 : 12,
                      color: ColorPalette.whitePrimaryColor.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    });
  }
}
