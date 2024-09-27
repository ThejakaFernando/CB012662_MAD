import 'package:flutter/material.dart';
import 'cart.dart';

class WishlistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist'),
        backgroundColor: Color(0xFF978D4F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _wishlistCard(
              context,
              'Clarifying Shampoo Bar for Oily Scalp and Hair: St Clements™',
              'A perfect solution for oily scalps, made with lime and orange essential oils for deep cleansing.',
              'images/ethiqueshampoo1.png',
              'LKR 1750.00',
            ),
            SizedBox(height: 8.0),

            _wishlistCard(
              context,
              'Minimalist™ Unscented Deodorant Stick',
              'Stay fresh and confident all day long with our'
                  'Minimalist solid natural deodorant stick.',
              'images/ethiquedeodrant3.png',
              'LKR 1550.00',
            ),
          ],
        ),
      ),
    );
  }

  Widget _wishlistCard(
      BuildContext context,
      String productName,
      String description,
      String imagePath,
      String price,
      ) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // gets the screen width for responsive UI
    double screenWidth = MediaQuery.of(context).size.width;

    //Defininf the base font size and adjust based on screen width
    double baseFontSize = 14.0;
    double adjustedFontSize = baseFontSize + (screenWidth * 0.01);

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                imagePath,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 12.0),
            Text(
              productName,
              style: TextStyle(
                fontFamily: "Roboto",
                fontSize: adjustedFontSize + 3.0,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              description,
              style: TextStyle(
                fontFamily: "Roboto",
                fontSize: adjustedFontSize,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              price,
              style: TextStyle(
                fontFamily: "Roboto",
                fontSize: adjustedFontSize + 2.0,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _actionButton(
                  'Add to Cart',
                  Icons.shopping_cart,
                  isDarkMode ? Colors.white : Colors.black,
                  context,
                      () {
                    // handles the add to cart function, with the method 'navTransition' (transition part)
                    navTransition(context, CartPage());
                  },
                ),
                SizedBox(width: 8.0),
                _actionButton(
                  'Remove from Wishlist',
                  Icons.delete,
                  Colors.red,
                  context,
                      () {
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
      String label,
      IconData icon,
      Color iconColor,
      BuildContext context,
      VoidCallback onPressed,
      ) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        side: BorderSide(color: iconColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon, color: iconColor),
      label: Text(
        label,
        style: TextStyle(color: iconColor),
      ),
    );
  }

  void navTransition(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // fade transition
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}
