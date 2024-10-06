import 'package:chat_ui/app/core/utils/color_palette.dart';
import 'package:chat_ui/app/core/utils/constants.dart';
import 'package:flutter/material.dart';

class AppStyles {
  static final AppStyles _instance = AppStyles._();

  AppStyles._();

  factory AppStyles.init(BuildContext con) {
    return _instance;
  }

  /// used for button text
  static TextStyle buttonStyle = const TextStyle(
    fontSize: 16,
    color: ColorPalette.whitePrimaryColor,
    fontFamily: Constants.montserratBold,
  );

  /// used to give style to hint hint of TextFormField,dropdown button
  static TextStyle hintStyle = TextStyle(
    fontSize: 16,
    color: ColorPalette.blackPrimaryColor.shade100,
    fontFamily: Constants.montserratRegular,
  );

  /// used to give style to error text of TextFormField,dropdown items
  static TextStyle errorStyle = const TextStyle(
    fontSize: 12,
    color: ColorPalette.red,
    fontFamily: Constants.montserratRegular,
  );

  /// used to give style to text such as privacy policy. terms and conditions
  static TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: ColorPalette.blackPrimaryColor.shade100,
    fontFamily: Constants.montserratRegular,
  );

  /// used to give style to text of TextFormField, dropdowns items
  static TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    color: ColorPalette.blackPrimaryColor.shade400,
    fontFamily: Constants.montserratRegular,
  );

  /// used to give style for title for TextFormField dropdown items
  static TextStyle titleSmall = TextStyle(
    fontSize: 18,
    color: ColorPalette.blackPrimaryColor.shade400,
    fontFamily: Constants.montserratRegular,
  );

  static TextStyle titleMedium = TextStyle(
    fontSize: 18,
    color: ColorPalette.blackPrimaryColor.shade400,
    fontFamily: Constants.montserratRegular,
  );

  static TextStyle titleBig = TextStyle(
    fontSize: 20,
    color: ColorPalette.primaryColor.shade800,
    fontFamily: Constants.montserratBold,
  );
}
