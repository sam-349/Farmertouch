import 'dart:typed_data';
import 'package:farmers_touch/models/farmer_user_model.dart';
import 'package:flutter/material.dart';

// Assuming you have the Farmer and Pic models defined as in the previous response.

class FarmerDetailsPage extends StatelessWidget {
  final Farmer farmer;

  FarmerDetailsPage({required this.farmer});

  Widget _buildFarmerImage(Pic? pic) {
    if (pic != null && pic.data != null && pic.data!.isNotEmpty) {
      try {
        return Image.memory(Uint8List.fromList(pic.data!), width: 200, height: 200);
      } catch (e) {
        return const Icon(Icons.person, size: 200);
      }
    } else {
      return const Icon(Icons.person, size: 200);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(farmer.username ?? 'Farmer Details')),
      body: SingleChildScrollView( // Add SingleChildScrollView for scrollable content
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: _buildFarmerImage(farmer.pic)),
            const SizedBox(height: 20),
            Text('Username: ${farmer.username ?? 'N/A'}', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Email: ${farmer.mail ?? 'N/A'}', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Phone: ${farmer.phonenumber ?? 'N/A'}', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Location: ${farmer.location ?? 'N/A'}', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Type: ${farmer.type ?? 'N/A'}', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            if (farmer.id != null) Text('ID: ${farmer.id}', style: TextStyle(fontSize: 18)), //show id if it exists.
          ],
        ),
      ),
    );
  }
}