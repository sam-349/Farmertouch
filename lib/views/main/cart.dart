import 'dart:typed_data';

import 'package:farmers_touch/colors.dart';
import 'package:farmers_touch/models/cart_model.dart';
import 'package:farmers_touch/provider/cart_provider.dart';
import 'package:farmers_touch/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
    setState(() {
      isLoading = true;
    });
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.userID != null) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      if (cartProvider != null) {
        cartProvider.setUserId(userProvider.userID!);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shopping Cart')),
      body: (isLoading)
          ? Center(
              child: CircularProgressIndicator(
                color: ColorsUtil.primaryColor,
              ),
            )
          : Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                if (cartProvider.userId == null) {
                  return Center(
                    child: Text('Please Login to view cart.',
                        style: TextStyle(fontSize: 18)),
                  );
                }

                if (cartProvider.items.isEmpty) {
                  return Center(
                    child: Text('Your cart is empty.',
                        style: TextStyle(fontSize: 18)),
                  );
                }

                return ListView.builder(
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    return CartItemCard(
                      cartItem: cartProvider.items[index],
                      onRemove: () {
                        cartProvider.removeItem(
                            cartProvider.items[index], context);
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onRemove;

  CartItemCard({
    required this.cartItem,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(cartItem.productid?.image),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cartItem.productid?.productName ?? 'Product Name',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'by ${cartItem.productid?.userId?.username}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.currency_rupee,
                              size: 14, color: Colors.black87),
                          Text(
                            '${cartItem.productid?.price ?? 0}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildQuantityControl(cartItem, context),
                          Row(
                            children: [
                              TextButton(
                                onPressed: onRemove,
                                child: Text('Remove',
                                    style: TextStyle(
                                        color: Colors.grey[700], fontSize: 14)),
                              ),
                              SizedBox(width: 8),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(height: 24, thickness: 1, color: Colors.grey[300]),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(Image_cart? imagePro) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: imagePro?.data != null && imagePro!.data!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.memory(
                Uint8List.fromList(imagePro.data!),
                fit: BoxFit.cover,
              ),
            )
          : _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return Icon(Icons.image, size: 50, color: Colors.grey.shade400);
  }

  Widget _buildQuantityControl(CartItem cartItem, BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove, size: 18, color: Colors.grey[700]),
                onPressed: cartItem.qty! > 1
                    ? () {
                        Provider.of<CartProvider>(context, listen: false)
                            .decrementItemQuantity(cartItem, context);
                      }
                    : null, // Set onPressed to null to disable the button
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('${cartItem.qty}', style: TextStyle(fontSize: 16)),
              ),
              IconButton(
                icon: Icon(Icons.add, size: 18, color: Colors.grey[700]),
                onPressed: () async {
                  Provider.of<CartProvider>(context, listen: false)
                      .incrementItemQuantity(cartItem, context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
