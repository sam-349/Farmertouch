import 'dart:convert';

import 'package:farmers_touch/constants.dart';
import 'package:farmers_touch/models/blog_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BlogRepo {
  Future<List<BlogModel>?> getBlogs() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/blogs/all'));
      if (response.statusCode == 200) {
        final content = blogModelFromJson(response.body);
        return content;
      } else {
        debugPrint("Error in fetching blogs: ${response.body}");
        return null;
      }
    } catch (err) {
      debugPrint("Error in fetching blogs: ${err}");
      return null;
    }
  }

  Future<List<BlogModel>?> searchBlogs(String key) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/blogs/$key"));
      if (response.statusCode == 200) {
        final content = blogModelFromJson(response.body);
        return content;
      } else {
        debugPrint("Error in fetching blogs in else: ${response.statusCode}");
        return null;
      }
    } catch (err) {
      debugPrint("Error in fetching blogs in catch: ${err.toString()}");
      return null;
    }
  }

  Future<void> uploadBlog(String title, String content, String category,
      String userID, selectedImages) async {
    var url = Uri.parse("$baseUrl/blogs"); // Replace with actual API URL
    var request = http.MultipartRequest("POST", url);

    // Attach form fields
    request.fields["title"] = title;
    request.fields["content"] = content;
    request.fields["category"] = category;
    request.fields["userId"] = userID;

    // Attach images as multipart files
    for (var image in selectedImages) {
      var file = await http.MultipartFile.fromPath(
        "images", // Field name in Node.js
        image.path,
      );
      request.files.add(file);
    }

    try {
      debugPrint("request placed");
      var response = await request.send();
      if (response.statusCode == 201) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        debugPrint("Blog uploaded successfully: $jsonResponse");
      } else {
        debugPrint(
            "Failed to upload blog. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error uploading blog: $e");
    }
  }

  Future<List<BlogModel>?> getBlogsByCategory(String category) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/blogs?category=$category'));
      if (response.statusCode == 200) {
        final content = blogModelFromJson(response.body);
        debugPrint(content.toString());
        return content;
      } else {
        debugPrint("Error in fetching blogs: ${response.body}");
        return null;
      }
    } catch (err) {
      debugPrint("Error in fetching blogs in catch: ${err}");
      return null;
    }
  }

  Future<List<BlogModel>?> getBlogsByUserId(String userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/blogs/user/$userId'));
      if (response.statusCode == 200) {
        // debugPrint("blogs: " + response.body);
        final data = blogModelFromJson(response.body);
        debugPrint("success");
        return data;
      } else {
        debugPrint("Error fetching user blog details: ${response.body}");
        return null;
      }
    } catch (err) {
      debugPrint("Error fetching user blog details in catch: $err");
      return null;
    }
  }

  Future<bool> deleteBlog(String blogId) async {
    final url = Uri.parse(
        '$baseUrl/blogs/$blogId'); // Replace with your actual API base URL

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        // Successful deletion
        return true; // Return the parsed JSON response
      } else if (response.statusCode == 404) {
        // Blog not found
        return false;
      } else {
        // Other errors
        debugPrint('Failed to delete blog. Status code: ${response.body}');
        return false;
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Error deleting blog: $e');
      return false; // Return error message in a map
      // or you can throw the exception to handle it in the UI.
    }
  }
}
