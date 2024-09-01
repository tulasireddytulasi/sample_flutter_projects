import 'package:expense_tracker/core/utils/color_palette.dart';
import 'package:flutter/material.dart';

class AppStyles {
  AppStyles._();

  static const TextStyle bigTextStyle = TextStyle(
    fontSize: 20,
    color: ColorPalette.primary,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle mediumTextStyle = TextStyle(
    fontSize: 14,
    color: ColorPalette.primary,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle smallTextStyle = TextStyle(
    fontSize: 12,
    color: ColorPalette.primary,
    fontWeight: FontWeight.normal,
  );
}
