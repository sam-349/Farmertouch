// To parse this JSON data, do
//
//     final farmer = farmerFromJson(jsonString);

import 'dart:convert';

List<Farmer> farmerFromJson(String str) =>
    List<Farmer>.from(json.decode(str).map((x) => Farmer.fromJson(x)));

String farmerToJson(List<Farmer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Farmer {
  String? id;
  String? username;
  String? mail;
  String? password;
  String? phonenumber;
  String? location;
  Pic? pic;
  String? type;
  int? v;

  Farmer({
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

  factory Farmer.fromJson(Map<String, dynamic> json) => Farmer(
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
