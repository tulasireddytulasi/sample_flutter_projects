import 'dart:convert';

UserMessagesModel userMessagesModelFromJson(String str) => UserMessagesModel.fromJson(json.decode(str));

String userMessagesModelToJson(UserMessagesModel data) => json.encode(data.toJson());

class UserMessagesModel {
  List<Message>? messages;

  UserMessagesModel({
    this.messages,
  });

  factory UserMessagesModel.fromJson(Map<String, dynamic> json) => UserMessagesModel(
    messages: json["messages"] == null ? [] : List<Message>.from(json["messages"]!.map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "messages": messages == null ? [] : List<dynamic>.from(messages!.map((x) => x.toJson())),
  };
}

class Message {
  bool? isUser;
  String? type;
  String? messageText;
  String? file;

  Message({
    this.isUser,
    this.type,
    this.messageText,
    this.file,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    isUser: json["isUser"],
    type: json["type"],
    messageText: json["messageText"],
    file: json["file"],
  );

  Map<String, dynamic> toJson() => {
    "isUser": isUser,
    "type": type,
    "messageText": messageText,
    "file": file,
  };
}
