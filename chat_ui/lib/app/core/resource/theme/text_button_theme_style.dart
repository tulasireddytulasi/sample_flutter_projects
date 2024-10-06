import 'package:chat_ui/app/core/utils/color_palette.dart';
import 'package:flutter/material.dart';

@immutable
class TextButtonThemeStyle extends ButtonStyle {
  final Color? enabledTextColor, disabledTextColor;
  final EdgeInsets? buttonPadding;
  final TextStyle? customTextStyle;
  const TextButtonThemeStyle({
    this.disabledTextColor,
    this.enabledTextColor,
    this.buttonPadding,
    this.customTextStyle,
  });

  @override
  MaterialStateProperty<EdgeInsetsGeometry?>? get padding {
    return buttonPadding == null ? const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 20, vertical: 10)) : MaterialStatePropertyAll<EdgeInsets>(buttonPadding!);
  }

  @override
  MaterialStateProperty<Color?>? get overlayColor {
    return MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      return enabledTextColor?.withOpacity(0.2) ?? ColorPalette.primaryColor.withOpacity(0.2);
    });
  }

  @override
  MaterialStateProperty<Color?>? get foregroundColor {
    return MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return disabledTextColor ?? ColorPalette.whitePrimaryColor.shade100;
        }

        return enabledTextColor ?? ColorPalette.primaryColor;
      },
    );
  }

  @override
  MaterialStateProperty<TextStyle?>? get textStyle {
    return customTextStyle == null ? null : MaterialStatePropertyAll<TextStyle?>(customTextStyle);
  }
}
