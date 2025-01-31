import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutPage extends StatefulWidget {
  final List<dynamic> cartItems;

  CheckoutPage({required this.cartItems});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String address = '';
  String city = '';
  String postalCode = '';
  String paymentMethod = 'Cash';
  String authToken = '';

  @override
  void initState() {
    super.initState();
    _getAuthToken();
  }

  Future<void> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      authToken = prefs.getString('auth_token') ?? '';
    });
  }

  Future<void> checkout() async {
    const String url = 'http://134.209.152.31/api/checkout';

    final body = {
      'name': name,
      'email': email,
      'address': address,
      'city': city,
      'postal_code': postalCode,
      'payment_method': paymentMethod,
      'items': widget.cartItems.map((item) {
        return {
          'product_id': item['product']['id'],
          'product_name': item['product']['product_name'],
          'quantity': item['quantity'],
          'price': item['product']['price'],
        };
      }).toList(),
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Checkout successful!')),
          );

          final order = responseData['order'];
          print('Order placed successfully: ${jsonEncode(order)}');
        } else {
          final errorMessage = responseData['message'] ?? 'Failed to checkout';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred during checkout')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during checkout')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Display cart items
              Text(
                'Your Cart Items',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = widget.cartItems[index];
                  final product = cartItem['product'] ?? {};
                  final productName = product['product_name'] ?? 'Unknown Product';

                  final productPrice = (product['price'] is int)
                      ? product['price'].toString()
                      : product['price'] ?? '0.00';
                  final quantity = (cartItem['quantity'] is int)
                      ? cartItem['quantity'].toString()
                      : cartItem['quantity'] ?? '1';

                  final double price = double.parse(productPrice);
                  final int qty = int.parse(quantity);

                  final double total = price * qty;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    color: isDarkMode ? Colors.grey[850] : Colors.white,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      title: Text(
                        productName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        'Price: \$${price.toStringAsFixed(2)} x $qty',
                        style: TextStyle(color: isDarkMode ? Colors.grey[300] : Colors.black54),
                      ),
                      trailing: Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Checkout form
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[900] : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode ? Colors.black54 : Colors.grey[300]!,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.person),
                          filled: true,
                          fillColor: isDarkMode ? Colors.grey[850] : Colors.white,
                        ),
                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                        onSaved: (value) => name = value ?? '',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.email),
                          filled: true,
                          fillColor: isDarkMode ? Colors.grey[850] : Colors.white,
                        ),
                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                        onSaved: (value) => email = value ?? '',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Address',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.home),
                          filled: true,
                          fillColor: isDarkMode ? Colors.grey[850] : Colors.white,
                        ),
                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                        onSaved: (value) => address = value ?? '',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'City',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.location_city),
                          filled: true,
                          fillColor: isDarkMode ? Colors.grey[850] : Colors.white,
                        ),
                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                        onSaved: (value) => city = value ?? '',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your city';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Postal Code',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.pin_drop),
                          filled: true,
                          fillColor: isDarkMode ? Colors.grey[850] : Colors.white,
                        ),
                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                        onSaved: (value) => postalCode = value ?? '',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your postal code.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: paymentMethod,
                        items: ['Cash', 'Credit Card', 'Debit Card']
                            .map((paymentMethod) => DropdownMenuItem(
                          value: paymentMethod,
                          child: Text(
                            paymentMethod,
                            style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black),
                          ),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            paymentMethod = value!;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Payment Method',
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: isDarkMode ? Colors.grey[850] : Colors.white,
                        ),
                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _formKey.currentState?.save();
                            checkout();
                          }
                        },
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text('Place Order'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
                          foregroundColor: isDarkMode ? Colors.white : Colors.black,
                          minimumSize: const Size(double.infinity, 50),
                          side: const BorderSide(color: Color(0xFF978D4F)),
                          textStyle: const TextStyle(fontSize: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

