import 'dart:io';

import 'package:farmers_touch/constants.dart';
import 'package:farmers_touch/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductRepo {
  Future<List<ProductModel>?> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));
      if (response.statusCode == 200) {
        final data = productModelFromJson(response.body);
        return data;
      } else {
        debugPrint("Error while retreiving products: ${response.body}");
        return null;
      }
    } catch (err) {
      debugPrint("Error retreiving products in catch: $err");
      return null;
    }
  }

  Future<http.Response> createProduct(
    String userId,
    String productName,
    String productType,
    double price,
    int quantity,
    File? imageFile,
  ) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/products'));

      // Add text fields
      request.fields['userId'] = userId;
      request.fields['productName'] = productName;
      request.fields['productType'] = productType;
      request.fields['price'] = price.toString();
      request.fields['quantity'] = quantity.toString();

      // Add image file if provided
      if (imageFile != null) {
        // final mimeTypeData = lookupMimeType(imageFile.path, headerBytes: [0xFF, 0xD8])!.split('/');
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            imageFile.path,
            // contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
          ),
        );
      }

      // Send the request
      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      // Check for success
      if (responseBody.statusCode == 201) {
        return responseBody;
      } else {
        throw Exception('Failed to create product: ${responseBody.body}');
      }
    } catch (e) {
      print('Error creating product: $e');
      throw Exception('Failed to create product: $e');
    }
  }

  Future<List<ProductModel>?> getUserProducts(String userId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/products/user/$userId'));
      if (response.statusCode == 200) {
        // debugPrint("products: " + response.body);
        final data = productModelFromJson(response.body);
        debugPrint("success  in products");
        return data;
      } else {
        debugPrint("Error while get user products: ${response.body}");
        return null;
      }
    } catch (err) {
      debugPrint("Error while get user products in catch: $err");
      return null;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    final url = Uri.parse(
        '$baseUrl/products/$productId'); // Replace with your actual API base URL

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        // Successful deletion
        return true; // Return the parsed JSON response
      } else if (response.statusCode == 400) {
        // Bad request (productId missing)
        return false;
      } else if (response.statusCode == 404) {
        // Product not found
        return false;
      } else {
        // Other errors
        throw Exception(
            'Failed to delete product. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Error deleting product: $e');
      return false; // Return error message in a map
      // or you can throw the exception to handle it in the UI.
    }
  }
}
