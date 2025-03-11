import 'dart:convert';

import 'package:farmers_touch/constants.dart';
import 'package:farmers_touch/models/login_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthRepo {
  Future<LoginModel?> login(String email, String password) async {
    try {
      final body = jsonEncode({
        "mail": email,
        "password": password,
      });
      debugPrint("login body: $body");

      final response = await http.post(Uri.parse("$baseUrl/login"),
          headers: {'Content-Type': 'application/json'}, body: body);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        LoginModel content = LoginModel.fromJson(data);
        debugPrint("username: ${content.user!.username}");
        debugPrint("password: ${content.user!.password}");
        return content;
      } else {
        debugPrint("error:" + response.body);
        return null;
      }
    } catch (e) {
      debugPrint("Error while logging in: " + e.toString());
      return null;
    }
  }

  Future<LoginModel?> signup(String userName, String email, String password,
      String phoneNumber, String category) async {
    try {
      var body = jsonEncode({
        'username': userName,
        'mail': email,
        'password': password,
        'phonenumber': phoneNumber,
        'type': category,
        'location': '',
      });

      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 201) {
        // var data = json.decode(response.body);
        LoginModel content = loginModelFromJson(response.body);
        return content;
      } else {
        debugPrint("error while signup: ${response.body}");
      }
    } catch (err) {
      debugPrint("error while signup: ${err.toString()}");
      return null;
    }
  }
}
