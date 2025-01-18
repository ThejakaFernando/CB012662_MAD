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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.white,
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
                  color: Colors.black,
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
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      title: Text(productName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      subtitle: Text('Price: \$${price.toStringAsFixed(2)} x $qty'),
                      trailing: Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.white, blurRadius: 8)],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
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
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
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
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.home),
                        ),
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
                        decoration: const InputDecoration(
                          labelText: 'City',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_city),
                        ),
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
                        decoration: const InputDecoration(
                          labelText: 'Postal Code',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.pin_drop),
                        ),
                        onSaved: (value) => postalCode = value ?? '',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your postal code';
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
                          child: Text(paymentMethod),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            paymentMethod = value!;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Payment Method',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _formKey.currentState?.save();
                            checkout();
                          }
                        },
                        icon: Icon(
                          Icons.shopping_cart,
                          color: Colors.black,
                        ),
                        label: Text(
                          'Place Order',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          minimumSize: Size(double.infinity, 50),
                          backgroundColor: Colors.white,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Color(0xFF978D4F)),
                          ),
                          textStyle: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                          ),
                        ),
                      )

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
