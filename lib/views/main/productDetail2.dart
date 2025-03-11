import 'dart:typed_data';

import 'package:farmers_touch/models/product_model.dart';
import 'package:farmers_touch/provider/user_provider.dart';
import 'package:farmers_touch/repo/cart_repo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel productData;

  ProductDetailPage({required this.productData});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Section
            _buildImageSection(widget.productData.image),
            SizedBox(height: 20),

            // Product Details Section
            _buildDetailsSection(widget.productData),
            SizedBox(height: 20),

            // Quantity Selection
            _buildQuantitySection(),
            SizedBox(height: 20),

            // Order and Cart Buttons
            _buildOrderCartButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(Image_pro? imagePro) {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: imagePro?.data != null && imagePro!.data!.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.memory(
                  Uint8List.fromList(
                      imagePro.data!), // Convert byte list to Uint8List
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildPlaceholderImage(),
                ),
              )
            : _buildPlaceholderImage(),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Icon(Icons.grass, size: 100, color: Colors.grey.shade400);
  }

  Widget _buildDetailsSection(ProductModel productData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          productData.productName ?? 'Product Name',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          productData.productType ?? 'Product Type',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Icon(Icons.currency_rupee, size: 20, color: Colors.green),
            Text(
              '${productData.price ?? 0}',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          'Stock Left: ${productData.quantity ?? 0}',
          style: TextStyle(fontSize: 16, color: Colors.blueGrey),
        ),
      ],
    );
  }

  Widget _buildQuantitySection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Quantity:', style: TextStyle(fontSize: 18)),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                if (_quantity > 1) {
                  setState(() {
                    _quantity--;
                  });
                }
              },
            ),
            Text('$_quantity', style: TextStyle(fontSize: 18)),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  _quantity++;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderCartButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () async {
            // TODO: Implement Add to Cart functionality
            await CartRepo().addItemToCart(
              productId: widget.productData.id!,
              userId: Provider.of<UserProvider>(context, listen: false).userID!,
              qty: _quantity,
              context: context,
            );
            print(
                'Added ${_quantity} ${widget.productData.productName} to cart');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Added to Cart!')),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text('Add to Cart', style: TextStyle(fontSize: 16)),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // TODO: Implement Order Now functionality
            print('Ordered ${_quantity} ${widget.productData.productName} now');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Order Placed!')),
            );
          },
          style: ElevatedButton.styleFrom(
              // foregroundColor: Colors.orange,
              ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text('Order Now', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }
}
