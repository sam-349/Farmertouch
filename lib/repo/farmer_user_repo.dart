import 'package:farmers_touch/constants.dart';
import 'package:farmers_touch/models/farmer_user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FarmerUserRepo {
  Future<List<Farmer>?> getFarmers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/farmers'));
      if (response.statusCode == 200) {
        final data = farmerFromJson(response.body);
        return data;
      } else {
        debugPrint("Error retreiving farmers: ${response.body}");
        return null;
      }
    } catch (err) {
      debugPrint("Error retreiving farmers : $err");
      return null;
    }
  }
}
