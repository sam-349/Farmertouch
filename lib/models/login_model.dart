// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  String? message;
  User? user;

  LoginModel({
    this.message,
    this.user,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        message: json["message"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "user": user?.toJson(),
      };
}

class User {
  String? id;
  String? username;
  String? mail;
  String? password;
  String? phonenumber;
  String? location;
  Pic? pic;
  String? type;
  int? v;

  User({
    this.id,
    this.username,
    this.mail,
    this.password,
    this.phonenumber,
    this.location,
    this.pic,
    this.type,
    this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        username: json["username"],
        mail: json["mail"],
        password: json["password"],
        phonenumber: json["phonenumber"],
        location: json["location"],
        pic: json["pic"] == null ? null : Pic.fromJson(json["pic"]),
        type: json["type"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "mail": mail,
        "password": password,
        "phonenumber": phonenumber,
        "location": location,
        "pic": pic?.toJson(),
        "type": type,
        "__v": v,
      };
}

class Pic {
  String? type;
  List<int>? data;

  Pic({
    this.type,
    this.data,
  });

  factory Pic.fromJson(Map<String, dynamic> json) => Pic(
        type: json["type"],
        data: json["data"] == null
            ? []
            : List<int>.from(json["data"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
      };
}
