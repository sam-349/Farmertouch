import 'dart:convert';
import 'package:farmers_touch/models/crop_analysis_result_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PlantDiseasePredictRepo {
  Future<AnalysisResultModel?> sendHealthAssessmentRequest(
      String base64Image) async {
    final apiKey =
        'dl8csFWdDoXtCDsKxOn1ocFKgiRMrY0D2qa7cUvH5WIbRmo4gY'; // Replace with your API key
    final url = Uri.parse('https://plant.id/api/v3/health_assessment');
    debugPrint("analyze in repo");

    try {
      final response = await http.post(
        url,
        headers: {
          'Api-Key': apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'images': ['data:image/jpg;base64,$base64Image'],
          'latitude': 0.0, // Optional
          'longitude': 0.0, // Optional
          'similar_images': true,
        }),
      );

      if (response.statusCode == 201) {
        final decodedResponse = jsonDecode(response.body);
        print('API Response Body: $decodedResponse'); // Print the response body
        final data = analysisResultModelFromJson(response.body);
        return data;
      } else {
        print('API request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error sending API request: $e');
      return null;
    }
  }
}
