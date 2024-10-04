// To parse this JSON data, do
//
//     final photoModel = photoModelFromJson(jsonString);

import 'dart:convert';

PhotoModel photoModelFromJson(String str) => PhotoModel.fromJson(json.decode(str));

String photoModelToJson(PhotoModel data) => json.encode(data.toJson());

class PhotoModel {
  String? photoId;
  String? filePath;
  String? title;
  String? description;
  List<String>? actorType;
  String? contentType;
  String? uploadedBy;
  List<String>? tags;
  DateTime? uploadDate;
  int? likes;
  int? downloads;

  PhotoModel({
    this.photoId,
    this.filePath,
    this.title,
    this.description,
    this.actorType,
    this.contentType,
    this.uploadedBy,
    this.tags,
    this.uploadDate,
    this.likes,
    this.downloads,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) => PhotoModel(
    photoId: json["photo_id"],
    filePath: json["file_path"],
    title: json["title"],
    description: json["description"],
    actorType: json["actor_type"] == null ? [] : List<String>.from(json["actor_type"]!.map((x) => x)),
    contentType: json["content_type"],
    uploadedBy: json["uploaded_by"],
    tags: json["tags"] == null ? [] : List<String>.from(json["tags"]!.map((x) => x)),
    uploadDate: json["upload_date"] == null ? null : DateTime.parse(json["upload_date"]),
    likes: json["likes"],
    downloads: json["downloads"],
  );

  Map<String, dynamic> toJson() => {
    "photo_id": photoId,
    "file_path": filePath,
    "title": title,
    "description": description,
    "actor_type": actorType == null ? [] : List<dynamic>.from(actorType!.map((x) => x)),
    "content_type": contentType,
    "uploaded_by": uploadedBy,
    "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
    "upload_date": uploadDate?.toIso8601String(),
    "likes": likes,
    "downloads": downloads,
  };
}
