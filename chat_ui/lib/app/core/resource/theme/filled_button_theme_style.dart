import 'package:flutter/material.dart';

@immutable
class FilledButtonThemeStyle extends ButtonStyle {
  final Color? enabledButtonColor, disabledButtonColor;
  final Color? enabledTextColor, disabledTextColor;
  final EdgeInsets? buttonPadding;
  final TextStyle? customTextStyle;
  final BuildContext context;

  const FilledButtonThemeStyle(this.context, {
    this.disabledButtonColor,
    this.disabledTextColor,
    this.enabledButtonColor,
    this.enabledTextColor,
    this.buttonPadding,
    this.customTextStyle,
  });

  @override
  MaterialStateProperty<Color?>? get backgroundColor {
    return MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return disabledButtonColor ?? Theme.of(context).disabledColor;
        }

        return enabledButtonColor ?? Theme.of(context).colorScheme.primary;
      },
    );
  }

  @override
  MaterialStateProperty<EdgeInsetsGeometry?>? get padding {
    return buttonPadding == null ? const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 20, vertical: 10)) : MaterialStatePropertyAll<EdgeInsets>(buttonPadding!);
  }

  @override
  MaterialStateProperty<Color?>? get foregroundColor {
    return MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return disabledTextColor ?? Theme.of(context).colorScheme.background;
        }

        return enabledTextColor ?? Theme.of(context).colorScheme.background;
      },
    );
  }
  @override
  MaterialStateProperty<TextStyle?>? get textStyle{
    return customTextStyle == null ? null: MaterialStatePropertyAll<TextStyle?>(customTextStyle);
  }
}
