import 'package:chat_ui/app/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_ui/app/core/utils/constants.dart';

class LabelWidget extends StatelessWidget {
  const LabelWidget({super.key, required this.isDesktopScreen, required this.text});

  final bool isDesktopScreen;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return Text(
        text,
        style: themeProvider.titleMedium?.copyWith(
          fontSize: isDesktopScreen ? 14 : 12,
          fontFamily: isDesktopScreen ? Constants.montserratRegular : Constants.montserratMedium,
        ),
      );
    });
  }
}
