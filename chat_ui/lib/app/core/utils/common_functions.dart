import 'package:chat_ui/app/core/utils/app_values.dart';
import 'package:chat_ui/app/provider/movies_provider.dart';
import 'package:chat_ui/app/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CommonFunctions {
  String convertToTitleCase(String input) {
    List<String> words = input.split('_');
    for (int i = 0; i < words.length; i++) {
      words[i] = words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
    }
    return words.join(' ');
  }

  static void showRetrySnackBar() {
    try {
      if (AppValues.scaffoldMessengerKey.currentState?.mounted ?? false) {
        AppValues.scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(
            content: Text("No Internet Connection"),
          ),
        );
      }
    } catch (e) {}
  }

  static void toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      fontSize: 16.0,
      backgroundColor: Colors.green,
      timeInSecForIosWeb: 5,
      textColor: Colors.black,
      webShowClose: true,
    );
  }

  static Future<void> showLoading({required BuildContext context}) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }



  Future<DateTime> selectDate(BuildContext context, DateTime selectedDate) async {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
            data: ThemeData.light().copyWith(
              colorScheme:  ColorScheme.light(
                primary: themeProvider.colorScheme!.primary, /// Selected Color, cancel and ok text color
                onSurface: themeProvider.colorScheme!.secondary, /// Text Color
                onError: themeProvider.colorScheme!.error,
                onBackground: themeProvider.colorScheme!.background,
                surface: themeProvider.colorScheme!.background,
              ),
            ),
            child: child!);
      },
    );

    if (picked != null && picked != selectedDate) {
        selectedDate = picked;
    }
    return selectedDate;
  }

  void clearALLData({required BuildContext context}){
    final MoviesProvider moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    moviesProvider.clearAllData();
  }
}
