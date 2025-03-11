// To parse this JSON data, do
//
//     final marketPriceModel = marketPriceModelFromJson(jsonString);

import 'dart:convert';

import 'package:farmers_touch/views/main/bargraph/individual_bar.dart';

List<MarketPriceModel> marketPriceModelFromJson(String str) =>
    List<MarketPriceModel>.from(
        json.decode(str).map((x) => MarketPriceModel.fromJson(x)));

String marketPriceModelToJson(List<MarketPriceModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MarketPriceModel {
  String? id;
  String? item;
  int? price;
  String? category;
  int? v;

  MarketPriceModel({
    this.id,
    this.item,
    this.price,
    this.category,
    this.v,
  });

  factory MarketPriceModel.fromJson(Map<String, dynamic> json) =>
      MarketPriceModel(
        id: json["_id"],
        item: json["item"],
        price: json["price"],
        category: json["category"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "item": item,
        "price": price,
        "category": category,
        "__v": v,
      };
}
