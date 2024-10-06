import 'package:chat_ui/app/core/utils/constants.dart';
import 'package:chat_ui/app/core/utils/screen_sizes.dart';
import 'package:chat_ui/app/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum SuffixButton {noButton, primaryButton, calenderButton, loader}

class TextFormFieldWidget extends StatefulWidget {
  final TextInputType? textInputType;
  final String hintText;
  final TextEditingController controller;
  final TextInputAction? actionKeyboard;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? onValidate;
  final int? maxLength;
  final String? suffixText;
  final double maxWidth;
  final EdgeInsetsGeometry? contentPadding;
  final VoidCallback? onClick;
  final SuffixButton suffixButton;
  final bool isOnClickDisabled;
  final bool readOnly;

  const TextFormFieldWidget({
    super.key,
    required this.hintText,
    this.textInputType,
    required this.controller,
    this.actionKeyboard = TextInputAction.next,
    this.inputFormatters,
    required this.onChanged,
    this.onValidate,
    this.maxLength,
    this.suffixText,
    required this.maxWidth,
    this.contentPadding,
    this.onClick,
    this.suffixButton = SuffixButton.noButton,
    this.isOnClickDisabled = false,
    this.readOnly = false,
  });

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  late ThemeProvider themeProvider;
  late Color primaryColor, secondaryColor;

  @override
  void initState() {
    super.initState();
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    primaryColor = themeProvider.colorScheme!.primaryContainer;
    secondaryColor = themeProvider.currentThemeData!.colorScheme.secondary.withOpacity(0.4);
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktopScreen = isDesktop(screenWidth: widget.maxWidth);
    return TextFormField(
      readOnly: widget.readOnly,
      keyboardType: widget.textInputType,
      textInputAction: widget.actionKeyboard,
      inputFormatters: widget.inputFormatters,
      maxLength: widget.maxLength,
      style: themeProvider.bodyMedium?.copyWith(fontSize: isDesktopScreen ? 14 : 12),
      cursorColor: themeProvider.colorScheme?.primary,
      onChanged: (String? newValue) {
        widget.onChanged(newValue);
      },
      decoration: InputDecoration(
        isDense: true,
        contentPadding: widget.contentPadding ??
            (isDesktopScreen
                ? const EdgeInsets.all(20)
                : const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 14,
                  )),
        hintText: widget.hintText,
        hintStyle: themeProvider.hintStyle?.copyWith(fontSize: isDesktopScreen ? 14 : 12),
        errorMaxLines: 3,
        counterText: "",
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: themeProvider.colorScheme!.error, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: primaryColor, width: 5),
        ),
        suffixIcon: suffixButton(
                color: widget.isOnClickDisabled ? Theme.of(context).disabledColor : primaryColor,
                isDesktopScreen: isDesktopScreen,
                suffixText: widget.suffixText ?? "",
            textStyle: widget.isOnClickDisabled ? themeProvider.bodyMedium!.copyWith(color: secondaryColor) : themeProvider.bodyMedium!,
            onClick: widget.onClick,
            suffixButton: widget.suffixButton),
      ),
      controller: widget.controller,
      validator: widget.onValidate,
    );
  }
}

suffixButton({
  required SuffixButton suffixButton,
  void Function()? onClick,
  required bool isDesktopScreen,
  required Color color,
  required String suffixText,
  required TextStyle textStyle,
}) {
  switch(suffixButton){
    case SuffixButton.noButton : return null;
    case SuffixButton.primaryButton : return PrimaryButton(
      color: color,
      isDesktopScreen: isDesktopScreen,
      suffixText: suffixText,
      textStyle: textStyle,
      onClick: onClick,
    );
    case SuffixButton.calenderButton : return calenderButton(onClick: onClick);
    case SuffixButton.loader:
      return Loader(
        color: color,
        isDesktopScreen: isDesktopScreen,
      );
    default: return null;
  }
}

InkWell calenderButton({void Function()? onClick}){
  return InkWell(
    onTap: onClick,
    child: const Icon(
      Icons.calendar_month_outlined,
      color: Colors.black,
      size: 20,
    ),
  );
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.onClick,
    required this.isDesktopScreen,
    required this.color,
    required this.suffixText,
    required this.textStyle,
  });

  final void Function()? onClick;
  final bool isDesktopScreen;
  final Color color;
  final String suffixText;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        width: isDesktopScreen ? 120 : 90,
        height: 50,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          color: color,
        ),
        child: Text(
          suffixText,
          style: textStyle.copyWith(
            fontFamily: isDesktopScreen ? Constants.montserratSemiBold : Constants.montserratMedium,
            fontSize: isDesktopScreen ? 14 : 12,
          ),
        ),
      ),
    );
  }
}

class Loader extends StatelessWidget {
  const Loader({super.key, required this.isDesktopScreen, required this.color});
  final bool isDesktopScreen;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isDesktopScreen ? 120 : 90,
      height: 50,
      alignment: Alignment.center,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        color: color,
      ),
      child: const CircularProgressIndicator(),
    );
  }
}
