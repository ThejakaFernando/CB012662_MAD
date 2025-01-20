import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<dynamic> _wishlistItems = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('auth_token');

    if (authToken == null) {
      setState(() {
        _errorMessage = "Please login to view your wishlist...";
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("http://134.209.152.31/api/wishlist"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _wishlistItems =
          data['wishlist'] != null ? List.from(data['wishlist']) : [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Failed to load wishlist.";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred: $e";
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteItem(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('auth_token');

    if (authToken == null) {
      setState(() {
        _errorMessage = "User is not logged in.";
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("http://134.209.152.31/api/wishlist/delete/$id"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _wishlistItems.removeWhere((item) => item['id'] == id);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "Item deleted successfully!",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        setState(() {
          _errorMessage = "Failed to delete item. Server response: ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred while deleting: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Wishlist',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFAEA466),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : _wishlistItems.isEmpty
          ? const Center(child: Text("No products in the wishlist..."))
          : ListView.builder(
        itemCount: _wishlistItems.length,
        itemBuilder: (context, index) {
          final item = _wishlistItems[index];
          final product = item['product'];
          final productName =
              product?['product_name'] ?? 'Unknown Product';
          final price = product?['price'] ?? 'N/A';
          final imageUrl =
              product?['image'] ?? 'images/ethiquedeodrant1.png';
          final itemId = item['id'];

          return Card(
            margin: const EdgeInsets.symmetric(
                vertical: 8, horizontal: 16),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      imageUrl,
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
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(productName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                        Text("\$$price",
                            style: const TextStyle(
                                color: Colors.green)),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon:
                        const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          if (itemId != null) {
                            _deleteItem(itemId);
                          }
                        },
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
