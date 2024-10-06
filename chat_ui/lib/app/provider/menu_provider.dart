import 'package:flutter/material.dart';
import 'package:chat_ui/app/core/utils/dummy_data/users_list_data.dart';

class MenuProvider extends ChangeNotifier {
  int _selectedMenuIndex = 0;

  int get selectedMenuIndex => _selectedMenuIndex;

  int _selectedSubMenuIndex = 0;

  int get selectedSubMenuIndex => _selectedSubMenuIndex;

  set setSelectedMenuIndex(int selectedMenuIndex) {
    _selectedMenuIndex = selectedMenuIndex;
    notifyListeners();
  }

  set setSelectedSubMenuIndex(int selectedSubMenuIndex){
    _selectedSubMenuIndex = selectedSubMenuIndex;
    notifyListeners();
  }

  final Map<String, dynamic> _userList = UserDummyData.userList;
  Map<String, dynamic> get menuList => _userList;
}
