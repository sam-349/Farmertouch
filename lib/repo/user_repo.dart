import 'dart:convert';
import 'dart:io';
import 'package:farmers_touch/constants.dart';
import 'package:farmers_touch/models/login_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserRepo {
  Future<User?> updateUser(
    String userId,
    String? username,
    String mail,
    String password,
    String? phoneNumber,
    String? location,
    String type,
    File? imageFile, // Allow null for no image update
  ) async {
    try {
      var request =
          http.MultipartRequest('PUT', Uri.parse('$baseUrl/users/$userId'));

      // Add text fields
      request.fields['username'] = username ?? "";
      request.fields['mail'] = mail;
      request.fields['password'] = password;
      request.fields['phonenumber'] = phoneNumber ?? "";
      request.fields['location'] = location ?? "";
      request.fields['type'] = type;

      // Add image file if provided
      if (imageFile != null) {
        var file = await http.MultipartFile.fromPath(
          "pic", // Field name in Node.js
          imageFile.path,
        );
        request.files.add(file);
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        var decode = json.decode(responseData);
        debugPrint("decoded data: $decode");
        final data = User.fromJson(decode);
        // return json.decode(responseData);
        debugPrint("Blog uploaded successfully: ${data.password}");
        return data;
      } else {
        debugPrint("Failed to upload user data. Status Code: ${responseData}");
        return null;
      }
    } catch (e) {
      debugPrint("error sending update request in catch: $e");
      return null;
      // throw Exception('Error: $e');
    }
  }
}
