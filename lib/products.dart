import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductsPage extends StatefulWidget {
  static const String id = 'products_page';

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<dynamic> products = [];
  bool isLoading = true;
  String baseUrl = "http://134.209.152.31/";

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    const String url = 'http://134.209.152.31/api/allproducts';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          products = data['products'] ?? [];
          isLoading = false;
        });
      } else {
        showError('Failed to load products. Status code: ${response.statusCode}');
      }
    } catch (e) {
      showError('An error occurred while fetching products: $e');
    }
  }

  Future<void> addToCart(String productId, int quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');

    if (authToken == null || authToken.isEmpty) {
      showError("Please log in to add products to your cart.");
      return;
    }

    const String url = 'http://134.209.152.31/api/cart/add';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({'product_id': productId, 'quantity': quantity}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Product added to cart!")),
          );
        } else {
          showError(data['message'] ?? "Failed to add product to cart.");
        }
      } else {
        final errorData = jsonDecode(response.body);
        showError(errorData['message'] ?? "An error occurred.");
      }
    } catch (e) {
      showError("An error occurred: $e");
    }
  }

  Future<void> addToWishlist(String productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');

    if (authToken == null || authToken.isEmpty) {
      showError("Please log in to add products to your wishlist.");
      return;
    }

    if (productId.isEmpty) {
      showError("Invalid product. Please try again.");
      return;
    }

    const String url = 'http://134.209.152.31/api/wishlist/add';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({'product_id': productId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Product added to wishlist!")),
          );
        } else {
          showError(data['message'] ?? "Failed to add product to wishlist.");
        }
      } else {
        final errorData = jsonDecode(response.body);
        showError(errorData['message'] ?? "An error occurred.");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final productName = product['product_name'] ?? 'Unknown Product';
          final productImage = product['image'] ?? '';
          final productId = product['id']?.toString() ?? '';
          final imageUrl = productImage.isNotEmpty
              ? '$baseUrl/storage/products/$productImage'
              : 'images/ethiqueshampoo4.png';

          return Card(
            key: Key(productId),
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'images/ethiqueshampoo4.png',
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    productName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product['product_description'] ?? 'No description available.',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Price: \$${product['price'] ?? 0}',
                    style: const TextStyle(fontSize: 16, color: Colors.green),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          addToCart(productId, 1);
                        },
                        child: const Text('Add to Cart'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          addToWishlist(productId);
                        },
                        child: const Text('Add to Wishlist'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
