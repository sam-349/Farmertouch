// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(
    json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  String? id;
  String? userId;
  String? productName;
  String? productId;
  String? productType;
  int? price;
  int? quantity;
  Image_pro? image;
  int? v;

  ProductModel({
    this.id,
    this.userId,
    this.productName,
    this.productId,
    this.productType,
    this.price,
    this.quantity,
    this.image,
    this.v,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["_id"],
        userId: json["userId"],
        productName: json["productName"],
        productId: json["productId"],
        productType: json["productType"],
        price: json["price"],
        quantity: json["quantity"],
        image: json["image"] == null ? null : Image_pro.fromJson(json["image"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "productName": productName,
        "productId": productId,
        "productType": productType,
        "price": price,
        "quantity": quantity,
        "image": image?.toJson(),
        "__v": v,
      };
}

class Image_pro {
  String? type;
  List<int>? data;

  Image_pro({
    this.type,
    this.data,
  });

  factory Image_pro.fromJson(Map<String, dynamic> json) => Image_pro(
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
