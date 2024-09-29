import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? userId;
  String? profilePic;
  String? name;
  String? phoneNo;
  String? email;

  UserModel({
    this.userId,
    this.profilePic,
    this.name,
    this.phoneNo,
    this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    userId: json["userId"] ?? "",
    profilePic: json["profile_pic"] ?? "",
    name: json["name"] ?? "",
    phoneNo: json["phone_no"] ?? "",
    email: json["email"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "profile_pic": profilePic,
    "name": name,
    "phone_no": phoneNo,
    "email": email,
  };
}
