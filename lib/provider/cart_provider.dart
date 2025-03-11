import 'package:flutter/material.dart';
import 'package:farmers_touch/models/cart_model.dart'; // Import your cart model
import 'package:farmers_touch/repo/cart_repo.dart'; // Import your CartRepo

class CartProvider extends ChangeNotifier {
  final CartRepo _cartRepo = CartRepo(); // Instantiate your CartRepo
  List<CartItem> _items = [];
  String? _userId; // Add user ID to fetch cart data
  String get userId => _userId!;

  List<CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0;
    for (var item in _items) {
      if (item.productid != null && item.qty != null) {
        total += item.productid!.price! * item.qty!;
      }
    }
    return total;
  }

  // Set user ID to fetch cart data
  void setUserId(String userId) {
    _userId = userId;
    fetchCartItems(); // Fetch cart items when user ID is set
  }

  // Fetch cart items from the API
  Future<void> fetchCartItems() async {
    if (_userId == null) return; // Don't fetch if no user ID
    final cartItems = await _cartRepo.getCartItems(_userId!);
    if (cartItems != null) {
      _items = cartItems;
      notifyListeners();
    }
  }

  // Add item to cart using API
  Future<void> addItem(
      String productID, int quantity, BuildContext context) async {
    if (_userId == null) return;
    await _cartRepo.addItemToCart(
      productId: productID,
      userId: _userId!,
      qty: quantity,
      context: context,
    );
    await fetchCartItems(); // Refresh cart after adding
  }

  // Increment item quantity using API
  Future<void> incrementItemQuantity(
      CartItem item, BuildContext context) async {
    await _cartRepo.updateQuantityInCart(
      cartItemId: item.id!, // Assuming CartItem has an 'id' field
      action: 'increment',
      context: context,
    );
    await fetchCartItems(); // Refresh cart after update
  }

  // Decrement item quantity using API
  Future<void> decrementItemQuantity(
      CartItem item, BuildContext context) async {
    await _cartRepo.updateQuantityInCart(
      cartItemId: item.id!, // Assuming CartItem has an 'id' field
      action: 'decrement',
      context: context,
    );
    await fetchCartItems(); // Refresh cart after update
  }

  //remove item from cart using api
  Future<void> removeItem(CartItem item, BuildContext context) async {
    await _cartRepo.removeItemFromCart(cartItemId: item.id!, context: context);
    await fetchCartItems();
  }

  // Clear cart (if applicable, add API call if you have one)
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
