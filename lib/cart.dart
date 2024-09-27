import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  static final String id = 'CartPage';

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark; // Detect dark mode

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        backgroundColor: Color(0xFF978D4F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // cart items
            Expanded(
              child: ListView(
                children: [
                  _cartItem(
                    context,
                    'Uplifting Sweet Orange & Vanilla Soap Bar',
                    'Made with sustainably sourced, naturally-derived ingredients...',
                    'images/ethiqueshampoo1.png',
                    2,
                    'LKR 2750.00',
                  ),
                  SizedBox(height: 16.0),
                  _cartItem(
                    context,
                    'Minimalist™ Unscented Deodorant Stick',
                    'Stay fresh and confident all day long with our Minimalist solid...',
                    'images/ethiqueshampoo2.png',
                    1,
                    'LKR 2100.00',
                  ),
                  _cartItem(
                    context,
                    'Rustic™ Citrus & Earthy Deodorant Stick',
                    'Natural, effective protection with lime, cedarwood, and eucalyptus scent',
                    'images/ethiquedeodrant1.png',
                    1,
                    'LKR 3200.00',
                  ),
                  _cartItem(
                    context,
                    'Lightweight Conditioner Bar for Fine Hair: Wonderbar™',
                    'Greasy scalp or oily hair? Wonderbar will nourish and condition...',
                    'images/ethiqueshampoo5.png',
                    1,
                    'LKR 1700.00',
                  ),


                ],
              ),
            ),

            // Checkout section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xFF978D4F),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(
                      fontFamily: "Roboto",
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'LKR 6500.00',
                    style: TextStyle(
                      fontFamily: "Roboto",
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 18.0,
                    ),
                  ),

                  SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                      ),
                      onPressed: () {

                      },
                      child: Text(
                        'Proceed to Checkout',
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cartItem(BuildContext context, String productName, String description, String imagePath, int quantity, String price) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
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
              child: Image.asset(
                imagePath,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    description,
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 14.0,
                      color: isDarkMode ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.0),

                  // quantitiy section (+ and -)
                  Row(
                    children: [
                      _quantityBtn(Icons.remove),
                      SizedBox(width: 8.0),
                      Text(
                        '$quantity',
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(width: 8.0),
                      _quantityBtn(Icons.add),
                    ],
                  ),
                  SizedBox(height: 2.0),
                  Text(
                    price,
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quantityBtn(IconData icon) {
    return Container(
      height: 32.0,
      width: 32.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 20.0),
        onPressed: () {

        },
      ),
    );
  }
}
