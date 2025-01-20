import 'package:flutter/material.dart';
//when the 'eye' button is cllicked in the products.dart file, it will be redirect to this page for EACH product
class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1;

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productName = widget.product['product_name'] ?? 'Unknown Product';
    final productDescription =
        widget.product['product_description'] ?? 'No description available.';
    final productPrice = double.tryParse(widget.product['price'] ?? '0') ?? 0;
    final productImage = widget.product['image'] ?? '';
    final imageUrl = productImage.isNotEmpty
        ? 'http://134.209.152.31/storage/products/$productImage'
        : 'images/ethiqueshampoo4.png';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          productName,
          style: const TextStyle(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'images/ethiqueshampoo4.png',
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Product Name
            Text(
              productName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Product Description
            Text(
              productDescription,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // Product Price
            Text(
              'Price: \$${productPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),

            // Quantity Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: decrementQuantity,
                  icon: const Icon(Icons.remove),
                  color: Colors.red,
                ),
                Text(
                  '$quantity',
                  style: const TextStyle(fontSize: 18),
                ),
                IconButton(
                  onPressed: incrementQuantity,
                  icon: const Icon(Icons.add),
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Buttons in the same line
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Add to cart logic
                    },
                    icon: const Icon(Icons.shopping_basket_rounded, color: Colors.green),
                    label: const Text(
                      "Add to Cart",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Add to wishlist logic
                    },
                    icon: const Icon(Icons.favorite_border, color: Colors.red),
                    label: const Text(
                      "Add to Wishlist",
                      style: TextStyle(color: Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.pinkAccent),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
