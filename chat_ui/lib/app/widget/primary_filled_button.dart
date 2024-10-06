import 'package:chat_ui/app/core/resource/theme/filled_button_theme_style.dart';
import 'package:chat_ui/app/core/utils/assets_path.dart';
import 'package:chat_ui/app/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class PrimaryFilledButton extends StatefulWidget {
  /// [buttonTitle] is button text
  /// [widgetKey] is assigned to [FilledButton] so that it can used for automation
  final String buttonTitle, widgetKey;

  /// [buttonThemeStyle] is optional. if its not set i will access it from [filledButtonTheme] of [AppTheme.light] method
  final FilledButtonThemeStyle? buttonThemeStyle;

  /// callback for button click
  final void Function()? onPressed;

  final bool isLoading;

  const PrimaryFilledButton({
    super.key,
    required this.buttonTitle,
    required this.widgetKey,
    this.onPressed,
    this.buttonThemeStyle,
    this.isLoading = false,
  });

  @override
  State<PrimaryFilledButton> createState() => _PrimaryFilledButtonState();
}

class _PrimaryFilledButtonState extends State<PrimaryFilledButton> {
  late ThemeProvider themeProvider;

  @override
  void initState() {
    super.initState();
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: FilledButton(
              key: Key(widget.widgetKey),
              onPressed: widget.onPressed,
              style: widget.buttonThemeStyle,
              child: TextLoaderWidget(
                title: widget.buttonTitle,
                currentTheme: themeProvider.currentTheme,
                isLoading: widget.isLoading,
                textStyle: themeProvider.bodySmall!.copyWith(fontSize: 16, color: themeProvider.colorScheme?.background),
              ),
            ),
    );
  }
}

class TextLoaderWidget extends StatelessWidget {
  const TextLoaderWidget({
    super.key,
    required this.currentTheme,
    required this.textStyle,
    required this.isLoading, required this.title,
  });
  final ThemeEnum currentTheme;
  final TextStyle textStyle;
  final bool isLoading;
  final String title;

  @override
  Widget build(BuildContext context) {
    return isLoading ? Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Loading", style: textStyle),
        const SizedBox(width: 10),
        Lottie.asset(
          currentTheme == ThemeEnum.pink ? Assets.pinkLoader : Assets.blueLoader,
          reverse: false,
          repeat: true,
          animate: true,
          width: 24,
          height: 24,
          fit: BoxFit.fill,
        ),
      ],
    ) : Text(title);
  }
}