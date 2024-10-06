import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';

enum ThemeEnum { blue, pink }

class ThemeProvider extends ChangeNotifier {
  ThemeEnum currentTheme = ThemeEnum.pink;
  static ThemeProvider? _instance;

  static ThemeProvider get instance {
    _instance ??= ThemeProvider._init();
    return _instance!;
  }

  ThemeProvider._init();

  ColorScheme? colorScheme;
  ThemeData? currentThemeData;
  TextTheme? textTheme;
  TextStyle? titleBig;
  TextStyle? titleMedium;
  TextStyle? bodyMedium;
  TextStyle? bodySmall;
  TextStyle? errorStyle;
  TextStyle? hintStyle;

  Future<void> changeTheme(ThemeEnum theme) async {
    currentTheme = theme;
    await _generateThemeData();
    textTheme = currentThemeData?.textTheme;
    colorScheme = currentThemeData?.colorScheme;
    titleBig = textTheme?.headlineMedium;
    titleMedium = textTheme?.headlineSmall;
    bodyMedium = textTheme?.bodyMedium;
    bodySmall = textTheme?.bodySmall;
    errorStyle = textTheme?.bodySmall?.copyWith(color: colorScheme?.error);
    hintStyle = textTheme?.bodyMedium?.copyWith(color: currentThemeData?.hintColor);
    notifyListeners();
  }

  Future<void> _generateThemeData() async {
    String themeStr = await rootBundle.loadString(_getThemeJsonPath());
    Map themeJson = jsonDecode(themeStr);
    currentThemeData = ThemeDecoder.decodeThemeData(themeJson);
  }

  String _getThemeJsonPath() {
    switch (currentTheme) {
      case ThemeEnum.blue:
        return "assets/themes/blue_theme.json";
      case ThemeEnum.pink:
        return "assets/themes/pink_theme.json";
      default:
        return "assets/themes/blue_theme.json";
    }
  }
}
