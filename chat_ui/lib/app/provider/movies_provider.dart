import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoviesProvider extends ChangeNotifier {

  int _currentWidget = 1;

  int get currentWidget => _currentWidget;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set setCurrentWidget(int currentWidget) {
    _currentWidget = currentWidget;
    notifyListeners();
  }

  set setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  clearAllData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    _currentWidget = 1;
    _isLoading = false;
  }
}

