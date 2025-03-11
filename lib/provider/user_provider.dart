import 'package:farmers_touch/models/address_model.dart';
import 'package:farmers_touch/models/login_model.dart';
import 'package:farmers_touch/models/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProvider extends ChangeNotifier {
  User? _user;
  Address? _address; // Store address in provider
  Weather? _weather; // Store weather in provider

  String? get userID => _user?.id;
  User? get user => _user;
  Address? get address => _address; // Getter for address
  Weather? get weather => _weather; // Getter for weather
  bool get hasLocationData =>
      _address != null && _weather != null; // Check if location data exists

  Future<void> setUser(User user) async {
    _user = user;
    notifyListeners();
    debugPrint("user data received: ${user.mail}");
    await _saveUserToPrefs(user);
  }

  Future<void> setLocation(Address? address, Weather? weather) async {
    _address = address;
    _weather = weather;
    notifyListeners();
    debugPrint("location data set in provider");
    await _saveLocationToPrefs(address, weather); // Save location to prefs
  }

  Future<void> loadDataFromPrefs() async {
    await loadUserFromPrefs();
    await loadLocationFromPrefs(); // Load location on startup
  }

  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      final decodedUser = json.decode(userJson);
      _user = User.fromJson(decodedUser);
      notifyListeners();
    }
  }

  Future<void> loadLocationFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final addressJson = prefs.getString('address');
    final weatherJson = prefs.getString('weather');

    if (addressJson != null && weatherJson != null) {
      final decodedAddress = json.decode(addressJson);
      final decodedWeather = json.decode(weatherJson);
      _address = Address.fromJson(decodedAddress);
      _weather = Weather.fromJson(decodedWeather);
      notifyListeners();
      debugPrint("Location data loaded from preferences");
    } else {
      debugPrint("No location data in preferences");
    }
  }

  Future<void> _saveUserToPrefs(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = json.encode(user.toJson());
    await prefs.setString('user', userJson);
    debugPrint("user data saved in preferences");
  }

  Future<void> _saveLocationToPrefs(Address? address, Weather? weather) async {
    final prefs = await SharedPreferences.getInstance();
    if (address != null && weather != null) {
      final addressJson = json.encode(address.toJson());
      final weatherJson = json.encode(weather.toJson());
      await prefs.setString('address', addressJson);
      await prefs.setString('weather', weatherJson);
      debugPrint("Location data saved in preferences");
    } else {
      await prefs.remove('address');
      await prefs.remove('weather');
      debugPrint("Location data removed from preferences due to null values");
    }
  }

  Future<void> clearUser() async {
    _user = null;
    _address = null; // Clear address on user clear
    _weather = null; // Clear weather on user clear
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove('address'); // Clear address from prefs
    await prefs.remove('weather'); // Clear weather from prefs
  }
}
