// To parse this JSON data, do
//
//     final blogModel = blogModelFromJson(jsonString);

import 'dart:convert';

List<BlogModel> blogModelFromJson(String str) =>
    List<BlogModel>.from(json.decode(str).map((x) => BlogModel.fromJson(x)));

String blogModelToJson(List<BlogModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BlogModel {
  String? id;
  String? title;
  List<BlogImage>? images;
  String? content;
  UserId? userId;
  String? category;
  DateTime? createdAt;
  int? v;

  BlogModel({
    this.id,
    this.title,
    this.images,
    this.content,
    this.userId,
    this.category,
    this.createdAt,
    this.v,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) => BlogModel(
        id: json["_id"],
        title: json["title"],
        images: json["images"] == null
            ? []
            : List<BlogImage>.from(
                json["images"]!.map((x) => BlogImage.fromJson(x))),
        content: json["content"],
        userId: json["userId"] == null ? null : UserId.fromJson(json["userId"]),
        category: json["category"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
        "content": content,
        "userId": userId?.toJson(),
        "category": category,
        "createdAt": createdAt?.toIso8601String(),
        "__v": v,
      };
}

class BlogImage {
  Type? type;
  List<int>? data;

  BlogImage({
    this.type,
    this.data,
  });

  factory BlogImage.fromJson(Map<String, dynamic> json) => BlogImage(
        type: typeValues.map[json["type"]]!,
        data: json["data"] == null
            ? []
            : List<int>.from(json["data"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "type": typeValues.reverse[type],
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
      };
}

enum Type { BUFFER }

final typeValues = EnumValues({"Buffer": Type.BUFFER});

class UserId {
  String? id;
  String? username;

  UserId({
    this.id,
    this.username,
  });

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json["_id"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

class Blog {
  String img;
  String title;
  String content;

  Blog({
    required this.img,
    required this.title,
    required this.content,
  });
}
