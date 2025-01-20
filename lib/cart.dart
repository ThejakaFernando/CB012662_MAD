import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'checkout.dart';

class CartPage extends StatefulWidget {
  static const String id = 'cart_page';

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<dynamic> cartItems = [];
  bool isLoading = true;
  String baseUrl = "http://134.209.152.31/";

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');

    if (authToken == null || authToken.isEmpty) {
      showError("You must be logged in to view your cart...");
      return;
    }

    const String url = 'http://134.209.152.31/api/cart';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          cartItems = data['cart'] ?? [];
          isLoading = false;
        });
      } else {
        final errorData = jsonDecode(response.body);
        showError(errorData['message'] ?? "Failed to load cart.");
      }
    } catch (e) {
      showError("An error occurred: $e");
    }
  }

  Future<void> removeFromCart(String productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');

    if (authToken == null || authToken.isEmpty) {
      showError("Please log in to remove items from your cart.");
      return;
    }

    const String url = 'http://134.209.152.31/api/cart/remove';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'product_id': productId,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          cartItems.removeWhere((item) => item['product']['id'] == productId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Item has been removed from the cart")),
        );
      } else {
        final errorData = jsonDecode(response.body);
        showError(errorData['message'] ?? "Failed to remove item.");
      }
    } catch (e) {
      showError("An error occurred: $e");
    }
  }

  Future<void> updateCartQuantity(String productId, int quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');

    if (authToken == null || authToken.isEmpty) {
      showError("Please log in to update your cart.");
      return;
    }

    const String url = 'http://134.209.152.31/api/cart/update';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'product_id': productId.toString(),
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          final index =
          cartItems.indexWhere((item) => item['product']['id'] == productId);
          if (index != -1) {
            cartItems[index]['quantity'] = quantity;
          }
        });
      } else {
        final errorData = jsonDecode(response.body);
        showError(errorData['message'] ?? "Failed to update quantity.");
      }
    } catch (e) {
      showError("An error occurred: $e");
    }
  }

  void showError(String message) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void navigateToCheckout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(cartItems: cartItems),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFAEA466),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty."))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartItems[index];
                final product = cartItem['product'] ?? {};

                final productId = product['id'].toString();
                final productName =
                    product['product_name'] ?? 'Unknown Product';
                final productImage = product['image'] ?? '';
                final productPrice = product['price'] ?? '0.00';
                final quantity = cartItem['quantity'] ?? 1;

                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            '$baseUrl$productImage',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) {
                              return Image.asset(
                                'images/ethiquedeodrant1.png',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                productName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Price: \$${productPrice}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (quantity > 1) {
                                        updateCartQuantity(
                                            productId,
                                            quantity - 1);
                                      }
                                    },
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Text(
                                    '$quantity',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      updateCartQuantity(
                                          productId, quantity + 1);
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            removeFromCart(productId);
                          },
                          icon: const Icon(Icons.delete,
                              color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: navigateToCheckout,
              child: const Text('Proceed to Checkout'),
            ),
          ),
        ],
      ),
    );
  }
}
