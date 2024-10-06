// To parse this JSON data, do
//
//     final userListModel = userListModelFromJson(jsonString);

import 'dart:convert';

UserListModel userListModelFromJson(String str) => UserListModel.fromJson(json.decode(str));

String userListModelToJson(UserListModel data) => json.encode(data.toJson());

class UserListModel {
  List<UsersList>? usersList;

  UserListModel({
    this.usersList,
  });

  factory UserListModel.fromJson(Map<String, dynamic> json) => UserListModel(
    usersList: json["usersList"] == null ? [] : List<UsersList>.from(json["usersList"]!.map((x) => UsersList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "usersList": usersList == null ? [] : List<dynamic>.from(usersList!.map((x) => x.toJson())),
  };
}

class UsersList {
  String? icon;
  String? name;
  String? mainRoutes;
  String? lasMessage;
  String? lastDateTime;

  UsersList({
    this.icon,
    this.name,
    this.mainRoutes,
    this.lasMessage,
    this.lastDateTime,
  });

  factory UsersList.fromJson(Map<String, dynamic> json) => UsersList(
    icon: json["icon"],
    name: json["name"],
    mainRoutes: json["mainRoutes"],
    lasMessage: json["lasMessage"],
    lastDateTime: json["lastDateTime"],
  );

  Map<String, dynamic> toJson() => {
    "icon": icon,
    "name": name,
    "mainRoutes": mainRoutes,
    "lasMessage": lasMessage,
    "lastDateTime": lastDateTime,
  };
}
