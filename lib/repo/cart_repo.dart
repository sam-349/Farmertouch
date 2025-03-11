import 'dart:convert';

import 'package:farmers_touch/constants.dart';
import 'package:farmers_touch/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CartRepo {
  Future<List<CartItem>?> getCartItems(String user_id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/cart/$user_id'));
      if (response.statusCode == 200) {
        final data = cartFromJson(response.body);
        return data.cartItems;
      } else {
        debugPrint("Error while retreiving cart items ${response.body}");
        return null;
      }
    } catch (err) {
      debugPrint("Error while retreiving cart items in catch: $err");
      return null;
    }
  }

  Future<void> addItemToCart({
    required String productId,
    required String userId,
    required int qty,
    required BuildContext context, // Add BuildContext to show SnackBar
  }) async {
    const apiUrl = '$baseUrl/cart'; // Replace with your actual API endpoint

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json'
        }, // Set content type to JSON
        body: jsonEncode({
          // Encode request body to JSON
          "productId": productId,
          "user_id": userId,
          "qty": qty,
        }),
      );

      if (response.statusCode == 201) {
        // Assuming 201 Created status code for successful addition
        // Item added successfully
        debugPrint('Item added to cart successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item added to cart!')),
        );
        // Optionally, you might want to refresh the cart data after adding an item
        // Example: _fetchCartItems(); // If you have a method to refresh cart items
      } else {
        // Handle error response
        debugPrint(
            'Failed to add item to cart. Status code: ${response.statusCode}');
        debugPrint(
            'Response body: ${response.body}'); // Log response body for debugging
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to add item to cart. Please try again.')),
        );
      }
    } catch (error) {
      // Handle network errors or exceptions
      debugPrint('Error adding item to cart: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Error connecting to server. Please check your internet connection.')),
      );
    }
  }

  // Function to call the combined endpoint to update cart item quantity (increment or decrement)
  Future<void> updateQuantityInCart({
    required String cartItemId,
    required String action, // 'increment' or 'decrement'
    required BuildContext context, // To show SnackBar messages
  }) async {
    final apiUrl =
        '$baseUrl/cart/$cartItemId?action=$action'; // Combined endpoint URL

    try {
      final response = await http
          .put(Uri.parse(apiUrl)); // Make PUT request to the combined endpoint

      if (response.statusCode == 200) {
        // Quantity updated successfully
        debugPrint(
            'Cart item quantity $action successful'); // Log the action (increment/decrement)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Quantity updated!')),
        );
        // Optionally, you might want to refresh the cart data after a successful update
        // _fetchCartItems(); // Call this method if you have one to refresh the cart in your CartPage
      } else {
        // Handle error response
        debugPrint(
            'Failed to $action quantity. Status code: ${response.statusCode}');
        debugPrint(
            'Response body: ${response.body}'); // Log response body for debugging
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to update quantity. Please try again.')),
        );
      }
    } catch (error) {
      // Handle network errors or exceptions
      debugPrint('Error $action quantity: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Error connecting to server. Please check your internet connection.')),
      );
    }
  }

  Future<void> removeItemFromCart({
    required String cartItemId,
    required BuildContext context,
  }) async {
    final apiUrl =
        '$baseUrl/cart/$cartItemId'; // API endpoint to delete an item

    try {
      final response = await http.delete(Uri.parse(apiUrl)); // DELETE request

      if (response.statusCode == 200) {
        // Item removed successfully
        debugPrint('Item removed from cart successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item removed from cart!')),
        );
      } else {
        // Handle error response
        debugPrint(
            'Failed to remove item from cart. Status code: ${response.statusCode}');
        debugPrint(
            'Response body: ${response.body}'); // Log response body for debugging
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to remove item from cart. Please try again.')),
        );
      }
    } catch (error) {
      // Handle network errors or exceptions
      debugPrint('Error removing item from cart: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Error connecting to server. Please check your internet connection.')),
      );
    }
  }
}
