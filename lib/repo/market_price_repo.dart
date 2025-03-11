import 'package:farmers_touch/constants.dart';
import 'package:farmers_touch/views/main/bargraph/barchat_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MarketPriceRepo {
  Future<List<MarketPriceModel>?> getMarketPrices() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/marketprices'));
      if (response.statusCode == 200) {
        final data = marketPriceModelFromJson(response.body);
        return data;
      } else {
        debugPrint("Error while fetching market prices: ${response.body}");
        return null;
      }
    } catch (err) {
      debugPrint("error in catch while fetching market prices: $err");
      return null;
    }
  }
}
