import 'package:cb012662/wishlist.dart';
import 'package:flutter/material.dart';
import 'cart.dart';
import 'product1.dart';

class ProductsPage extends StatelessWidget {
  static final String id = 'ProductsPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        backgroundColor: Color(0xFF978D4F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // enables scrolling (no overflow)
          child: Column(
            children: [
              _productCard(
                context,
                'Clarifying Shampoo Bar for Oily Scalp and Hair: St Clements™',
                'Our most clarifying shampoo is perfect for oily scalps, and for '
                    'those who want a deep cleanse. Lift away impurities with the help '
                    'of lime and orange essential oils and effective surfactants for full, fresh hair!',
                'images/ethiqueshampoo1.png',
                'LKR 1750.00',
                true, // Indicates this is the first product
              ),
              SizedBox(height: 18),
              _productCard(
                context,
                'Uplifting Sweet Orange & Vanilla Soap Bar',
                'Made with sustainably sourced, naturally-derived '
                    'ingredients including olive and coconut oils, our vegan '
                    'soap bars are deliciously bubbly and non-drying.',
                'images/ethiqueshampoo2.png',
                'LKR 2100.00',
                false,
              ),
              SizedBox(height: 18),
              _productCard(
                context,
                'Minimalist™ Unscented Deodorant Stick',
                'Stay fresh and confident all day long with our '
                    'Minimalist solid natural deodorant stick. '
                    'A clever combination of bamboo powder, zinc oxide, '
                    'and magnesium hydroxide absorb moisture and prevent '
                    'odors to keep underarms smelling fresh and feeling dry.',
                'images/ethiquedeodrant3.png',
                'LKR 1550.00',
                false,
              ),
              SizedBox(height: 18),
              _productCard(
                context,
                'Lightweight Conditioner Bar for Fine Hair: Wonderbar™',
                'The lightest, dreamiest conditioner bar that Ethique has to offer! '
                    'Packed with fairly traded coconut oil, cocoa butter, and vitamin B5. '
                    'Finally, you can tame flyaways, detangle hair, and nourish without '
                    'adding weight or overloading the hair.',
                'images/ethiqueshampoo5.png',
                'LKR 1200.00',
                false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _productCard(
      BuildContext context,
      String productName,
      String description,
      String imagePath,
      String price,
      bool isFirstProduct,
      ) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // getting the screen width using mediaq uery
    double screenWidth = MediaQuery.of(context).size.width;

    // Base font size and adjust based on screen width
    double baseFontSize = 12.0;
    double newFontSize = baseFontSize + (screenWidth * 0.01);

    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                imagePath,
                height: 190,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 12.0),
            Text(
              productName,
              style: TextStyle(
                fontFamily: "Roboto",
                fontSize: newFontSize + 2.0,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              description,
              style: TextStyle(
                fontFamily: "Roboto",
                fontSize: newFontSize,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              price,
              style: TextStyle(
                fontFamily: "Roboto",
                fontSize: newFontSize + 1.0,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 9.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _actionBtn(
                  'Add to Cart',
                  Icons.shopping_cart,
                  isDarkMode ? Colors.white : Colors.black,
                  context,
                      () {
                    navTransition(context, CartPage());
                  },
                ),
                SizedBox(height: 8.0),
                _actionBtn(
                  'Add to Wishlist',
                  Icons.favorite,
                  isDarkMode ? Colors.white : Colors.black,
                  context,
                      () {
                    navTransition(context, WishlistPage());
                  },
                ),
                SizedBox(height: 8.0),
                _actionBtn(
                  '',
                  Icons.remove_red_eye,
                  isDarkMode ? Colors.white : Colors.black,
                  context,
                      () {
                    // Navigate to product1.dart file
                    if (isFirstProduct) {
                      navTransition(context, Product1());
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn(
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
      onPressed: onPressed, // Directly use the onPressed callback
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
          // Apply a fade transition
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}
