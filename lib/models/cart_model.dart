// To parse this JSON data, do
//
//     final cart = cartFromJson(jsonString);

import 'dart:convert';

Cart cartFromJson(String str) => Cart.fromJson(json.decode(str));

String cartToJson(Cart data) => json.encode(data.toJson());

class Cart {
  List<CartItem>? cartItems;

  Cart({
    this.cartItems,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        cartItems: json["cartItems"] == null
            ? []
            : List<CartItem>.from(
                json["cartItems"]!.map((x) => CartItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cartItems": cartItems == null
            ? []
            : List<dynamic>.from(cartItems!.map((x) => x.toJson())),
      };
}

class CartItem {
  String? id;
  Productid? productid;
  String? userId;
  int? qty;
  int? v;

  CartItem({
    this.id,
    this.productid,
    this.userId,
    this.qty,
    this.v,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json["_id"],
        productid: json["productid"] == null
            ? null
            : Productid.fromJson(json["productid"]),
        userId: json["user_id"],
        qty: json["qty"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "productid": productid?.toJson(),
        "user_id": userId,
        "qty": qty,
        "__v": v,
      };
}

class Productid {
  String? id;
  UserId? userId;
  String? productName;
  String? productId;
  String? productType;
  int? price;
  int? quantity;
  Image_cart? image;
  int? v;

  Productid({
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

  factory Productid.fromJson(Map<String, dynamic> json) => Productid(
        id: json["_id"],
        userId: json["userId"] == null ? null : UserId.fromJson(json["userId"]),
        productName: json["productName"],
        productId: json["productId"],
        productType: json["productType"],
        price: json["price"],
        quantity: json["quantity"],
        image:
            json["image"] == null ? null : Image_cart.fromJson(json["image"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId?.toJson(),
        "productName": productName,
        "productId": productId,
        "productType": productType,
        "price": price,
        "quantity": quantity,
        "image": image?.toJson(),
        "__v": v,
      };
}

class Image_cart {
  String? type;
  List<int>? data;

  Image_cart({
    this.type,
    this.data,
  });

  factory Image_cart.fromJson(Map<String, dynamic> json) => Image_cart(
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

class UserId {
  String? id;
  String? username;
  String? mail;
  String? phonenumber;
  String? location;
  Image_cart? pic;
  String? type;
  int? v;

  UserId({
    this.id,
    this.username,
    this.mail,
    this.phonenumber,
    this.location,
    this.pic,
    this.type,
    this.v,
  });

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json["_id"],
        username: json["username"],
        mail: json["mail"],
        phonenumber: json["phonenumber"],
        location: json["location"],
        pic: json["pic"] == null ? null : Image_cart.fromJson(json["pic"]),
        type: json["type"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "mail": mail,
        "phonenumber": phonenumber,
        "location": location,
        "pic": pic?.toJson(),
        "type": type,
        "__v": v,
      };
}
